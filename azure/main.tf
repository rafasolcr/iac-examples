provider "azurerm" {
  version                    = ">=1.40"
  skip_provider_registration = true
}

resource "azurerm_virtual_machine" "azure-vm-ll" {
  name                  = "azure-vm${count.index + 1}"
  location              = "${var.location}"
  resource_group_name   = "${var.local_rg}"
  vm_size               = "${var.vm_size}"
  network_interface_ids = ["${azurerm_network_interface.ll_ni.*.id[count.index]}"]
  count                 = "${length(var.private_ips)}"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name  = "azure-vm${count.index + 1}"
    admin_username = "centos"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/centos/.ssh/authorized_keys"
      key_data = "${var.ssh_key}"
    }
  }

  storage_os_disk {
    name              = "azure_vm${count.index + 1}_os_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.7"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "ll_ni" {
  name                = "primary_network_interface_ll${count.index + 1}"
  location            = "${var.location}"
  resource_group_name = "${var.local_rg}"
  count               = "${length(var.private_ips)}"

  ip_configuration {
    name                          = "ll-ipconfig"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.private_ips[count.index]}"
    public_ip_address_id          = "${azurerm_public_ip.ll_public_ip.*.id[count.index]}"
  }
}

resource "azurerm_public_ip" "ll_public_ip" {
  name                = "public_ip_ll${count.index + 1}"
  location            = "${var.location}"
  resource_group_name = "${var.local_rg}"
  allocation_method   = "Dynamic"
  count               = "${length(var.private_ips)}"
}

output "public_ip" {
  value = "${azurerm_public_ip.ll_public_ip.*.ip_address}"
}

output "private_ip" {
  value = "${azurerm_network_interface.ll_ni.*.private_ip_address}"
}