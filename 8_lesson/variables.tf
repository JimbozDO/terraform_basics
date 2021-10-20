variable "aws_region" {
  default = "eu-central-1"
  description = "AWS region by default"
}

variable "creds_file_path" {
  default = "$HOME/.aws/credentials"
  description = "local path to credentials file"
}

variable "profile" {
  default = "mixpanel_dev"
  description = "profile name"
}