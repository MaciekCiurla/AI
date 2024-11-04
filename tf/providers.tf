terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 4.1"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "azurerm" {
  features {}
#  subscription_id = var.subscription_id
}

