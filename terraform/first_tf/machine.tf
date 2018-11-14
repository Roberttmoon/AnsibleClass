resource "azurerm_resource_group" "newgroup" {
  name     = "${format("%v-terraform-rg", $prefix)}"
  location = "${var.location}"
}
