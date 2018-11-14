resource "azurerm_virtual_machine" "main" {
  resource_group_name = "${azurerm_resource_group.new_group.name}"
  name                = "${format("%v-terraform-vnet", var.prefix)}"
  location            = "${var.location}"

  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_DS1_v2"
}

resource "azurerm_network_interface" "nic" {
  resource_group_name = "${azurerm_resource_group.new_group.name}"
  name                = "${format("%v-terraform-vnet", var.prefix)}"
  location            = "${var.location}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "dynamic"
  }
}
