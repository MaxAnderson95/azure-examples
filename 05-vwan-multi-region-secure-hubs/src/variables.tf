variable "region_a" {
  description = "Azure Region to deploy resources"
  type        = string
}

variable "region_b" {
  description = "Azure Region to deploy resources"
  type        = string
}

variable "address_space_region_a" {
  description = "A list of address spaces which will be used by subnets in region a"
  type        = list(string)
}

variable "address_space_region_b" {
  description = "A list of address spaces which will be used by subnets in region a"
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
