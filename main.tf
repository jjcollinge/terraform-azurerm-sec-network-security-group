provider "azurerm" {
  version = "~>2.0"
  features {}
}

locals {
  predefined_security_rule_map = {
    "deny_all_inbound_access" = {
      "priority"                                   = 100
      "direction"                                  = "Inbound"
      "access"                                     = "Deny"
      "protocol"                                   = "*"
      "source_port_ranges"                         = ["*"]
      "source_address_prefixes"                    = ["*"]
      "destination_port_ranges"                    = ["*"]
      "destination_address_prefixes"               = ["*"]
      "destination_application_security_group_ids" = []
    },
    "deny_all_outbound_access" = {
      "priority"                                   = 101
      "direction"                                  = "Outbound"
      "access"                                     = "Deny"
      "protocol"                                   = "*"
      "source_port_ranges"                         = ["*"]
      "source_address_prefixes"                    = ["*"]
      "destination_port_ranges"                    = ["*"]
      "destination_address_prefixes"               = ["*"]
      "destination_application_security_group_ids" = []
    }
  }
}
module "naming" {
  source = "git@github.com:Azure/terraform-azurerm-naming"
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = module.naming.network_security_group.name
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name
}

resource "azurerm_network_security_rule" "built_in_network_security_rule" {
  for_each                                   = var.security_rule_names
  resource_group_name                        = data.azurerm_resource_group.base.name
  network_security_group_name                = azurerm_network_security_group.network_security_group.name
  name                                       = each.key
  priority                                   = local.predefined_security_rule_map[each.value].priority
  direction                                  = local.predefined_security_rule_map[each.value].direction
  access                                     = local.predefined_security_rule_map[each.value].access
  protocol                                   = local.predefined_security_rule_map[each.value].protocol
  source_port_ranges                         = local.predefined_security_rule_map[each.value].source_port_ranges
  destination_port_ranges                    = local.predefined_security_rule_map[each.value].destination_port_ranges
  source_address_prefixes                    = local.predefined_security_rule_map[each.value].source_address_prefixes
  destination_address_prefixes               = local.predefined_security_rule_map[each.value].destination_address_prefixes
  destination_application_security_group_ids = local.predefined_security_rule_map[each.value].destination_application_security_group_ids
}

resource "azurerm_network_security_rule" "custom_network_security_rule" {
  for_each                                   = var.custom_security_rules
  resource_group_name                        = data.azurerm_resource_group.base.name
  network_security_group_name                = azurerm_network_security_group.network_security_group.name
  name                                       = each.key
  priority                                   = each.value.priority
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_port_ranges                         = each.value.source_port_ranges
  source_address_prefixes                    = each.value.source_address_prefixes
  destination_port_ranges                    = each.value.destination_port_ranges
  destination_address_prefixes               = each.value.destination_address_prefixes
  destination_application_security_group_ids = [data.azurerm_application_security_group.base[each.key].id]
}
