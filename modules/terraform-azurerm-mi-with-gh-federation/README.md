# Managed Identity with GitHub Federation

This Terraform module creates an Azure user-assigned managed identity that GitHub Actions can use through OpenID Connect (OIDC) workload identity federation. It also assigns the supplied Azure roles to the managed identity.

No client secret or certificate is created. GitHub Actions exchanges its OIDC token with Microsoft Entra ID using the federated identity credential.

## Resources created

The module creates:

- **Azure user-assigned managed identity**: Created in the supplied resource group and Azure region.
- **Azure federated identity credential**: Trusts GitHub Actions as the token issuer, uses the `api://AzureADTokenExchange` audience, and is restricted to the configured GitHub subject.
- **Azure role assignments**: Creates one role assignment for every object in `role_assignments`, using the managed identity as the principal and each object's scope and role definition ID.
- **GitHub Environment Secret**: Stores the Client ID of the managed identity as a secret in the given repository and environment

## Usage

```hcl
module "github_deployment_identity" {
  source = "../../modules/terraform-azurerm-mi-with-gh-federation"

  name                = "mi-example-deployment"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location

  github_subject_identifier = "repo:example-org@123456/example-repo@789012:environment:development"

  role_assignments = [
    {
      scope              = azurerm_linux_function_app.app.id
      role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/de139f84-1756-47ae-9be6-808fbbe84772"
    }
  ]
}
```

The role definition ID in the example is the built-in **Website Contributor** role. Supply the role definition ID appropriate for each target resource.

## GitHub subject configuration

Use either `github_subject_identifier` or all five individual GitHub values. The module builds the subject in this format:

```text
repo:{organization_name}@{organization_id}/{repository_name}@{repository_id}:environment:{environment_name}
```

For example:

```hcl
github_organization_name = "example-org"
github_organization_id   = "123456"
github_repository_name   = "example-repo"
github_repository_id     = "789012"
github_environment_name  = "development"
```

The organization and repository IDs must be numeric. When
`github_subject_identifier` is provided, the individual GitHub variables are
not required.

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `string` | n/a | Name of the user-assigned managed identity. |
| `resource_group_name` | `string` | n/a | Resource group for the managed identity. |
| `location` | `string` | n/a | Azure region for the managed identity. |
| `github_subject_identifier` | `string` | `null` | Complete GitHub subject in the required format. Mutually exclusive with the need for individual GitHub values. |
| `github_organization_name` | `string` | `null` | GitHub organization name, used when a complete subject is not supplied. |
| `github_organization_id` | `string` | `null` | Numeric GitHub organization ID, used when a complete subject is not supplied. |
| `github_repository_name` | `string` | `null` | GitHub repository name, used when a complete subject is not supplied. |
| `github_repository_id` | `string` | `null` | Numeric GitHub repository ID, used when a complete subject is not supplied. |
| `github_environment_name` | `string` | `null` | GitHub environment name, used when a complete subject is not supplied. |
| `role_assignments` | `list(object({ scope = string, role_definition_id = string }))` | n/a | Azure scopes and role definition IDs to assign to the managed identity. |

## Outputs

| Name | Description |
| --- | --- |
| `id` | Resource ID of the user-assigned managed identity. |
| `client_id` | Client ID of the user-assigned managed identity. |
| `principal_id` | Principal ID of the user-assigned managed identity, used for role assignments and access policies. |
