#Required Variables
variable "resource_group_name" {
  type        = string
  description = "The name of an existing Resource Group to deploy the security services into."
}

variable "associated_subnet_name" {
  type        = string
  description = "The name of the Azure networking subnet to associate this Network Security Group with."
}

variable "associated_virtual_network_name" {
  type        = string
  description = "The name of the Azure virtual network in which the subnet resides within to associate this Network Security Group with."
}

#Optional Variables
variable "prefix" {
  type        = list(string)
  description = "A naming prefix to be used in the creation of unique names for Azure resources."
  default     = []
}

variable "suffix" {
  type        = list(string)
  description = "A naming suffix to be used in the creation of unique names for Azure resources."
  default     = []
}

variable "security_rule_names" {
  type        = set(string)
  description = "A list of security rule names that are preconfigured within the Network Security Group module."
  default     = ["DenyInternetInBound", "DenyInternetOutBound"]
  #To specify an empty Network Security Group, a Network Security Group with no associated rules define an empty set []
}



