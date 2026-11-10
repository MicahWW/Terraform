data "azurerm_subscription" "current" {}


data "github_repository" "repo" {
  name = var.github_repository_name
}


data "github_user" "owner" {
  username = local.github_owner
}
