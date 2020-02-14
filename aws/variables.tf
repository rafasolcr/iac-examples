variable "ami_key_pair_name" {
  default = "default"
}

variable "instance_size" {
  description = "size of the EC2 instance"
  default     = "t2.micro"
}

variable "subnet_id" {
  default = "subnet-cc6af2e2"
}

variable "private_ips" {
  default = ["172.31.80.10", "172.31.80.11", "172.31.80.12"]
}
