provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.secret}"
  tenant_id       = "${var.tenant}"
}

resource "azurerm_resource_group" "app_group" {
  name     = "${format("%v-$v-rg", var.prefix, var.app_name)}"
  location = "${var.location}"
}
