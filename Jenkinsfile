Pipeline {
    agent any 

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_REGION = 'eu-north-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 
            }
        }

        stage ('Create S3 Bucket') {
            environment {
                BUCKET_NAME = ""
            }

            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    crdentialsId: ''
                ]]) {
                    sh '''
                        aws s3api create-bucket --bucket "$BUCKET_NAME" --region eu-north-1 --create-bucket-configuration LocationConstraint eu-north-1
                    '''
                }
            }
        }

        stage ('Terraform Init') {
            steps {
                dir('terraform-config') {
                      sh 'terraform init -input=false'
                }
            }
        }

        stage ('Terraform Plan'){
            steps {
                dir ('terraform-config') {
                    sh 'terraform plan -out=tfplan -input=false'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression {return params.APPLY_INFRA == true}
            }
            steps {
                dir ('terraform-config') {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }

        stage ('Terraform Destroy') {
            when {
                expression {return params.DESTROY_INFRA == true}
            }
            steps {
                dir ('terraform-config') {
                    sh 'terraform destroy -auto-approve -input=false'
                }
            }
        }

        stage ('Build and Push Docker Image to ECR'){
            steps {
                script {
                    def app = ''
                    def ecr = aws ecr describe-repositories --repository-name "${app}" --region ${AWS_REGION} || aws ecr create-repository --repository-name "${app}" --region ${AWS_REG}
                    def ecrUri = ecr.repository.repositoryUri

                    sh '''
                        docker compose up -d
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                        docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$app
                    '''
                }
            }
        }

        stage ('Run and Deploy DOcker Application via SSM') {
            steps {
                script {
                    env.EC2_PUBLIC_IP = sh (
                        script: "cd terraform-config && terraform output -raw ec2_public_ip",
                        returnStdout: true
                    ).trim()
                    env.INSTANCE_ID = sh (
                        script: 'cd terraform-config && terraform output -raw instance_id',
                        returnStdout: true
                    ).trim()
                }

                sh '''
                    aws ec2 wait instance-running --instance-id $INSTANCE_ID --region $AWS_REGION

                    COMMAND_ID=$(aws ssm send-command \
                        --instance-id $INSTANCE_ID \
                        --documnet-name "AWS-RunShellScript" \
                        --parameters 'commands=[
                            "sudo systemctl start amazon-ssm-agent",
                            "sudo systemctl enable amazon-ssm-agent",
                            "sudo dnf update -y >/dev/null 2>&1 || true",
                            "sudo systemctl daemon-reload || true",
                            "sudo dnf install -y docker.io docker-compose  || true",
                            "curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" ",
                            "unzip awscli2.zip",
                            "sudo ./aws/install",
                            "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com",
                        ]' \
                    --region $AWS_REGION \
                    --query "Command.CommandId" \
                    --output text)

            echo "Docker deployment command sent.Command ID: $COMMAND_ID"
            

            aws ssm wait command-executed \
                --command-id $COMMAND_ID \
                --instance-id $INSTANCE_ID \
                --region $AWS_REGION 
            
            aws ssm get-command-invocation \
                --command-id $COMMAND_ID \
                --instance-id $INSTANCE_ID \
                --region $AWS_REGION 
            '''

            echo "Application successfully deployed!!"
            }
        }
    }
}