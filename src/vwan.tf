resource "azurerm_resource_group" "vwan_rg" {
  name     = "lab-vwan-rg"
  location = "East US"
  tags     = local.global_tags
}

resource "azurerm_virtual_wan" "vwan" {
  name                = "lab-vwan"
  resource_group_name = azurerm_resource_group.vwan_rg.name
  location            = azurerm_resource_group.vwan_rg.location
  tags                = local.global_tags
}

resource "azurerm_virtual_hub" "eastus-vhub" {
  name                = "lab-eastus-vhub"
  resource_group_name = azurerm_resource_group.vwan_rg.name
  location            = azurerm_resource_group.vwan_rg.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "10.0.0.0/16"
  tags                = local.global_tags
}

locals {
  ca_cert = replace(
    replace(
      file("../certs/ca/ca-cert.pem"),
      "-----BEGIN CERTIFICATE-----",
      ""
    ),
    "-----END CERTIFICATE-----",
    ""
  )
}

resource "azurerm_vpn_server_configuration" "user-vpn" {
  name                     = "user-vpns"
  resource_group_name      = azurerm_resource_group.vwan_rg.name
  location                 = azurerm_resource_group.vwan_rg.location
  vpn_authentication_types = ["Certificate"]
  vpn_protocols            = ["IkeV2"]
  tags                     = local.global_tags

  client_root_certificate {
    name             = "MaxAnderson.tech Root CA"
    public_cert_data = local.ca_cert
  }
}

resource "azurerm_point_to_site_vpn_gateway" "user-vpn-gateway" {
  name                        = "lab-user-vpn-gateway"
  location                    = azurerm_resource_group.vwan_rg.location
  resource_group_name         = azurerm_resource_group.vwan_rg.name
  virtual_hub_id              = azurerm_virtual_hub.eastus-vhub.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.user-vpn.id
  scale_unit                  = 1
  tags                        = local.global_tags

  connection_configuration {
    name = "vpn-gateway-configuration"

    vpn_client_address_pool {
      address_prefixes = [
        "10.255.255.0/24"
      ]
    }
  }
}
