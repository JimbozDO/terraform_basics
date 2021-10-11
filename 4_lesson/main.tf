provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "my_acc"
}

resource "aws_instance" "amazon_linux_2_ami" {
  ami                         = "ami-07df274a488ca9195"
  instance_type               = "t2.micro"
  key_name                    = "Frankfurt_new" # use existing key pair
  vpc_security_group_ids      = [aws_security_group.portfolio_group.id]
  associate_public_ip_address = true

  # update packeges before start work
  user_data = <<EOF
#!/bin/bash
sudo yum update 
EOF

  tags = {
    Name  = "amazon linux"
    Owner = "oleksandr kashcheiev"
  }

  # to minimise webserver downtime
  lifecycle {
    create_before_destroy = true
  }
}

# create security group. will be assigned to instances above
resource "aws_security_group" "portfolio_group" {
  name        = "allow_ssh_and_http"
  description = "Allow ssh connection and http traffic, portfolio"


  dynamic "ingress" {
    for_each = ["80", "443", "22"]
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
    Name  = "portfolio"
    Goal  = "portfolio web site for V.Kashcheieva"
    Owner = "oleksandr kashcheiev"
  }
}