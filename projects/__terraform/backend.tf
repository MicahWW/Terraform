# How to start from scratch in a new environment:
# 1. Temporarily comment out this backend block and run `terraform init` and `terraform apply`
#    to create the resource group, storage account, and state container using local state.
# 2. Restore this backend block, then run `terraform init -migrate-state` to move the state to Azure.

# If you're wondering why this is blank please reference Partial Configuration in the Terraform documentation.
# https://developer.hashicorp.com/terraform/language/backend#partial-configuration
# This is done to help hide information such as resource group names, storage account names, and subscription IDs from
# the backend configuration. While not strictly necessary, I do it out of an abundance of caution.
terraform {
  backend "azurerm" {
    resource_group_name  = ""
    storage_account_name = ""
    container_name       = ""
    key                  = ""

    subscription_id  = ""
    use_azuread_auth = true
  }
}
