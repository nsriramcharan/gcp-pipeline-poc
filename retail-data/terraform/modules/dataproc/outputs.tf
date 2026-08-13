output "dataproc_batch_id" {
  description = "Dataproc batch identifier."
  value       = google_dataproc_batch.this.batch_id
}

output "dataproc_batch_name" {
  description = "Dataproc batch resource name."
  value       = google_dataproc_batch.this.name
}