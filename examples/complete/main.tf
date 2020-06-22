provider "azurerm" {
  version = "~>2.0"
  features {}
}

locals {
  unique_name_stub = substr(module.naming.unique-seed, 0, 3)
}

module "naming" {
  source = "git::https://github.com/Azure/terraform-azurerm-naming"
}

resource "azurerm_resource_group" "test_group" {
  name     = "${module.naming.resource_group.slug}-${module.naming.network_security_group.slug}-max-test-${local.unique_name_stub}"
  location = "uksouth"
}

resource "azurerm_virtual_network" "example_vnet" {
  name                = "${module.naming.virtual_network.slug}-max-${local.unique_name_stub}"
  resource_group_name = azurerm_resource_group.test_group.name
  location            = azurerm_resource_group.test_group.location
  address_space       = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "example_subnet_predefined_nsg" {
  name                 = "${module.naming.subnet.slug}-predefined-${local.unique_name_stub}"
  resource_group_name  = azurerm_resource_group.test_group.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.example_vnet.address_space[0], 1, 0)]
}

module "predefined_nsg" {
  source                          = "../../"
  resource_group_name             = azurerm_resource_group.test_group.name
  associated_virtual_network_name = azurerm_virtual_network.example_vnet.name
  associated_subnet_name          = azurerm_subnet.example_subnet_predefined_nsg.name
  prefix                          = [local.unique_name_stub]
  suffix                          = [local.unique_name_stub]
  security_rule_names             = ["DenyInternetInBound", "DenyInternetOutBound"]
}

/* resource "azurerm_subnet" "example_subnet_empty_nsg" {
  name                 = "${module.naming.subnet.slug}-empty-${local.unique_name_stub}"
  resource_group_name  = azurerm_resource_group.test_group.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.example_vnet.address_space[0], 1, 1)]
}

module "empty_nsg" {
  source                          = "../../"
  resource_group_name             = azurerm_resource_group.test_group.name
  associated_virtual_network_name = azurerm_virtual_network.example_vnet.name
  associated_subnet_name          = azurerm_subnet.example_subnet_empty_nsg.name
  prefix                          = [local.unique_name_stub]
  suffix                          = [local.unique_name_stub]
  security_rule_names             = []
} */