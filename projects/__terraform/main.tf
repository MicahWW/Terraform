resource "azurerm_resource_group" "rg" {
  name     = var.TF_VAR_STATE_RG_NAME
  location = var.tf_state_location
}

resource "azurerm_storage_account" "sa_state" {
  name                = var.TF_VAR_STATE_STORAGE_ACCOUNT_NAME
  resource_group_name = azurerm_resource_group.rg.name     # Setup dependency for creation order
  location            = azurerm_resource_group.rg.location # Setup dependency for creation order

  account_tier             = "Standard"
  account_replication_type = "ZRS"
  account_kind             = "StorageV2"

  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  shared_access_key_enabled       = false # Force Entra ID auth so sate is never reachable with a shared key

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 30
    }

    container_delete_retention_policy {
      days = 30
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}


resource "azurerm_storage_container" "state" {
  name                  = var.TF_VAR_STATE_STORAGE_ACCOUNT_CONTAINER
  storage_account_id    = azurerm_storage_account.sa_state.id
  container_access_type = "private"
}


# Required because share keys are disabled, we assign Entra ID roles to access the storage account and container
resource "azurerm_role_assignment" "sa_state_contributor" {
  for_each           = toset(var.tf_state_operator_principal_ids)
  principal_id       = each.value
  role_definition_id = "/subscriptions/${var.TF_VAR_SUBSCRIPTION_ID}/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe" # Storage Blob Data Contributor
  scope              = azurerm_storage_account.sa_state.id
}


resource "azurerm_management_lock" "lock" {
  name       = "terraform-state-lock"
  scope      = azurerm_resource_group.rg.id
  lock_level = "CanNotDelete"
  notes      = "Lock for Terraform state to ensure the rg or it's storage account cannot be deleted"
}
