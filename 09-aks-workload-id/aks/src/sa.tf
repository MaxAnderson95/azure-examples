resource "azurerm_storage_account" "example" {
  name                     = "maxandersonexamplesa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "foo" {
  name                 = "foo"
  storage_account_name = azurerm_storage_account.example.name
}

resource "azurerm_storage_blob" "bar" {
  name                   = "bar.txt"
  type                   = "Block"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.foo.name
  source_content         = "Hello, World!"
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_storage_account.example.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "foo" {
  scope                = azurerm_storage_container.foo.resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}
