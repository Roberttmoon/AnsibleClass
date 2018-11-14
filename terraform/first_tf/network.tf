resource "azurerm_virtual_network" "mynet" {
  resource_group_name = "${azurerm_resoruce_group.newgroup.name}"
  name                = "${format("%v-terraform-vnet", var.prefix)}"
  location            = "${var.location}"
  address_space       = ["10.0.0.0/16"]

  tags {
    env   = "testing"
    owner = "robert"
  }
}

resource "arzurerm_subnet" "mysub" {
  resource_group_name  = "${azurerm_resoruce_group.newgroup.name}"
  name                 = "${format("%v-terraform-vnet", var.prefix)}"
  virtual_network_name = "${azurerm_virtual_network.mynet.name}"
  address_prefix       = "10.0.10.0/24"
}

resource "azurerm_public_ip" "mypubip" {
  resource_group_name          = "${azurerm_resoruce_group.newgroup.name}"
  name                         = "${format("%v-terraform-vnet", var.prefix)}"
  location                     = "${var.location}"
  public_ip_address_allocation = "dynamic"
}
