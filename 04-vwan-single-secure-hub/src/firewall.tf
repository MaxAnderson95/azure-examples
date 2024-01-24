resource "azurerm_public_ip" "azfw-pip" {
  name                = "azfw-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "azfw" {
  name                = "azfw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.azfw_policy.id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.hub.id
    public_ip_count = 1
  }
}

resource "azurerm_firewall_policy" "azfw_policy" {
  name                     = "policy-azfw-securehub-eus"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  threat_intelligence_mode = "Alert"
}

resource "azurerm_firewall_policy_rule_collection_group" "policy-rcg1" {
  name               = "${local.numeral_prefix}-azfw-rcg1"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
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
