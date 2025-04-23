terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-backend-rg"
    storage_account_name = "tfstatebackendsa1729"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
