variable "aws_region" {
  description = "AWS region we are using to deploy"
  default = "eu-west-1"
}

variable "project" {
  description = "The project name"
  default = "test2"
}

variable "cidr_block" {
  type = "map"
  default = {
    staging = "10.201.0.0/16"
    default = "10.202.0.0/16"
  }
}
variable "port_number" {
  type = "list"
  default = ["80","443","8080"]
}

variable "sg_count" {
  type = "map"
  default = {
    staging = "3"
    default = "2"
  }
}
