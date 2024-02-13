resource "azurerm_public_ip" "azfw-pip" {
  name                = "azfw-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "azfw" {
  name                = "azfw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "azfw-ip-config"
    public_ip_address_id = azurerm_public_ip.azfw-pip.id
    subnet_id            = azurerm_subnet.azfw-subnet.id
  }
}

resource "azurerm_ip_group" "rfc1918" {
  name                = "rfc1918"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  cidrs               = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

resource "azurerm_firewall_network_rule_collection" "azfw-nrc1" {
  name                = "azfw-nrc1"
  resource_group_name = azurerm_resource_group.rg.name
  azure_firewall_name = azurerm_firewall.azfw.name
  action              = "Allow"
  priority            = 100

  rule {
    name                  = "Allow-Outbound"
    description           = "Allow Outbound traffic"
    protocols             = ["TCP", "UDP", "ICMP"]
    source_ip_groups      = [azurerm_ip_group.rfc1918.id]
    destination_addresses = ["*"]
    destination_ports     = ["*"]
  }
}
