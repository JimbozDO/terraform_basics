provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "mixpanel_dev"
}

resource "aws_instance" "Ubuntu_server" {
  ami                         = "ami-05f7491af5eef733a"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.generated_key.id # use generated key pair
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  subnet_id                   = var.custom_subnet
  associate_public_ip_address = true

  # just to understand that possibility exists
  user_data = <<EOF
#!/bin/bash
sudo apt-get update 
EOF

  tags = {
    Name  = "Ubuntu server"
    Owner = "oleksandr kashcheiev"
  }
}

resource "tls_private_key" "developer" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "developer-key"
  public_key = tls_private_key.developer.public_key_openssh
}


# create security group. will be assigned to instances above
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_and_http"
  description = "Allow ssh connection and http traffic, testing purpose"
  vpc_id      = var.custom_vpc

  ingress {
    description = "ssh access from private IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["91.222.16.154/32", "84.234.108.150/32", "176.37.112.216/32"]
  }

  ingress {
    description = "http access from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "allow_ssh_and_http"
    Goal  = "test purpouse"
    Owner = "oleksandr kashcheiev"
  }
}