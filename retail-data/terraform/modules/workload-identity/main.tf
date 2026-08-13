locals {
  # Use an existing pool full name when provided; otherwise use the pool created by this module.
  effective_pool_name = var.workload_identity_pool_name != null ? var.workload_identity_pool_name : google_iam_workload_identity_pool.github[0].name

  # Default provider condition restricts tokens to a single GitHub organization owner.
  effective_attribute_condition = var.attribute_condition != null ? var.attribute_condition : format("assertion.repository_owner == \"%s\"", var.repository_owner)
}

# Creates the Workload Identity Pool used for GitHub Actions federation.
resource "google_iam_workload_identity_pool" "github" {
  count = var.workload_identity_pool_name == null ? 1 : 0

  project                   = var.project_id
  workload_identity_pool_id = var.workload_identity_pool_id
  display_name              = var.workload_identity_pool_display_name
  description               = var.workload_identity_pool_description
}

# Creates an OIDC provider for tokens issued by GitHub Actions.
resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = var.workload_identity_pool_name == null ? google_iam_workload_identity_pool.github[0].workload_identity_pool_id : var.workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_provider_id
  display_name                       = var.workload_identity_provider_display_name
  description                        = var.workload_identity_provider_description
  attribute_mapping                  = var.attribute_mapping
  attribute_condition                = local.effective_attribute_condition

  oidc {
    issuer_uri = var.oidc_issuer_uri
  }
}

# Allows GitHub tokens from the selected repository to impersonate the target service account.
resource "google_service_account_iam_member" "wif_user" {
  service_account_id = var.service_account_id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${local.effective_pool_name}/attribute.repository/${var.repository}"
}
