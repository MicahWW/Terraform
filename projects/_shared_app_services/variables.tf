variable "TF_VAR_SUBSCRIPTION_ID" {
  description = "The subscription ID for the backend"
  type        = string
}


variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}


variable "location" {
  description = "The location of the resource group and all resources"
  type        = string
}


variable "asp_name" {
  description = "The name of the App Service Plan"
  type        = string
}


variable "asp_sku" {
  description = "The SKU of the App Service Plan"
  type        = string
}


variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  type        = string
}


variable "log_analytics_workspace_sku" {
  description = "The SKU of the Log Analytics workspace"
  type        = string
}


variable "log_analytics_workspace_retention_in_days" {
  description = "The retention period of the Log Analytics workspace in days"
  type        = number
}
