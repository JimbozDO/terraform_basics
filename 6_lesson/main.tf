provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "mixpanel_dev"
}

# Availability Zones which can be accessed by an AWS account within the region
data "aws_availability_zones" "current" {}

# account ID, User ID, and ARN which currntly using terraform
data "aws_caller_identity" "current" {}

# details about a specific AWS region
data "aws_region" "current" {}

# getting back a list of VPC Ids for a region
data "aws_vpcs" "all_ids" {}


# provides details about a specific VPC
data "aws_vpc" "mix-pannel" {
  tags =  {
    Name = "mix-pannel-dev-vpc"
  }
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
output "caller_user_id" {
  value = data.aws_caller_identity.current.user_id
}
# possible get all Attributes at once (probably for all data ?)
output "caller_user" {
  value = data.aws_caller_identity.current
}


output "availability_zones-all_names" {
  value = data.aws_availability_zones.current.names
}
# as list index
output "availability_zone-0" {
  value = data.aws_availability_zones.current.names[0]
}
output "availability_zones-all" {
  value = data.aws_availability_zones.current
}


output "aws_region_name" {
  value = data.aws_region.current.name
}
output "aws_region_full_info" {
  value = data.aws_region.current
}

# return all available vpcs in region
output "all_vpcs_in_region" {
  value = data.aws_vpcs.all_ids.ids
}

# getting vpc id according to the tag
output "mix-pannel_vpc_id" {
  value = data.aws_vpc.mix-pannel.id
  
}

# vpc according to the tag cidr blocks
output "mix-pannel_vpc_cidr_blocks" {
  value = data.aws_vpc.mix-pannel.cidr_block
  
}