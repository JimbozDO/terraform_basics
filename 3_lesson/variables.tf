variable "aws_region" {
  description = "AWS region by default"
  default     = "eu-central-1"
}

variable "custom_subnet" {
  description = "manually created subnet in eu-central-1"
  default     = "subnet-0b14ff7e85bfb8b4f"
}

variable "custom_vpc" {
  description = "manually created vpc in eu-central-1"
  default     = "vpc-0500edb8863869980"
}