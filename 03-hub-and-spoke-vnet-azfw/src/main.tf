terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "maxandersontfstate"
    container_name       = "tfstate"
    key                  = "03-hub-and-spoke-vnet-azfw.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.87.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

locals {
  numeral_prefix = "03"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.numeral_prefix}-hub-and-spoke-vnet-azfw"
  location = var.region
}
