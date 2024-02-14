resource "azurerm_user_assigned_identity" "aks" {
  name                = "aks-identity"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_federated_identity_credential" "aks" {
  name                = "myAKSFedIdentity"
  resource_group_name = azurerm_resource_group.rg.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks.id
  subject             = "system:serviceaccount:default:workload-id-sa"
}
