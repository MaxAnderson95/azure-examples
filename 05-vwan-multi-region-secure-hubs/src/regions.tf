module "region_a" {
  source = "./region"
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_virtual_wan.vwan
  ]

  // Variables
  virtual_wan_name    = local.virtual_wan_name
  resource_group_name = local.resource_group_name
  address_space       = var.address_space_region_a
  region              = var.region_a
  vm_admin_user       = var.vm_admin_user
  vm_admin_password   = var.vm_admin_password
}

module "region_b" {
  source = "./region"
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_virtual_wan.vwan
  ]

  // Variables
  virtual_wan_name    = local.virtual_wan_name
  resource_group_name = local.resource_group_name
  address_space       = var.address_space_region_b
  region              = var.region_b
  vm_admin_user       = var.vm_admin_user
  vm_admin_password   = var.vm_admin_password
}
