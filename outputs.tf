output "network_security_groups" {
  value = azurerm_network_security_group.network_security_group
}

output "network_security_group_association" {
  value = azurerm_subnet_network_security_group_association.nsg_asso
}