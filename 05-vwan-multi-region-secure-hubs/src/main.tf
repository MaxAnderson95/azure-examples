terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "maxandersontfstate"
    container_name       = "tfstate"
    key                  = "05-vwan-multi-region-secure-hubs.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.87.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  numeral_prefix      = "05"
  resource_group_name = "${local.numeral_prefix}-vwan-multi-region-secure-hub"
  virtual_wan_name    = "vwan"
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.region_a # The resource group needs a defined location for metadata, but resources can be deployed to other regions
}

resource "azurerm_virtual_wan" "vwan" {
  name                           = local.virtual_wan_name
  resource_group_name            = azurerm_resource_group.rg.name
  location                       = azurerm_resource_group.rg.location
  allow_branch_to_branch_traffic = true
  type                           = "standard"
}
