resource "azurerm_linux_web_app" "app" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.service_plan_id

  app_settings = merge(
    var.environment_variables,
    {
      APPLICATIONINSIGHTS_CONNECTION_STRING      = azurerm_application_insights.app_insights.connection_string
      ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    }
  )

  ftp_publish_basic_authentication_enabled       = false
  https_only                                     = true
  webdeploy_publish_basic_authentication_enabled = false

  site_config {
    always_on = true

    app_command_line = "node server.js"
    application_stack {
      node_version = var.node_version
    }
  }

  lifecycle {
    ignore_changes = [
      tags["hidden-link: /app-insights-resource-id"]
    ]
  }
}


resource "azurerm_application_insights" "app_insights" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  application_type    = "web"
  workspace_id        = var.log_workspace_id
}


resource "github_repository_environment" "environment" {
  repository  = data.github_repository.repo.name
  environment = local.environment
}


resource "github_actions_environment_secret" "subscription_id" {
  repository  = data.github_repository.repo.name
  environment = local.environment
  secret_name = "AZURE_SUBSCRIPTION_ID"
  value       = data.azurerm_subscription.current.subscription_id
}


resource "github_actions_environment_secret" "tenant_id" {
  repository  = data.github_repository.repo.name
  environment = local.environment
  secret_name = "AZURE_TENANT_ID"
  value       = data.azurerm_subscription.current.tenant_id
}


resource "github_actions_environment_variable" "app_name" {
  repository    = data.github_repository.repo.name
  environment   = local.environment
  variable_name = "APP_NAME"
  value         = var.app_name
}


resource "github_actions_environment_variable" "slot_name" {
  repository    = data.github_repository.repo.name
  environment   = local.environment
  variable_name = "SLOT_NAME"
  value         = "production"
}


module "mi_deploy" {
  source                    = "../terraform-azurerm-mi-with-gh-federation"
  name                      = "mi-${var.app_name}-deploy"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  github_subject_identifier = "repo:${local.github_owner}@${data.github_user.owner.id}/${data.github_repository.repo.name}@${data.github_repository.repo.repo_id}:environment:${local.environment}"
  role_assignments = [
    {
      scope              = azurerm_linux_web_app.app.id
      role_definition_id = "${data.azurerm_subscription.current.id}/providers/Microsoft.Authorization/roleDefinitions/de139f84-1756-47ae-9be6-808fbbe84772" # Website Contributor
    }
  ]
}
