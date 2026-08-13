# Creates a dedicated service account for pipeline and Dataproc operations.
resource "google_service_account" "this" {
  project      = var.project_id
  account_id   = var.account_id
  display_name = var.display_name
  description  = var.description
  disabled     = var.disabled
}