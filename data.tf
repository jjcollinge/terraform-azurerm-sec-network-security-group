data "azurerm_resource_group" "base" {
  name = var.resource_group_name
}

data "azurerm_application_security_group" "base" {
  for_each            = var.custom_security_rules
  resource_group_name = each.value.destination_application_security_group_resource_group_name
  name                = each.value.destination_application_security_group_name
}
