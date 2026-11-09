variable "TF_VAR_SUBSCRIPTION_ID" {
  description = "The subscription ID for the resources"
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


variable "tf_state_location" {
  description = "The location of the resource group and all resources"
  type        = string
}


variable "tf_state_operator_principal_ids" {
  description = "The principal IDs of the operators who can access the tfstate"
  type        = list(string)
}
