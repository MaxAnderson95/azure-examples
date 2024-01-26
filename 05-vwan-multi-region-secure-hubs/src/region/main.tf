terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.87.0"
    }
  }
}

locals {
  numeral_prefix = "05"
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
