variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}


variable "location" {
  description = "The location of the resource group"
  type        = string
}


variable "app_name" {
  description = "The name of the Linux web app"
  type        = string
}


variable "service_plan_id" {
  description = "The ID of the service plan"
  type        = string
}


variable "node_version" {
  type        = string
  description = "The version of Node.js to use for the application stack."
  default     = "24-lts"
}


variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "A map of environment variables to set for the web app."
}


variable "log_workspace_id" {
  description = "The ID of the Log Analytics workspace"
  type        = string
}


variable "github_repository_name" {
  description = "The name of the GitHub repository"
  type        = string
}
