variable "region" {
  description = "Azure Region to deploy resources"
  type        = string
}

variable "address_space" {
  description = "A list of address spaces which will be used by subnets"
  type        = list(string)
}

variable "vm_admin_user" {
  description = "The admin username for the VMs"
  type        = string
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "The admin password for the VMs"
  type        = string
  sensitive   = true
}
