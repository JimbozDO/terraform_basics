provider "aws" {
    region = "eu-central-1"
    shared_credentials_file = "$HOME/.aws/credentials"
    profile = "mixpanel_dev"
}

resource "aws_instance" "Ubuntu_server" {
    ami = "ami-05f7491af5eef733a"
    instance_type = "t2.micro"
    key_name = "ec2"        # use existing region key pare 
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    tags = {
    Name = "Ubuntu server"
    Owner = "oleksandr kashcheiev"
  }
}

resource "aws_instance" "Linux_server" {
    ami = "ami-089b5384aac360007"
    instance_type = "t2.micro"
    key_name = "ec2"        # use existing region key pare
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    tags = {
    Name = "Amazon Linux 2 AMI"
    Owner = "oleksandr kashcheiev"
  }
}

# create security group. will be assigned to instances above
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh connection and http traffic, testing purpose"

  ingress {
    description      = "ssh access from private IPs"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["91.222.16.134/32", "84.234.108.150/32", "176.37.112.216/32"]
  }

  # allow all outgoing traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_access"
    Goal = "test purpouse"
    Owner = "oleksandr kashcheiev"
  }
}