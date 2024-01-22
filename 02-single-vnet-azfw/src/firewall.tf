resource "azurerm_subnet" "azfw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 8, 0)]
}

resource "azurerm_public_ip" "azfw" {
  name                = "${local.numeral_prefix}-azfw-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "azfw" {
  name                = "${local.numeral_prefix}-azfw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.azfw.id

  ip_configuration {
    name                 = "azfw-ipconfig"
    subnet_id            = azurerm_subnet.azfw.id
    public_ip_address_id = azurerm_public_ip.azfw.id
  }
}

resource "azurerm_firewall_policy" "azfw" {
  name                = "${local.numeral_prefix}-azfw-policy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_firewall_policy_rule_collection_group" "policy-rcg1" {
  name               = "${local.numeral_prefix}-azfw-rcg1"
  firewall_policy_id = azurerm_firewall_policy.azfw.id
  priority           = 500

  network_rule_collection {
    name     = "network-rule-collection1"
    priority = 400
    action   = "Deny"

    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["172.64.198.3", "172.64.199.3"]
      destination_ports     = ["80", "443"]
    }
  }

  network_rule_collection {
    name     = "default-allow"
    priority = 500
    action   = "Allow"

    rule {
      name                  = "default-allow-rule"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }

}
