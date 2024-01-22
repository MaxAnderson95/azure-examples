resource "azurerm_route_table" "workloads" {
  name                = "${local.numeral_prefix}-workloads-rt"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_route" "default-gateway" {
  name                   = "default-gateway"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.workloads.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.azfw.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "workload1" {
  subnet_id      = azurerm_subnet.workload1.id
  route_table_id = azurerm_route_table.workloads.id
}
