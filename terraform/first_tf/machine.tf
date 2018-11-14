resource "azurerm_resource_group" "newgroup" {
  name     = "${format("%v-terraform-rg", var.prefix)}"
  location = "${var.location}"
}
