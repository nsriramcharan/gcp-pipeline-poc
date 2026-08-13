output "project_roles_applied" {
  description = "Project roles that were applied for the member."
  value       = keys(google_project_iam_member.project_bindings)
}

output "bucket_roles_applied" {
  description = "Bucket roles that were applied for the member."
  value       = keys(google_storage_bucket_iam_member.bucket_bindings)
}

output "multi_bucket_roles_applied" {
  description = "Bucket-role bindings applied through bucket_role_bindings."
  value       = keys(google_storage_bucket_iam_member.multi_bucket_bindings)
}