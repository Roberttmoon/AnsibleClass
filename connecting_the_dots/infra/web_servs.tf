module "webservs" {
  source = "../tf_modules/vm"

  resource_gorup_name = "${azurerm_resource_group.app_group.name}"
  location            = "${var.location}"
  vm_count            = 2
  prefix              = "${var.prefix}"
  app                 = "${var.app}-webserv"
  computer_name       = "${lower(replace(format("%v-%v-webserv", var.prefix, var.app), "-|_", ""))}"
  tags                = "${var.tags}"
}

module "loadbal" {
  source = "../tf_modules/vm"

  resource_gorup_name = "${azurerm_resource_group.app_group.name}"
  location            = "${var.location}"
  vm_count            = 1
  prefix              = "${var.prefix}"
  app                 = "${var.app}-lb"
  computer_name       = "${lower(replace(format("%v-%v-lb", var.prefix, var.app), "-|_", ""))}"
  tags                = "${var.tags}"
}
