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

# use lateste ami to create 
resource "aws_instance" "amazon_linux_2_ami" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tf_mixpanel_test.id]

  tags = {
    Name  = "amazon linux 2"
    Owner = "o.kashcheiev"
  }
}

# the same with Windows
resource "aws_instance" "windows_server" {
  ami                         = data.aws_ami.latest_windows_server.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tf_mixpanel_test.id]


  tags = {
    Name  = "amazon windows"
    Owner = "o.kashcheiev"
  }
}



resource "aws_security_group" "tf_mixpanel_test" {
  name        = "terraform_mixpanel_testing"
  description = "Allow ssh connection only"

  dynamic "ingress" {
    for_each = ["22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "allow_ssh_only"
    Goal  = "test purpose"
    Owner = "o.kashcheiev"
  }
}
