provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  default_bucket = {
    bucket_name                 = "${var.project_id}-${var.environment}-retail-poc"
    location                    = var.region
    storage_class               = "STANDARD"
    uniform_bucket_level_access = true
    force_destroy               = false
    enable_versioning           = false
    labels                      = {}
    lifecycle_rules             = []
  }

  effective_buckets = length(var.buckets) > 0 ? var.buckets : {
    retail_poc = local.default_bucket
  }

  # Resolve module outputs by logical bucket key for workflow usage.
  input_bucket_name  = try(module.gcs[var.input_bucket_key].bucket_name, null)
  jobs_bucket_name   = try(module.gcs[var.jobs_bucket_key].bucket_name, null)
  output_bucket_name = try(module.gcs[var.output_bucket_key].bucket_name, null)

  # Build a lowercase base name, then keep only [a-z0-9] chunks joined by hyphens.
  service_account_name_base = lower("sa-${var.environment}-${var.service_account_name_suffix}")

  # GCP service account account_id rules: lowercase letters, digits, hyphens, 6-30 chars.
  service_account_account_id = substr(
    trim(join("-", regexall("[a-z0-9]+", local.service_account_name_base)), "-"),
    0,
    30
  )
}

module "api" {
  source = "../../modules/api"

  project_id         = var.project_id
  apis               = var.apis
  disable_on_destroy = var.api_disable_on_destroy
}

module "gcs" {
  for_each = local.effective_buckets
  source   = "../../modules/gcs"

  project_id                  = var.project_id
  bucket_name                 = each.value.bucket_name
  location                    = each.value.location
  storage_class               = each.value.storage_class
  uniform_bucket_level_access = each.value.uniform_bucket_level_access
  force_destroy               = each.value.force_destroy
  enable_versioning           = each.value.enable_versioning
  labels                      = merge(var.common_labels, each.value.labels)
  lifecycle_rules             = each.value.lifecycle_rules
}

module "service_account" {
  source = "../../modules/service-account"

  project_id   = var.project_id
  account_id   = local.service_account_account_id
  display_name = var.service_account_display_name
  description  = var.service_account_description
  disabled     = var.service_account_disabled
}

# Grants project-level roles needed to submit Dataproc Serverless batches.
module "service_account_project_iam" {
  source = "../../modules/iam"

  project_id    = var.project_id
  member        = "serviceAccount:${module.service_account.service_account_email}"
  project_roles = var.service_account_project_roles
}

# Grants bucket permissions needed to upload input/job files and read/write job data.
module "service_account_bucket_iam" {
  source = "../../modules/iam"

  project_id           = var.project_id
  member               = "serviceAccount:${module.service_account.service_account_email}"
  bucket_role_bindings = var.service_account_bucket_role_bindings
}

# Provisions GitHub OIDC federation and binds the selected repository to the service account.
module "workload_identity" {
  source = "../../modules/workload-identity"

  project_id                              = var.project_id
  service_account_id                      = module.service_account.service_account_name
  repository                              = var.github_repository
  repository_owner                        = var.github_repository_owner
  workload_identity_pool_name             = var.workload_identity_pool_name
  workload_identity_pool_id               = var.workload_identity_pool_id
  workload_identity_pool_display_name     = var.workload_identity_pool_display_name
  workload_identity_pool_description      = var.workload_identity_pool_description
  workload_identity_provider_id           = var.workload_identity_provider_id
  workload_identity_provider_display_name = var.workload_identity_provider_display_name
  workload_identity_provider_description  = var.workload_identity_provider_description
  oidc_issuer_uri                         = var.oidc_issuer_uri
  attribute_mapping                       = var.attribute_mapping
  attribute_condition                     = var.attribute_condition
}
