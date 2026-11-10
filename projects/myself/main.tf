resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}


resource "github_repository" "repo" {
  name         = var.github_repository_name
  description  = "Public profile for GitHub and source code of personal profile website"
  homepage_url = "https://micahww.com"
  visibility   = "public"
  has_issues   = true
  has_projects = false
  has_wiki     = false
  topics = [
    "resume",
    "resume-website"
  ]
}


module "myself" {
  source                 = "../../modules/terraform-azurerm-nextjs-app"
  resource_group_name    = var.resource_group_name
  location               = var.location
  app_name               = var.app_name
  github_repository_name = github_repository.repo.name
  log_workspace_id       = data.terraform_remote_state.shared_app_services.outputs.log_workspace_id
  service_plan_id        = data.terraform_remote_state.shared_app_services.outputs.asp_id
  environment_variables = {
    "PORT" = "8080"
  }
}
