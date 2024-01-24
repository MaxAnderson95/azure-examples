terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "maxandersontfstate"
    container_name       = "tfstate"
    key                  = "04-vwan-single-secure-hub.terraform.tfstate"
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
  numeral_prefix = "04"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.numeral_prefix}-vwan-single-secure-hub.terraform"
  location = var.region
}
