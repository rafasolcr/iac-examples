variable "location" {
  description = "The location where resources will be created"
  default     = "West US 2"
}

variable "private_ips" {
  default = ["10.251.172.10", "10.251.172.11", "10.251.172.12"]
}

variable "vm_size" {
  description = "size of the VMs: minimum = Standard_D1_v2"
  default     = "Standard_A1_v2"
}
variable "local_rg" {
  description = "Resource in where to create resources"
  default     = "caa_ll_gl"
}

variable "subnet_id" {
  description = "Already existing subnet"
  default     = "/subscriptions/c2ebc8c2-9c26-440c-b66b-b22a104ffe1d/resourceGroups/caa_ll_gl/providers/Microsoft.Network/virtualNetworks/caa_ll_vnet/subnets/caa_ll_snet"
}

variable "ssh_key" {
  description = "Public ssh key to be used for ssh access to the VM"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZB+Fyneg/iScomeQ0/QWJDWiv+RLjxv1N21gTOZJLqjEzuJ6B1ObPXmb6xEUsosl5oAlTmEKaUxPvhtEqFP+nqBIIwakK8m8MJQ54aisTWX4NSchBrOW5RAjURCB51ntWRDGs7hX7SM2eaEAO+OOR17c3glrjvCaBa2InrHFMNiFi4m+efXrv6RFaoZEeuSNYH8QSB3ZRstXxIECWEz2Fov4gRRX+UBz6l/jiX0YrcQT0tdm8CpyXxGi8r4pGNiGo+VU976pHFJUrpnNz/jhmPTNbJ4t8UT7Sbw7APKvwnBM8Jk0WDZOREetZDudsf5LUB7zFhybac7dtIhOAttTR rafaelsolis@LAAPJGSH497-Rafaels.local"
}