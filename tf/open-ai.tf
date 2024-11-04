resource "azurerm_search_service" "search_svc" {
  depends_on          = [azurerm_resource_group.rg, azurerm_storage_account.storage_account]
  name                = "ais-match-ai-${var.short_location}-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "basic"
  partition_count     = 1
  replica_count       = 1

  identity {
    type = "SystemAssigned"
  }
}

# permissions granting

# OpenAI -> Search svc
resource "azurerm_role_assignment" "openai_to_searchsvc_assignement_01" {
  depends_on           = [azurerm_cognitive_account.ca, azurerm_search_service.search_svc]
  principal_id         = data.azurerm_cognitive_account.ca.identity.0.principal_id
  role_definition_name = "Search Index Data Reader"
  scope                = azurerm_search_service.search_svc.id
}

# OpenAI -> Search svc
resource "azurerm_role_assignment" "openai_to_searchsvc_assignement_02" {
  depends_on           = [azurerm_cognitive_account.ca, azurerm_search_service.search_svc]
  principal_id         = data.azurerm_cognitive_account.ca.identity.0.principal_id
  role_definition_name = "Search Service Contributor"
  scope                = azurerm_search_service.search_svc.id
}
