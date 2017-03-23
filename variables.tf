variable "aws_region" {
  description = "AWS region we are using to deploy"
  default = "eu-west-1"
}

variable "project" {
  description = "The project name"
  default = "test2"
}

variable "port_number" {
  type = "list"
  default = ["80","443","8080"]
}
