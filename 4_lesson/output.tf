output "instance_public_ip_address" {
    value = aws_instance.amazon_linux_2_ami.public_ip
}

output "instance_id" {
    value = aws_instance.amazon_linux_2_ami.id
}

output "instance_ssh_key_name" {
    value = aws_instance.amazon_linux_2_ami.key_name
}

output "attached_aws_security_group" {
    value = aws_security_group.portfolio_group.id
}