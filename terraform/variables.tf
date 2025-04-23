variable "resource_group_name" {
  type    = string
  default = "azure-functions-rg"
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "storage_account_name" {
  type    = string
  default = "funcapptfstorage"
}

variable "function_app_name" {
  type    = string
  default = "python-function-tf"
}

variable "app_service_plan_name" {
  type    = string
  default = "function-app-service-plan"
}
