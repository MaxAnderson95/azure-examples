#### Hub Vet ####
# Route table for the azfw subnet in the hub VNet
resource "azurerm_route_table" "azfw-hub" {
  name                = "${local.numeral_prefix}-azfw-hub-rt"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Default route for the azfw subnet in the hub VNet
resource "azurerm_route" "azfw-hub-dgw" {
  name                = "${local.numeral_prefix}-azfw-hub-dgw-route"
  resource_group_name = azurerm_resource_group.rg.name
  route_table_name    = azurerm_route_table.azfw-hub.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}

# Associate the route table to the AzureFirewallSubnet in the hub VNet
resource "azurerm_subnet_route_table_association" "hub-azfw" {
  subnet_id      = azurerm_subnet.azfw.id
  route_table_id = azurerm_route_table.azfw-hub.id
}


#### Spoke VNet 1 ####
# Route table for the spoke VNet
resource "azurerm_route_table" "spoke1" {
  name                = "${local.numeral_prefix}-spoke1-rt"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Default route for the spoke VNet
resource "azurerm_route" "spoke1-dgw" {
  name                   = "${local.numeral_prefix}-spoke1-dgw-route"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.spoke1.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.azfw.ip_configuration[0].private_ip_address
}

# Associate the route table to the workload1 subnet in the spoke VNet
resource "azurerm_subnet_route_table_association" "spoke1-workload1" {
  subnet_id      = azurerm_subnet.spoke1-workload1.id
  route_table_id = azurerm_route_table.spoke1.id
}

#### Spoke VNet 2 ####
# Route table for the spoke VNet
resource "azurerm_route_table" "spoke2" {
  name                = "${local.numeral_prefix}-spoke2-rt"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Default route for the spoke VNet
resource "azurerm_route" "spoke2-dgw" {
  name                   = "${local.numeral_prefix}-spoke2-dgw-route"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.spoke2.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.azfw.ip_configuration[0].private_ip_address
}

# Associate the route table to the workload1 subnet in the spoke VNet
resource "azurerm_subnet_route_table_association" "spoke2-workload1" {
  subnet_id      = azurerm_subnet.spoke2-workload1.id
  route_table_id = azurerm_route_table.spoke2.id
}
