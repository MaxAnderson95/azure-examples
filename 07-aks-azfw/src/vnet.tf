resource "azurerm_virtual_network" "vnet" {
  name                = "aks-1-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "azfw-subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 8, 0)]
}

resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 8, 1)]
}

resource "azurerm_route_table" "azfw-route-table" {
  name                = "azfw-route-table"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.azfw.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "aks-associate-rt" {
  subnet_id      = azurerm_subnet.aks.id
  route_table_id = azurerm_route_table.azfw-route-table.id
}

resource "azurerm_role_assignment" "aks" {
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  scope                = azurerm_virtual_network.vnet.id
  role_definition_name = "Contributor"
}
