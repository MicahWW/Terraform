output "log_workspace_id" {
  value = azurerm_log_analytics_workspace.shared_app_services_workspace.id
}


output "asp_id" {
  value = azurerm_service_plan.asp.id
}
