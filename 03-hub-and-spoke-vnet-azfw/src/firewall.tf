resource "azurerm_subnet" "azfw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
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
    action   = "Allow"

    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["172.64.198.3", "172.64.199.3"] # ifconfig.io
      destination_ports     = ["80", "443"]
    }
  }

  network_rule_collection {
    name     = "default-deny"
    priority = 65000
    action   = "Deny"

    rule {
      name                  = "default-deny-all"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "policy-arc1" {
  name                = "${local.numeral_prefix}-azfw-arc1"
  azure_firewall_name = azurerm_firewall.azfw.name
  resource_group_name = azurerm_resource_group.rg.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "ubuntu-updates"

    source_addresses = [
      "*",
    ]

    target_fqdns = [
      "*.archive.ubuntu.com",
    ]

    protocol {
      port = "80"
      type = "Http"
    }

    protocol {
      port = "443"
      type = "Https"
    }
  }
}
