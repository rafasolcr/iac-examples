provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
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

resource "aws_instance" "ec2-instance-ll" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "${var.instance_size}"
  key_name      = "${var.ami_key_pair_name}"
  count         = "${length(var.private_ips)}"
  root_block_device {
    delete_on_termination = true
  }
  network_interface {
    network_interface_id = "${aws_network_interface.ni-ll.*.id[count.index]}"
    device_index         = 0
  }
  tags = {
    Name = "ec2 instance_${count.index + 1}"
  }
}

resource "aws_network_interface" "ni-ll" {
  subnet_id   = "${var.subnet_id}"
  private_ips = ["${var.private_ips[count.index]}"]
  count       = "${length(var.private_ips)}"
  tags = {
    Name = "primary_network_interface_ll_${count.index + 1}"
  }
}

resource "aws_eip" "instance-ip-ll" {
  instance = "${aws_instance.ec2-instance-ll.*.id[count.index]}"
  vpc      = true
  count    = "${length(var.private_ips)}"
  tags = {
    Name = "public-instance-ip-ll_${count.index + 1}"
  }
}

output "public_dns" {
  value = "${aws_eip.instance-ip-ll.*.public_dns}"
}

output "private_ip" {
  value = "${aws_instance.ec2-instance-ll.*.private_ip}"
}
