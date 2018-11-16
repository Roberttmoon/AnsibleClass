resource "azurerm_app_service_plan" "app_sp" {
  resource_group_name = "${azurerm_resource_group.app_group.name}"
  location            = "${var.location}"
  name                = "${var.prefix}-tfapp-service_paln"

  sku {
    tier = "Standard"
    size  = "S1"
  }
}

resource "azurerm_app_service" "app" {
  resource_group_name = "${azurerm_resource_group.app_group.name}"
  location            = "${var.location}"
  name                = "${var.prefix}-tfapp-app"

  app_service_plan_id = "${azurerm_app_service_plan.app_sp.id}"

  depends_on = [
    "azurerm_app_service_plan.app_sp",
  ]
}
