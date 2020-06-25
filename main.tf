provider "azurerm" {
  version = "~>2.0"
  features {}
}

module "naming" {
  source = "git::https://github.com/Azure/terraform-azurerm-naming"
  prefix = var.prefix
  suffix = var.suffix
}

module "rules" {
  source = "git::https://github.com/Azure/terraform-azurerm-sec-network-security-group-rules"
}

locals {
  predefined_rule_names_list = tolist(setintersection(module.rules.names, var.security_rule_names))
  predefined_rule_names = {for r in local.predefined_rule_names_list: index(local.predefined_rule_names_list, r) => r}
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = module.naming.network_security_group.name
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name
}

resource "azurerm_network_security_rule" "built_in_network_security_rule" {
  for_each                    = local.predefined_rule_names
  resource_group_name         = data.azurerm_resource_group.base.name
  network_security_group_name = azurerm_network_security_group.network_security_group.name
  name                        = each.value
  priority                    = 4096 - tonumber(each.key)
  direction                   = module.rules.configurations[each.value].direction
  access                      = module.rules.configurations[each.value].access
  protocol                    = module.rules.configurations[each.value].protocol
  source_port_range           = lookup(module.rules.configurations[each.value], "source_port_range", null)
  source_port_ranges          = lookup(module.rules.configurations[each.value], "source_port_ranges",  null)
  source_address_prefix       = module.rules.configurations[each.value].source_address_prefix
  destination_port_range      = lookup(module.rules.configurations[each.value], "destination_port_range", null)
  destination_port_ranges     = lookup(module.rules.configurations[each.value], "destination_port_ranges", null)
  destination_address_prefix  = module.rules.configurations[each.value].destination_address_prefix
}

resource "azurerm_subnet_network_security_group_association" "nsg_asso" {
  subnet_id                 = data.azurerm_subnet.associated_subnet.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
  depends_on                = [null_resource.module_depends_on]
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}