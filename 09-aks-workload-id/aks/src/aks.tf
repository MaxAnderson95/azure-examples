resource "azurerm_kubernetes_cluster" "aks" {
  name                      = var.cluster_name
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  dns_prefix                = var.cluster_name
  kubernetes_version        = var.kubernetes_version
  node_resource_group       = "${azurerm_resource_group.rg.name}-node"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_B4ms"
    vnet_subnet_id = azurerm_subnet.aks.id
    upgrade_settings {
      max_surge = "10%"
    }
  }

  network_profile {
    network_plugin      = "azure"
    network_policy      = "cilium"
    ebpf_data_plane     = "cilium"
    network_plugin_mode = "overlay"
    outbound_type       = "loadBalancer"
    pod_cidr            = var.pod_cidr
    service_cidr        = var.service_cidr
    dns_service_ip      = cidrhost(var.service_cidr, 2)
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  azure_active_directory_role_based_access_control {
    managed = true
    admin_group_object_ids = [
      var.admin_group
    ]
  }
}
