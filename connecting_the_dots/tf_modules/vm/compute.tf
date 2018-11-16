resource "azurerm_virtual_machine" "main" {
  count               = "${var.vm_count}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  name                = "${format("%v-%v-vm-%v", var.prefix, var.app, count.index)}"
  tags                = "${var.tags}"

  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk = {
    name              = "${format("%vosdisk%v", computer_name, conunt.index)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${format("%vvm%v", computer_name, count.index)}"
    admin_username = "azureops"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path = "/home/azureops/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/table3-rm-vmkey.pub")}"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.diag_storage.primary_blob_endpoint}"
  }
}

resource "azurerm_network_interface" "nic" {
  count                     = "${var.vm_count}"
  resource_group_name       = "${var.resource_group_name}"
  location                  = "${var.location}"

  name = "${format("%v-%v-nic-%v", var.prefix, var.app, count.index)}"
  
  network_security_group_id = "${azurerm_network_security_group.vm_sg.id}"
  tags                      = "${var.tags}"

  ip_configuration {
    name = "${format("%v%v",computer_name, count.index)}"
    
    subnet_id                     = "${azurerm_subnet.mysub.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.mypubip.*.id}"
  }
}

resource "azurerm_public_ip" "mypubip" {
  count                        = "${var.vm_count}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  
  name = "${format("%v-%v-pubip", var.prefix, var.app)}"
  public_ip_address_allocation = "dynamic"
}


resource "random_id" "boot_diag_id" {
  byte_length = 8
  
  keepers = {
    resource_group="${var.prefix}${var.app}"
  }
}

resource "azurerm_storage_account" "diag_storage" {
  count               = ${var.vm_count}
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  name = "${substr(format("%v%v%v", computer_name, random_id.boot_diag_id.hex, count.index), 0, 24)}"
  
  account_tier             = "standard"
  account_replication_type = "LRS"
  tags                     = "${var.tags}"
}
