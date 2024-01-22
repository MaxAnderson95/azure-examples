terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "maxandersontfstate"
    container_name       = "tfstate"
    key                  = "02-single-vnet-azfw.terraform.tfstate"
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
  numeral_prefix = "02"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.numeral_prefix}-single-vnet-natgw"
  location = var.region
}
