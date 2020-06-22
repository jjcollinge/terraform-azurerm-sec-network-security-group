data "azurerm_resource_group" "base" {
  name = var.resource_group_name
}

data "azurerm_subnet" "associated_subnet" {
  name                 = var.associated_subnet_name 
  virtual_network_name = var.associated_virtual_network_name 
  resource_group_name  = data.azurerm_resource_group.base.name  
}
