# find latest AMI id for:
#   Ubuntu
#   Amazone linux
#   Windows server

provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = var.creds_file_path
  profile                 = var.profile
}

# will return only 1 ami hence "most_recent" required
# (relevant for all 3 cases)
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "latest_windows_server" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}
