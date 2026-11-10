resource "azurerm_user_assigned_identity" "managed_identity" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
}


resource "azurerm_federated_identity_credential" "federated_identity" {
  name                      = local.federated_identity_name
  user_assigned_identity_id = azurerm_user_assigned_identity.managed_identity.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  subject                   = local.github_subject_identifier
}


resource "azurerm_role_assignment" "role_assignments" {
  for_each = { for index, role_assignment in var.role_assignments : index => role_assignment }

  scope              = each.value.scope
  principal_id       = azurerm_user_assigned_identity.managed_identity.principal_id
  role_definition_id = each.value.role_definition_id
}


resource "github_actions_environment_secret" "client_id" {
  repository  = local.github_repository
  environment = local.github_environment
  secret_name = "AZURE_CLIENT_ID"
  value       = azurerm_user_assigned_identity.managed_identity.client_id
}
