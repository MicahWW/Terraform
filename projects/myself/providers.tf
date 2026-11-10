terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 5.0.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.0.0"
    }
  }
}


provider "azurerm" {
  features {}

  subscription_id = var.TF_VAR_SUBSCRIPTION_ID
}


provider "github" {
  owner = var.TF_VAR_GITHUB_OWNER
}
