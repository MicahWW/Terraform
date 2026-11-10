# Azure Next.js App

This Terraform module creates an Azure Linux Web App for a Next.js application running on an existing App Service plan. The app is configured to start with `node server.js`, supports configurable environment variables, and provides a choice of predefined inbound IP restriction profiles.

## Resources created

The module creates:

- **Linux Web App**: Created in the supplied resource group, region, and App Service plan.
- **Application Insights**: Created and attached to the Linux Web App
- **A GitHub Environment**: This is used for federated identity with the managed identity.
- **Two GitHub Environment Secrets**: These are used by the federated identity to login to Azure.
- **Two GitHub Environment Variables**: These define the configuration of where to deploy the application to in Azure.
- **A Managed Identity**: This is used to allow the GitHub repo to push a deployment to Azure. [Read more about the managed identity.](../terraform-azurerm-mi-with-gh-federation/README.md)

The module does not create a resource group, App Service plan, networking, or application deployment artifact. Those resources and the application package must be managed separately.

## Usage

```hcl
module "nextjs_app" {
  source = "../../modules/terraform-azurerm-nextjs-app"

  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  app_name            = "example-nextjs-app"
  service_plan_id     = azurerm_service_plan.app.id
  dsit_env_lifecycle  = "development"
  security_profile    = "ip_restrict_aac_fr"

  environment_variables = {
    NODE_ENV = "production"
    PORT     = "8080"
  }
  github_subject_identifier = "repo:example@123456789/ExampleRepo@987654321:environment:venv"
}
```

## Application configuration

- Node.js version defaults to `24-lts` and can be changed with `node_version`.
- The startup command is `node server.js`; the deployed application must provide that entry point.
- Values in `environment_variables` are passed to the Web App as app settings.
- The Web App is always on and HTTPS-only.
- FTP publishing and Web Deploy basic authentication are disabled.

## Requirements

- An existing App Service plan compatible with Linux Web Apps
- A NextJs app with it setup to use `server.js` as it's startup.

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `resource_group_name` | `string` | n/a | Name of the resource group. |
| `location` | `string` | n/a | Azure region for the Web App. |
| `app_name` | `string` | n/a | Name of the Linux Web App. |
| `service_plan_id` | `string` | n/a | ID of the App Service plan. |
| `dsit_env_lifecycle` | `string` | n/a | Value for the `dsit_env_lifecycle` tag. |
| `security_profile` | `string` | n/a | Predefined profile: `aad_auth` or `ip_restrict_aac_fr`. |
| `node_version` | `string` | `24-lts` | Node.js version for the application stack. |
| `environment_variables` | `map(string)` | n/a | Environment variables to configure as Web App settings. |
| `github_subject_identifier` | `string` | n/a | GitHub subject identifier of the repository and environment for federated identity. |
