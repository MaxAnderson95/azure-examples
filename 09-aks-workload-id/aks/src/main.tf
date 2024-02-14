terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "maxandersontfstate"
    container_name       = "tfstate"
    key                  = "09-aks-managed-id-aks.terraform.tfstate"
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
  numeral_prefix      = "09"
  resource_group_name = "${local.numeral_prefix}-aks-managed-id-aks"
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.region
}
