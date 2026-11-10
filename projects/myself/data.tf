data "terraform_remote_state" "shared_app_services" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.TF_VAR_STATE_RG_NAME
    storage_account_name = var.TF_VAR_STATE_STORAGE_ACCOUNT_NAME
    container_name       = var.TF_VAR_STATE_STORAGE_ACCOUNT_CONTAINER
    key                  = "_shared_app_services.tfstate"
    subscription_id      = var.TF_VAR_SUBSCRIPTION_ID
    use_azuread_auth     = true
  }
}
