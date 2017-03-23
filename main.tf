terraform {

  required_version = ">= 0.9.0"

  backend "s3" {
    bucket = "skyscraperstest-terraform"
    key    = "terraform-env/main2"
    region = "eu-west-1"
    lock_table = "terraform"

  }
}

provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source      = "github.com/skyscrapers/terraform-network//vpc?ref=dee7d31c9d2b7fe58d60fd6c9160ca5e426463f"
  cidr_block  = "${var.cidr_block["${terraform.env}"]}"
  project     = "${var.project}"
  environment = "${terraform.env}"
}

module "nat_gateway" {
  source               = "github.com/skyscrapers/terraform-network//nat_gateway?ref=dee7d31c9d2b7fe58d60fd6c9160ca5e426463f"
  private_route_tables = "${module.vpc.private_rts}"
  public_subnets       = "${module.vpc.public_nat-bastion}"
}

module "general_security_groups" {
  source      = "github.com/skyscrapers/terraform-network//securitygroups?ref=dbc5eadde1f736a272609e71af1b9d539e0fbe60"
  vpc_id      = "${module.vpc.vpc_id}"
  project     = "${var.project}"
  environment = "${terraform.env}"
}

module "bastion" {
  source        = "github.com/skyscrapers/terraform-instances//bastion?ref=20961b3adc785fac8ae1e3bcf11a8e85a8a177b8"
  vpc_id        = "${module.vpc.vpc_id}"
  project       = "${var.project}"
  environment   = "${terraform.env}"
  sg_all_id     = "${module.general_security_groups.sg_all_id}"
  sgs           = ["${module.general_security_groups.sg_all_id}"]
  subnets       = "${module.vpc.public_nat-bastion}"
  ssh_key_name  = "mattias"
  ami           = "ami-70edb016"
  instance_type = "t2.micro"
}

# Allow incoming NRPE check from icinga2 satelite
resource "aws_security_group_rule" "all_ingress_nrpe" {
  count                    = "${var.sg_count["${terraform.env}"]}"
  type                     = "ingress"
  from_port                = "${var.port_number[count.index]}"
  to_port                  = "${var.port_number[count.index]}"
  protocol                 = "tcp"
  security_group_id        = "${module.general_security_groups.sg_all_id}"
  source_security_group_id = "${module.bastion.bastion_sg_id}"
}
