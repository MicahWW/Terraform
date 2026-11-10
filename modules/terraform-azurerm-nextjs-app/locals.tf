locals {
  environment  = "production"
  github_owner = split("/", data.github_repository.repo.full_name)[0]
}
