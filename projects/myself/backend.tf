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
