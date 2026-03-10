variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type = string
}

variable "vpc_name" {
    description = "Name of the VPC"
    type = string 
}

variable "public_subnet_name" {
    description = "Public subnet name"
    type = string
}

variable "public_subnet_cidr" {
    description = "CIDR block for the public subnet"
    type = string
}

variable "public_subnet_az" {
    description = "Availability zone for the public subnet"
    type = string
}

variable "private_subnet_name" {
    description = "Private subnet name"
    type = string
}

variable "private_subnet_cidr" {
    description = "CIDR block for the private subnet"
    type = string
}

variable "private_subnet_az" {
    description = "Availability zone for the private subnet"
    type = string
}

variable "igw_name" {
    description = "Internet Gateway name"
    type = string
}

variable "public_rt_name" {
    description = "Public route table name"
    type = string
}

variable "ec2_ami" {
    description = "AMI ID for the EC2 instance"
    type = string
}

variable "ec2_instance_type" {
    description = "Instance type for the EC2 instance"
    type = string
}

variable "ec2_instance_name" {
    description = "Name tag for the EC2 instance"
    type = string
}

variable "app_port" {
    description = "Application port to allow inbound traffic"
    type = string
}

variable "ecr_repository_name" {
    description = "Name of the ECR repository"
    type = string
}