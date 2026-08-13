<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_iam_workload_identity_pool.github](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google_iam_workload_identity_pool_provider.github](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_service_account_iam_member.wif_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attribute_condition"></a> [attribute\_condition](#input\_attribute\_condition) | Optional custom CEL condition for provider token acceptance. | `string` | `null` | no |
| <a name="input_attribute_mapping"></a> [attribute\_mapping](#input\_attribute\_mapping) | Attribute mapping for GitHub OIDC token claims to Google attributes. | `map(string)` | <pre>{<br/>  "attribute.actor": "assertion.actor",<br/>  "attribute.aud": "assertion.aud",<br/>  "attribute.ref": "assertion.ref",<br/>  "attribute.repository": "assertion.repository",<br/>  "google.subject": "assertion.sub"<br/>}</pre> | no |
| <a name="input_oidc_issuer_uri"></a> [oidc\_issuer\_uri](#input\_oidc\_issuer\_uri) | OIDC issuer URI used by the workload identity provider. | `string` | `"https://token.actions.githubusercontent.com"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID where Workload Identity resources are managed. | `string` | n/a | yes |
| <a name="input_repository"></a> [repository](#input\_repository) | GitHub repository in owner/repo format allowed to impersonate the service account. | `string` | n/a | yes |
| <a name="input_repository_owner"></a> [repository\_owner](#input\_repository\_owner) | GitHub organization or user owner used in the default provider attribute condition. | `string` | n/a | yes |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | Service account resource name to grant Workload Identity access on. | `string` | n/a | yes |
| <a name="input_workload_identity_pool_description"></a> [workload\_identity\_pool\_description](#input\_workload\_identity\_pool\_description) | Description for the Workload Identity Pool resource. | `string` | `"Federation pool for GitHub Actions OIDC tokens."` | no |
| <a name="input_workload_identity_pool_display_name"></a> [workload\_identity\_pool\_display\_name](#input\_workload\_identity\_pool\_display\_name) | Display name for the Workload Identity Pool. | `string` | `"GitHub Actions Pool"` | no |
| <a name="input_workload_identity_pool_id"></a> [workload\_identity\_pool\_id](#input\_workload\_identity\_pool\_id) | Workload Identity Pool ID (used when creating a pool and referenced by provider). | `string` | `"github-pool"` | no |
| <a name="input_workload_identity_pool_name"></a> [workload\_identity\_pool\_name](#input\_workload\_identity\_pool\_name) | Existing Workload Identity Pool full name; when null, this module creates a pool. | `string` | `null` | no |
| <a name="input_workload_identity_provider_description"></a> [workload\_identity\_provider\_description](#input\_workload\_identity\_provider\_description) | Description for the Workload Identity Provider resource. | `string` | `"OIDC provider for token.actions.githubusercontent.com."` | no |
| <a name="input_workload_identity_provider_display_name"></a> [workload\_identity\_provider\_display\_name](#input\_workload\_identity\_provider\_display\_name) | Display name for the Workload Identity Provider. | `string` | `"GitHub OIDC Provider"` | no |
| <a name="input_workload_identity_provider_id"></a> [workload\_identity\_provider\_id](#input\_workload\_identity\_provider\_id) | Workload Identity Provider ID inside the pool. | `string` | `"github-provider"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workload_identity_member"></a> [workload\_identity\_member](#output\_workload\_identity\_member) | The principalSet member string granted to the service account. |
| <a name="output_workload_identity_pool_name"></a> [workload\_identity\_pool\_name](#output\_workload\_identity\_pool\_name) | Full Workload Identity Pool resource name used for federation. |
| <a name="output_workload_identity_provider_name"></a> [workload\_identity\_provider\_name](#output\_workload\_identity\_provider\_name) | Full Workload Identity Provider resource name for GitHub Actions auth action. |
<!-- END_TF_DOCS -->