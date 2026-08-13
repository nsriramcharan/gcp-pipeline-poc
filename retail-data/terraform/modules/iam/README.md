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
| [google_project_iam_member.project_bindings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_storage_bucket_iam_member.bucket_bindings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.multi_bucket_bindings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Bucket name for bucket-level IAM bindings. Required when bucket\_roles is not empty. | `string` | `null` | no |
| <a name="input_bucket_role_bindings"></a> [bucket\_role\_bindings](#input\_bucket\_role\_bindings) | Map of bucket names to bucket-level roles for the same member (for example, object viewer/admin permissions per bucket). | `map(list(string))` | `{}` | no |
| <a name="input_bucket_roles"></a> [bucket\_roles](#input\_bucket\_roles) | Bucket-level IAM roles to grant to the member. | `list(string)` | `[]` | no |
| <a name="input_member"></a> [member](#input\_member) | IAM member identity, for example serviceAccount:sa@project.iam.gserviceaccount.com. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID for project-level IAM bindings. | `string` | n/a | yes |
| <a name="input_project_roles"></a> [project\_roles](#input\_project\_roles) | Project-level IAM roles to grant to the member. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_roles_applied"></a> [bucket\_roles\_applied](#output\_bucket\_roles\_applied) | Bucket roles that were applied for the member. |
| <a name="output_multi_bucket_roles_applied"></a> [multi\_bucket\_roles\_applied](#output\_multi\_bucket\_roles\_applied) | Bucket-role bindings applied through bucket\_role\_bindings. |
| <a name="output_project_roles_applied"></a> [project\_roles\_applied](#output\_project\_roles\_applied) | Project roles that were applied for the member. |
<!-- END_TF_DOCS -->