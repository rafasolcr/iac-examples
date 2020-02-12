provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

resource "aws_vpc" "vpc_ll" {
  cidr_block = "10.0.0.0/16"
}

data "aws_subnet_ids" "all" {
  vpc_id = "resource.aws_vpc.vpc_ll.id"
}

data "aws_ami" "centos" {
owners      = ["679593333241"]
most_recent = true

  filter {
      name   = "name"
      values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
      name   = "architecture"
      values = ["x86_64"]
  }

  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }
}


module "security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name = "sg_ll"
  description = "Security group for Lunch and Learn example"
  vpc_id = "data.aws_vpc.vpc_ll.id"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["http-80-tcp", "all-icmp"]
  egress_rules = ["all-all"]
}

resource "aws_placement_group" "web" {
  name = "ll-pg"
  strategy = "cluster"
}

resource "aws_kms_key" "this" {
}

resource "aws_network_interface" "this" {
  count = 1

  subnet_id = tolist(data.aws_subnet_ids.all.ids)[count.index]
}

#https://www.terraform.io/docs/providers/aws/r/instance.html

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
