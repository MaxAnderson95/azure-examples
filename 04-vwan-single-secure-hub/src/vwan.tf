resource "azurerm_virtual_wan" "vwan" {
  name                           = "${local.numeral_prefix}-vwan-single-secure-hub"
  resource_group_name            = azurerm_resource_group.rg.name
  location                       = azurerm_resource_group.rg.location
  allow_branch_to_branch_traffic = true
  type                           = "standard"
}

resource "azurerm_virtual_hub" "hub" {
  name                = "vhub"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  sku                 = "Standard"
  address_prefix      = var.address_space[0]
}

resource "azurerm_virtual_hub_connection" "spoke1" {
  name                      = "hub-to-spoke1"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = azurerm_virtual_network.spoke-vnet1.id
  internet_security_enabled = true # Very important! This makes the spoke-to-internet traffic go through the firewall
}

resource "azurerm_virtual_hub_connection" "spoke2" {
  name                      = "hub-to-spoke2"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = azurerm_virtual_network.spoke-vnet2.id
  internet_security_enabled = true # Very important! This makes the spoke-to-internet traffic go through the firewall
}

resource "azurerm_virtual_hub_routing_intent" "routing_intent" {
  name           = "vhub-routingintent"
  virtual_hub_id = azurerm_virtual_hub.hub.id

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.azfw.id
  }

  routing_policy {
    name         = "PrivateTrafficPolicy"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.azfw.id
  }
}
