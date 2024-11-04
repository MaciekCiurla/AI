resource "azurerm_storage_account" "storage_account" {
  depends_on               = [azurerm_resource_group.rg]
  name                     = "sa0matchai0${var.short_location}02"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_container" {
  depends_on            = [azurerm_storage_account.storage_account]
  name                  = "cvs"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_table" "table_storage" {
  depends_on           = [azurerm_storage_account.storage_account]
  name                 = "cvstable"
  storage_account_name = azurerm_storage_account.storage_account.name
}

resource "null_resource" "wait_for_complete_resource" {
  depends_on = [azurerm_cognitive_account.ca, azurerm_search_service.search_svc]

  provisioner "local-exec" {
    command = "sleep 90" # Wait for 90 seconds
  }
}

# permissions granting

# OpenAI -> Storage Account
resource "azurerm_role_assignment" "openai_to_storage_assignement" {
  depends_on           = [azurerm_cognitive_account.ca, azurerm_storage_account.storage_account]
  principal_id         = data.azurerm_cognitive_account.ca.identity.0.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.storage_account.id
}

# Search svc -> Storage Account
resource "azurerm_role_assignment" "searchsvc_to_storage_assignement" {
  depends_on           = [azurerm_search_service.search_svc, azurerm_storage_account.storage_account]
  principal_id         = data.azurerm_search_service.search_svc.identity.0.principal_id
  role_definition_name = "Storage Blob Data Reader"
  scope                = azurerm_storage_account.storage_account.id
}