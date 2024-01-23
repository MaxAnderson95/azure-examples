resource "azurerm_virtual_network" "hub-vnet" {
  name                = "${local.numeral_prefix}-hub-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.address_space[0]]
}

resource "azurerm_virtual_network" "spoke-vnet1" {
  name                = "${local.numeral_prefix}-spoke-vnet1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.address_space[1]]
}

resource "azurerm_subnet" "spoke1-workload1" {
  name                 = "workload1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet1.name
  address_prefixes     = [cidrsubnet(var.address_space[1], 8, 1)]
}

resource "azurerm_virtual_network" "spoke-vnet2" {
  name                = "${local.numeral_prefix}-spoke-vnet2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.address_space[2]]
}

resource "azurerm_subnet" "spoke2-workload1" {
  name                 = "workload1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet2.name
  address_prefixes     = [cidrsubnet(var.address_space[2], 8, 1)]
}

resource "azurerm_virtual_network_peering" "hub-to-spoke1" {
  name                      = "hub-to-spoke1"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke-vnet1.id
}

resource "azurerm_virtual_network_peering" "hub-to-spoke2" {
  name                      = "hub-to-spoke2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke-vnet2.id
}

resource "azurerm_virtual_network_peering" "spoke1-to-hub" {
  name                      = "spoke1-to-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.spoke-vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "spoke2-to-hub" {
  name                      = "spoke2-to-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.spoke-vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id
  allow_forwarded_traffic   = true
}
