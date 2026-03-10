data "aws_iam_role" "ssm_role" {
    name = "SSMRoleForEC2"
}

resource "aws_iam_role_policy_attachment" "ssm_role_attach" {
    role = data.aws_iam_role.ssm_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_instance_profile" "ssm_instance_profile" {
    name = "SSMInstanceProfile"
}

resource "aws_instance" "ec2_instance" {
    ami = var.ec2_ami
    instance_type = var.ec2_instance_type
    subnet_id = aws_subnet.public_subnet.id
    iam_instance_profile = data.aws_iam_instance_profile.ssm_instance_profile.name
    security_groups = [aws_security_group.sg.id]

    tags = {
        Name = var.ec2_instance_name
    }
}
    
