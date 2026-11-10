variable "name" {
  description = "The name of the user assigned identity."
  type        = string
}


variable "resource_group_name" {
  description = "The name of the resource group where the user assigned identity will be created."
  type        = string
}


variable "location" {
  description = "The Azure region where the user assigned identity will be created."
  type        = string
}


variable "github_organization_name" {
  description = "The GitHub organization for the federated identity. Not needed if github_subject_identifier is provided."
  type        = string
  default     = null
}


variable "github_organization_id" {
  description = "The GitHub organization ID for the federated identity. Not needed if github_subject_identifier is provided."
  type        = string
  default     = null
}


variable "github_repository_name" {
  description = "The GitHub repository for the federated identity. Not needed if github_subject_identifier is provided."
  type        = string
  default     = null
}


variable "github_repository_id" {
  description = "The GitHub repository ID for the federated identity. Not needed if github_subject_identifier is provided."
  type        = string
  default     = null
}


variable "github_environment_name" {
  description = "The GitHub environment name for the federated identity. Not needed if github_subject_identifier is provided."
  type        = string
  default     = null
}


variable "github_subject_identifier" {
  description = "The GitHub subject identifier for the federated identity, in the form repo:{organization_name}@{organization_id}/{repository_name}@{repository_id}:environment:{environment_name}. If not provided, it is built from the individual github_* variables, all of which then become required."
  type        = string
  default     = null

  validation {
    condition     = var.github_subject_identifier == null || can(regex("^repo:[^@/]+@[0-9]+/[^@/]+@[0-9]+:environment:.+$", var.github_subject_identifier))
    error_message = "github_subject_identifier must match the format repo:{organization_name}@{organization_id}/{repository_name}@{repository_id}:environment:{environment_name}."
  }

  validation {
    condition = var.github_subject_identifier != null || (
      var.github_organization_name != null &&
      var.github_organization_id != null &&
      var.github_repository_name != null &&
      var.github_repository_id != null &&
      var.github_environment_name != null
    )
    error_message = "Either github_subject_identifier or all of github_organization_name, github_organization_id, github_repository_name, github_repository_id, and github_environment_name must be provided."
  }
}


variable "role_assignments" {
  description = "A list of role assignments for the managed identity."
  type = list(object({
    scope              = string
    role_definition_id = string
  }))
}
