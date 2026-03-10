output "ec2_public_ip" {
    value = aws_instance.ec2_instance.public_ip
}

output "instnace_id" {
    value = aws_instance.ec2_instance.id
}