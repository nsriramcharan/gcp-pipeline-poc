output "service_account_email" {
  description = "Email of the created service account."
  value       = google_service_account.this.email
}

output "service_account_name" {
  description = "Fully qualified resource name for the service account."
  value       = google_service_account.this.name
}

output "service_account_unique_id" {
  description = "Unique ID of the created service account."
  value       = google_service_account.this.unique_id
}