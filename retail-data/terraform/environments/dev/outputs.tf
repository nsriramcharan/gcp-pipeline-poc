output "enabled_apis" {
  description = "APIs enabled in this environment."
  value       = module.api.enabled_apis
}

output "bucket_names" {
  description = "Bucket names created by this environment."
  value       = { for k, m in module.gcs : k => m.bucket_name }
}

output "bucket_urls" {
  description = "Bucket URLs created by this environment."
  value       = { for k, m in module.gcs : k => m.bucket_url }
}

output "service_account_email" {
  description = "Email of the provisioned service account."
  value       = module.service_account.service_account_email
}

output "service_account_name" {
  description = "Fully qualified name of the provisioned service account."
  value       = module.service_account.service_account_name
}

output "workload_identity_provider_name" {
  description = "Workload Identity Provider full resource name for GitHub Actions auth."
  value       = module.workload_identity.workload_identity_provider_name
}

output "workload_identity_pool_name" {
  description = "Workload Identity Pool full resource name used for principalSet bindings."
  value       = module.workload_identity.workload_identity_pool_name
}

output "input_data_uri" {
  description = "GCS URI for retail input dataset uploads from GitHub Actions."
  value       = "gs://${local.input_bucket_name}/input/retail_transactions.csv"
}

output "jobs_script_uri" {
  description = "GCS URI for retail PySpark script uploads from GitHub Actions."
  value       = "gs://${local.jobs_bucket_name}/jobs/retail_aggregation.py"
}

output "output_data_uri" {
  description = "GCS URI prefix for market aggregation outputs written by Dataproc Serverless."
  value       = "gs://${local.output_bucket_name}/output/market_summary/"
}