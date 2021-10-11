output "instance_public_ip_ubuntu" {
    value = aws_instance.ubuntu_db_server.public_ip
}

output "instance_public_ip_linux" {
    value = aws_instance.linux.public_ip
}

output "instance_id" {
    value = aws_instance.ubuntu_db_server.id
}

output "instance_ssh_key_name" {
    value = aws_instance.ubuntu_db_server.key_name
}

output "attached_aws_security_group" {
    value = aws_security_group.terraform_mixpanel.id
}
