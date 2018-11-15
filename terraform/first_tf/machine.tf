resource "azurerm_virtual_machine" "main" {
  resource_group_name = "${azurerm_resource_group.new_group.name}"
  name                = "${format("%v-terraform-vnet", var.prefix)}"
  location            = "${var.location}"
  tags                = "${var.tags}"

  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk = {
    name              = "table3rmvmstorage"
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
    computer_name  = "table3rmtfvm"
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
  resource_group_name       = "${azurerm_resource_group.new_group.name}"
  name                      = "${format("%v-terraform-vnet", var.prefix)}"
  location                  = "${var.location}"
  network_security_group_id = "${azurerm_network_security_group.vm_sg.id}"
  tags                      = "${var.tags}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.mysub.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.mypubip.id}"
  }
}

resource "random_id" "boot_diag_id" {
  byte_length = 8
  
  keepers = {
    resource_group="${azurerm_resource_group.new_group.name}"
  }
}

resource "azurerm_storage_account" "diag_storage" {
  name                = "${substr(format("table3rmdiag%v", random_id.boot_diag_id.hex), 0, 24)}"
  resource_group_name = "${azurerm_resource_group.new_group.name}"
  location            = "${var.location}"
  
  account_tier             = "standard"
  account_replication_type = "LRS"
  tags                     = "${var.tags}"
}
