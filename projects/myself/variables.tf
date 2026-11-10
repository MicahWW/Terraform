variable "TF_VAR_SUBSCRIPTION_ID" {
  description = "The subscription ID for the backend"
  type        = string
}


variable "TF_VAR_GITHUB_OWNER" {
  description = "The GitHub owner for the repository"
  type        = string
}


variable "TF_VAR_STATE_RG_NAME" {
  description = "The name of the resource group for the tfstate backend"
  type        = string
}


variable "TF_VAR_STATE_STORAGE_ACCOUNT_NAME" {
  description = "The name of the storage account for the tfstate backend"
  type        = string
}


variable "TF_VAR_STATE_STORAGE_ACCOUNT_CONTAINER" {
  description = "The name of the storage account container for tfstate"
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


variable "github_repository_name" {
  description = "The GitHub repository name, excluding the owner"
  type        = string
}


variable "app_name" {
  description = "The name of the application"
  type        = string
}
