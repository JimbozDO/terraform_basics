#-----------------------------------------------------------
# Create:
#    1 Security Group for Web Server (ssh + http)
#    2 Launch Configuration with Auto AMI
#    3 Auto Scaling Group using 2 Availability Zones
#    4 Classic Load Balancer in 2 Availability Zones
#    5 get default subnet from az
#-----------------------------------------------------------

# preparation and data
provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = var.creds_file_path
  profile                 = var.profile
}

# getting list of all available AZ
data "aws_availability_zones" "available" {}

# getting latest 2 linux AMI
data "aws_ami" "latest_amazon_2_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#-----------------------------------------------------------
# 1 Security Group for Web Server (ssh + http)

resource "aws_security_group" "webserver_tf" {
  name        = "webserver_group"
  description = "managed by terraform"

  # allow ssh and http
  dynamic "ingress" {
    for_each = ["22", "80"]

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
    "owner" = "o.kashcheiev"
    "goal"  = "testing"
  }
}

#-----------------------------------------------------------
# 2 Launch Configuration with Auto AMI

resource "aws_launch_configuration" "webserver_tf" {
  name          = "webserver"
  image_id      = data.aws_ami.latest_amazon_2_linux.id
  instance_type = "t3.micro"

  security_groups = [aws_security_group.webserver_tf.id] # associate with sg 
  user_data       = file("simple_html.sh")               # execute sh script after each instance launch

  lifecycle {
    create_before_destroy = true
  }
}

#-----------------------------------------------------------
# 3 Auto Scaling Group using 2 Availability Zones

resource "aws_autoscaling_group" "webserver_tf" {
  name                 = "webserver"
  launch_configuration = aws_launch_configuration.webserver_tf.name
  max_size             = 2
  min_size             = 2
  min_elb_capacity     = 2                                                                            # only on creation Terraform will wait this number of instances from Auto Scaling Group to become healthy in the ELB
  health_check_type    = "ELB"                                                                        # "EC2" or "ELB"
  vpc_zone_identifier  = [aws_default_subnet.default_az1_tf.id, aws_default_subnet.default_az2_tf.id] # list of subnet IDs to launch resources in
  load_balancers       = [aws_elb.balancer_tf.name]

  dynamic "tag" {
    for_each = {
      owner   = "o.kashcheiev"
      goal    = "testing"
      tagname = "tagvalue"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

#-----------------------------------------------------------
# 4 Classic Load Balancer in 2 Availability Zones

resource "aws_elb" "balancer_tf" {
  name               = "web-tf-dev"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.webserver_tf.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  tags = {
    "owner" = "o.kashcheiev"
    "goal"  = "testing"
  }
}

#-----------------------------------------------------------
# 4 get default subnet from az

resource "aws_default_subnet" "default_az1_tf" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_default_subnet" "default_az2_tf" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

#-----------------------------------------------------------
output "web_loadbalancer_url" {
  value = aws_elb.balancer_tf.dns_name
}
