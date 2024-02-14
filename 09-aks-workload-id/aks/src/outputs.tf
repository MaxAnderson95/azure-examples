output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "kube_admin_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config
  sensitive = true
}

output "user_assigned_identity_client_id" {
  value = azurerm_user_assigned_identity.aks.client_id
}
