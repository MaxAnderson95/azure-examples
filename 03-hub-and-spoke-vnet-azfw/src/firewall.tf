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
      name                  = "Allow-HTTP-From-VM1-to-VM2"
      protocols             = ["TCP"]
      source_addresses      = [azurerm_network_interface.test-vm-1-nic.private_ip_address]
      destination_addresses = [azurerm_network_interface.test-vm-2-nic.private_ip_address]
      destination_ports     = ["80", "443"]
    }
  }

  application_rule_collection {
    name     = "application-rule-collection1"
    priority = 500
    action   = "Allow"

    rule {
      name              = "allow-ubuntu-updates"
      source_addresses  = ["*"]
      destination_fqdns = ["azure.archive.ubuntu.com"]

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }
    }

  }
}

