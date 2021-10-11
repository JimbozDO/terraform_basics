provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "mixpanel_dev"
}

resource "aws_instance" "ubuntu_db_server" {
  ami                         = "ami-05f7491af5eef733a"
  instance_type               = "t2.micro"
  key_name                    = "ec2" # use existing key
  vpc_security_group_ids      = [aws_security_group.terraform_mixpanel.id]
  subnet_id                   = var.custom_subnet
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
sudo apt-get update 
EOF

  tags = {
    Name  = "Ubuntu server database"
    Owner = "oleksandr kashcheiev"
    Goal  = "test purpose"
  }

  # to minimise server downtime
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "linux" {
  ami                         = "ami-089b5384aac360007"
  instance_type               = "t2.micro"
  key_name                    = "ec2" # use existing key
  vpc_security_group_ids      = [aws_security_group.terraform_mixpanel.id]
  subnet_id                   = var.custom_subnet
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
sudo apt-get update 
EOF

  depends_on = [aws_instance.ubuntu_db_server]

  tags = {
    Name  = "Linux server"
    Owner = "oleksandr kashcheiev"
    Goal  = "test purpose"
  }

  # to minimise server downtime
  lifecycle {
    create_before_destroy = true
  }
}


# assign security group already existing.
resource "aws_security_group" "terraform_mixpanel" {
  name        = "terraform_mixpanel_tetsing"
  description = "Allow ssh connection and http/s traffic, test purpose"
  vpc_id      = var.custom_vpc


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
    Name  = "allow_ssh_http_https"
    Goal  = "test purpose"
    Owner = "oleksandr kashcheiev"
  }
}