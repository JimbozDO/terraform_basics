provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "mixpanel_dev"
}

# create subnet knowing only name
data "aws_vpc" "default-aws-vpc" {
  tags = {
    Name = "default"
  }
}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "current" {}


resource "aws_subnet" "tf_subnet_a" {
  vpc_id            = data.aws_vpc.default-aws-vpc.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = data.aws_availability_zones.current.names[0]
  
  tags = {
    "name"              = "tf_subnet"
    "owner"             = "O.Kashcheiev"
    "vpc"               = "${data.aws_vpc.default-aws-vpc.id}"
    "availability_zone" = "${data.aws_availability_zones.current.names[0]}"
    "caller_user_id"    = "${data.aws_caller_identity.current.user_id}"
  }
}

output "default_vpc_id" {
  value = data.aws_vpc.default-aws-vpc.id
}

output "default_vpc_cidr" {
  value = data.aws_vpc.default-aws-vpc.cidr_block
}

output "tf-subnet-id" {
  value = aws_subnet.tf_subnet_a.id
}