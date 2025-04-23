output "function_app_name" {
  value = azurerm_linux_function_app.example.name
}

output "function_app_default_hostname" {
  value = azurerm_linux_function_app.example.default_hostname
}

output "function_app_url" {
  value = "https://${azurerm_linux_function_app.example.default_hostname}/api/HttpTrigger"
}
