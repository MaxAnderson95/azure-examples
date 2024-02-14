terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "maxandersontfstate"
    container_name       = "tfstate"
    key                  = "09-aks-managed-id-k8s.terraform.tfstate"
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.25.2"
    }
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.aks.outputs.kube_admin_config[0].host
  client_certificate     = base64decode(data.terraform_remote_state.aks.outputs.kube_admin_config[0].client_certificate)
  client_key             = base64decode(data.terraform_remote_state.aks.outputs.kube_admin_config[0].client_key)
  cluster_ca_certificate = base64decode(data.terraform_remote_state.aks.outputs.kube_admin_config[0].cluster_ca_certificate)
}

data "terraform_remote_state" "aks" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform"
    storage_account_name = "maxandersontfstate"
    container_name       = "tfstate"
    key                  = "09-aks-managed-id-aks.terraform.tfstate"
  }
}

resource "kubernetes_service_account" "workload-id-sa" {
  metadata {
    name      = "workload-id-sa"
    namespace = "default"
    annotations = {
      "azure.workload.identity/client-id" = data.terraform_remote_state.aks.outputs.user_assigned_identity_client_id
    }
  }
}
