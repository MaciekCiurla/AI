resource "azurerm_cognitive_account" "ca" {
  depends_on          = [azurerm_resource_group.rg, azurerm_storage_account.storage_account]
  name                = "oai-match-ai-${var.short_location}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "OpenAI"
  sku_name            = "S0"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_cognitive_deployment" "cd" {
  depends_on           = [azurerm_cognitive_account.ca]
  name                 = "oaimatchai${var.short_location}01"
  cognitive_account_id = azurerm_cognitive_account.ca.id
  model {
    format = "OpenAI"
    name   = "gpt-4o"
  }
  sku {
    name     = "GlobalStandard"
    capacity = "20"
  }
}

# permissions granting

# Search svc -> OpenAI
resource "azurerm_role_assignment" "searchsvc_to_openai_assignement" {
  depends_on           = [azurerm_search_service.search_svc, azurerm_cognitive_account.ca]
  principal_id         = data.azurerm_search_service.search_svc.identity.0.principal_id
  role_definition_name = "Cognitive Services OpenAI Contributor"
  scope                = azurerm_cognitive_account.ca.id
}