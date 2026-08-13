<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_dataproc_batch.this](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dataproc_batch) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_archive_uris"></a> [archive\_uris](#input\_archive\_uris) | Optional archives extracted for the batch runtime. | `list(string)` | `[]` | no |
| <a name="input_args"></a> [args](#input\_args) | Command line arguments passed to the PySpark application. | `list(string)` | `[]` | no |
| <a name="input_batch_id"></a> [batch\_id](#input\_batch\_id) | Unique Dataproc batch ID. | `string` | n/a | yes |
| <a name="input_file_uris"></a> [file\_uris](#input\_file\_uris) | Optional files made available to the batch runtime. | `list(string)` | `[]` | no |
| <a name="input_jar_file_uris"></a> [jar\_file\_uris](#input\_jar\_file\_uris) | Optional JAR dependencies for the PySpark batch. | `list(string)` | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels applied to the Dataproc batch. | `map(string)` | `{}` | no |
| <a name="input_main_python_file_uri"></a> [main\_python\_file\_uri](#input\_main\_python\_file\_uri) | GCS URI of the main PySpark job file. | `string` | n/a | yes |
| <a name="input_network_uri"></a> [network\_uri](#input\_network\_uri) | Optional VPC network URI for batch execution. | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID where the Dataproc batch job is submitted. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for Dataproc Serverless batch execution. | `string` | n/a | yes |
| <a name="input_runtime_properties"></a> [runtime\_properties](#input\_runtime\_properties) | Spark/Dataproc runtime properties. | `map(string)` | `{}` | no |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | Dataproc runtime version, for example 2.2. | `string` | `"2.2"` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | Service account email used by the Dataproc batch. | `string` | n/a | yes |
| <a name="input_staging_bucket"></a> [staging\_bucket](#input\_staging\_bucket) | Optional GCS staging bucket URI (gs://bucket-name). | `string` | `null` | no |
| <a name="input_subnetwork_uri"></a> [subnetwork\_uri](#input\_subnetwork\_uri) | Optional VPC subnetwork URI for batch execution. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dataproc_batch_id"></a> [dataproc\_batch\_id](#output\_dataproc\_batch\_id) | Dataproc batch identifier. |
| <a name="output_dataproc_batch_name"></a> [dataproc\_batch\_name](#output\_dataproc\_batch\_name) | Dataproc batch resource name. |
<!-- END_TF_DOCS -->