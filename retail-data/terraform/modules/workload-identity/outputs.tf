output "workload_identity_pool_name" {
  description = "Full Workload Identity Pool resource name used for federation."
  value       = local.effective_pool_name
}

output "workload_identity_provider_name" {
  description = "Full Workload Identity Provider resource name for GitHub Actions auth action."
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "workload_identity_member" {
  description = "The principalSet member string granted to the service account."
  value       = google_service_account_iam_member.wif_user.member
}
