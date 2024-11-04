resource "azurerm_resource_group" "rg" {
  name     = "rg-match-ai"
  location = var.location
  tags     = {owner = var.owner}
}

data "azurerm_cognitive_account" "ca" {
  depends_on          = [null_resource.wait_for_complete_resource]
  name                = azurerm_cognitive_account.ca.name
  resource_group_name = azurerm_resource_group.rg.name
}

data "azurerm_search_service" "search_svc" {
  depends_on          = [null_resource.wait_for_complete_resource]
  name                = azurerm_search_service.search_svc.name
  resource_group_name = azurerm_resource_group.rg.name
}








