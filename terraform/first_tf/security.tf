variable "sg_ports" {
  type = "list"
  default = [
    22, 80, 443
  ]
}

resource "azurerm_network_security_group" "vm_sg" {
  resource_group_name = "${azurerm_resource_group.new_group.name}"
  name                = "${format("%v-terraform-sg", var.prefix)}"
  location            = "${var.location}"
}

resource "azurerm_network_security_rule" "rules" {
  count                       = "${length(var.sg_ports)}"
  resource_group_name         = "${azurerm_resource_group.new_group.name}"
  name                        = "${format("%v-terraform-sg-%v", var.prefix, var.sg_ports[count.index])}"
  network_security_group_name = "${azurerm_network_security_group.vm_sg.name}"

  priority                    = "${100 + count.index}"
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "${var.sg_ports[count.index]}"
  destination_port_range      = "${var.sg_ports[count.index]}"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}
