output "latest_ubuntu_id" {
  value = data.aws_ami.latest_ubuntu.id
}
output "latest_ubuntu_name" {
  value = data.aws_ami.latest_ubuntu.name
}

output "latest_amazon_linux_id" {
  value = data.aws_ami.latest_amazon_linux.id
}
output "latest_amazon_linux_name" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "latest_windows_server_id" {
  value = data.aws_ami.latest_windows_server.id
}
output "latest_windows_server_name" {
  value = data.aws_ami.latest_windows_server.name
}
