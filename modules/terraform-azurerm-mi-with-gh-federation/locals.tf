locals {
  github_subject_identifier = var.github_subject_identifier != null ? var.github_subject_identifier : "repo:${var.github_organization_name}@${var.github_organization_id}/${var.github_repository_name}@${var.github_repository_id}:environment:${var.github_environment_name}"

  # Parse the org/repo/environment names back out of the subject so the resource name keeps its original format regardless of how the subject was supplied.
  github_subject_parts = regex("^repo:([^@/]+)@[0-9]+/([^@/]+)@[0-9]+:environment:(.+)$", local.github_subject_identifier)

  github_owner       = local.github_subject_parts[0]
  github_repository  = local.github_subject_parts[1]
  github_environment = local.github_subject_parts[2]

  federated_identity_name = "${local.github_owner}-${local.github_repository}-${local.github_environment}"
}
