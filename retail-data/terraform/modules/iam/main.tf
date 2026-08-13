locals {
  # Convert bucket->roles map into unique binding records for for_each usage.
  bucket_binding_records = flatten([
    for bucket_name, roles in var.bucket_role_bindings : [
      for role in roles : {
        key    = "${bucket_name}-${role}"
        bucket = bucket_name
        role   = role
      }
    ]
  ])
}

# Grants project-level roles to the provided IAM member.
resource "google_project_iam_member" "project_bindings" {
  for_each = toset(var.project_roles)

  project = var.project_id
  role    = each.value
  member  = var.member
}

# Supports single-bucket role grants for backward compatibility.
resource "google_storage_bucket_iam_member" "bucket_bindings" {
  for_each = toset(var.bucket_roles)

  bucket = var.bucket_name
  role   = each.value
  member = var.member
}

# Grants roles across multiple buckets via a map input.
resource "google_storage_bucket_iam_member" "multi_bucket_bindings" {
  for_each = {
    for record in local.bucket_binding_records : record.key => record
  }

  bucket = each.value.bucket
  role   = each.value.role
  member = var.member
}