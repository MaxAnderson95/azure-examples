resource "azurerm_virtual_network" "vnet" {
  name                = "${local.numeral_prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.address_space
}

resource "azurerm_subnet" "workload1" {
  name                 = "workload1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 8, 1)]
}

resource "azurerm_route_table" "workload1" {
  name                = "workload1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_route" "default" {
  name                = "default"
  resource_group_name = azurerm_resource_group.rg.name
  route_table_name    = azurerm_route_table.workload1.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type = 
}