#Required Variables
variable "resource_group_name" {
  type        = string
  description = "The name of an existing Resource Group to deploy the security services into."
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
  default     = ["deny_all_inbound_access", "deny_all_outbound_access"]
}

variable "custom_security_rules" {
  type = map(object({
    priority                                                   = number
    direction                                                  = string
    access                                                     = string
    protocol                                                   = string
    source_port_ranges                                         = list(string)
    source_address_prefixes                                    = list(string)
    destination_port_ranges                                    = list(string)
    destination_address_prefixes                               = list(string)
    destination_application_security_group_name                = string
    destination_application_security_group_resource_group_name = string
    })
  )
  description = "A list of security rule maps that can be used to define custom security rules to apply to the Network Security Group."
  default     = {}
}


