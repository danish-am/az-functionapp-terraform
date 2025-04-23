# Resource Group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Storage Account for Function App and ZIP deployment
resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Storage Container with ANONYMOUS READ ACCESS for blobs (required for WEBSITE_RUN_FROM_PACKAGE)
resource "azurerm_storage_container" "code" {
  name                  = "functioncode"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "blob"  
}

# Upload the ZIP package to the storage container
resource "azurerm_storage_blob" "function_zip" {
  name                   = "function_app_code.zip"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.code.name
  type                   = "Block"
  source                 = "${path.module}/function_app_code.zip"
  depends_on             = [null_resource.zip_function_app]
}

# Linux App Service Plan (Required for Python Functions)
resource "azurerm_service_plan" "example" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Linux"
  sku_name            = "S1"
}

# Linux Function App
resource "azurerm_linux_function_app" "example" {
  name                       = var.function_app_name
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  site_config {
    application_stack {
      python_version = "3.10"
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME    = "python"
    FUNCTIONS_EXTENSION_VERSION = "~4"
    WEBSITE_RUN_FROM_PACKAGE    = azurerm_storage_blob.function_zip.url
  }
}
