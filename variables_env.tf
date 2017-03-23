variable "cidr_block" {
  type = "map"
  default = {
    staging = "10.201.0.0/16"
    default = "10.200.0.0/16"
    production = "10.201.0.0/16"
  }
}

variable "sg_count" {
  type = "map"
  default = {
    staging = "2"
    default = "2"
    production = "3"
  }
}
