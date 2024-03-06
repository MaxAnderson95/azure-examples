resource "azurerm_virtual_network" "spoke-vnet1" {
  name                = "${local.numeral_prefix}-spoke-vnet1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.address_space[1]]
}

resource "azurerm_subnet" "spoke1-workload1-internal" {
  name                 = "workload1-internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet1.name
  address_prefixes     = [cidrsubnet(var.address_space[1], 8, 1)]
}

resource "azurerm_network_security_group" "workload1-internal" {
  name                = "workload1-internal"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "workload1-internal" {
  subnet_id                 = azurerm_subnet.spoke1-workload1-internal.id
  network_security_group_id = azurerm_network_security_group.workload1-internal.id
}

resource "azurerm_subnet" "spoke1-workload1-dmz" {
  name                 = "workload1-dmz"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet1.name
  address_prefixes     = [cidrsubnet(var.address_space[1], 8, 2)]
}

resource "azurerm_network_security_group" "workload1-dmz" {
  name                = "workload1-dmz"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowOutboundToInternet"
    description                = "Allow traffic to Internet"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    destination_address_prefix = "Internet"
    access                     = "Allow"
    priority                   = 900
    direction                  = "Outbound"
  }

  security_rule {
    name                       = "DenyOutboundToVNet"
    description                = "Deny outbound traffic to VNets (this includes other devices in the same VNet, other peered VNets, and on-prem via VPN/ExpressRoute)"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    destination_address_prefix = "VirtualNetwork"
    access                     = "Deny"
    priority                   = 1000
    direction                  = "Outbound"
  }
}

resource "azurerm_subnet_network_security_group_association" "workload1-dmz" {
  subnet_id                 = azurerm_subnet.spoke1-workload1-dmz.id
  network_security_group_id = azurerm_network_security_group.workload1-dmz.id
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
