resource "azurerm_virtual_network" "spoke-vnet1" {
  name                = "${local.numeral_prefix}-${var.region}-spoke-vnet1"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.region
  address_space       = [var.address_space[1]]
}

resource "azurerm_subnet" "spoke1-workload1" {
  name                 = "workload1"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet1.name
  address_prefixes     = [cidrsubnet(var.address_space[1], 8, 1)]
}

resource "azurerm_virtual_network" "spoke-vnet2" {
  name                = "${local.numeral_prefix}-${var.region}-spoke-vnet2"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.region
  address_space       = [var.address_space[2]]
}

resource "azurerm_subnet" "spoke2-workload1" {
  name                 = "workload1"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet2.name
  address_prefixes     = [cidrsubnet(var.address_space[2], 8, 1)]
}
