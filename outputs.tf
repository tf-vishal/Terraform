output "ec2_public_ip" {
    value = aws_instance.my_instance[*].public_ip # [*] is used if instance are more than 1
} #we will use aws_instance.my_instance.public_ip for single instance

output "ec2_public_dns" {
    value = aws_instance.my_instance[*].public_dns
}

output "ec2_private_ip" {
    value = aws_instance.my_instance[*].private_ip
}