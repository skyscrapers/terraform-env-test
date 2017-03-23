variable "aws_region" {
  description = "AWS region we are using to deploy"
  default = "eu-west-1"
}

variable "project" {
  description = "The project name"
  default = "test"
}

variable "cidr_block" {
  default = "10.200.0.0/16"
}
