### Cloud-init ###
data "cloudinit_config" "cloudinit" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloud-config.yaml")
  }
}

### VM 1 ###
resource "azurerm_network_interface" "test-vm-1-nic" {
  name                = "${local.numeral_prefix}-test-vm-1-${var.region}-nic"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke1-workload1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "test-vm-1" {
  name                            = "${local.numeral_prefix}-test-vm-1-${var.region}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = var.region
  size                            = "Standard_B1s"
  admin_username                  = var.vm_admin_user
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
  custom_data                     = data.cloudinit_config.cloudinit.rendered
  network_interface_ids = [
    azurerm_network_interface.test-vm-1-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  boot_diagnostics {}
}

### VM 2 ###
resource "azurerm_network_interface" "test-vm-2-nic" {
  name                = "${local.numeral_prefix}-test-vm-2-${var.region}-nic"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke2-workload1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "test-vm-2" {
  name                            = "${local.numeral_prefix}-test-vm-2-${var.region}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = var.region
  size                            = "Standard_B1s"
  admin_username                  = var.vm_admin_user
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
  custom_data                     = data.cloudinit_config.cloudinit.rendered
  network_interface_ids = [
    azurerm_network_interface.test-vm-2-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  boot_diagnostics {}
}
