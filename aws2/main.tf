provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

resource "aws_vpc" "vpc-ll" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "example LL VPC"
  }
}

resource "aws_subnet" "subnet-ll" {
  cidr_block        = "${cidrsubnet(aws_vpc.vpc-ll.cidr_block, 1, 1)}"
  vpc_id            = "${aws_vpc.vpc-ll.id}"
  availability_zone = "us-east-1a"
  tags = {
    Name = "example LL subnet"
  }
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

resource "aws_security_group" "allow-ssh-ll" {
  name   = "allow_ssh_ll"
  vpc_id = "${aws_vpc.vpc-ll.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_all_ll"
  }
}

resource "aws_instance" "ec2-instance-ll" {
  ami             = "${data.aws_ami.centos.id}"
  instance_type   = "t2.micro"
  key_name        = "${var.ami_key_pair_name}"
  security_groups = ["${aws_security_group.allow-ssh-ll.id}"]
  tags = {
    Name = "${data.aws_ami.centos.name}"
  }
  subnet_id = "${aws_subnet.subnet-ll.id}"
}

resource "aws_network_interface" "foo" {
  subnet_id   = "${aws_subnet.subnet-ll.id}"
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_eip" "instance-ip-ll" {
  instance = "${aws_instance.ec2-instance-ll.id}"
  vpc      = true
}

resource "aws_internet_gateway" "gw-ll" {
  vpc_id = "${aws_vpc.vpc-ll.id}"
  tags = {
    Name = "gw-ll"
  }
}

resource "aws_route_table" "route-table-ll" {
  vpc_id = "${aws_vpc.vpc-ll.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw-ll.id}"
  }
  tags = {
    Name = "route-table-ll"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.subnet-ll.id}"
  route_table_id = "${aws_route_table.route-table-ll.id}"
}
