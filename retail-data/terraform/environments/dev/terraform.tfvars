project_id  = "budigital-practiceecommretail"
region      = "asia-south1"
environment = "dev"

common_labels = {
  owner = "data-platform"
  env   = "dev"
}

apis = [
  # Required for reading/writing retail dataset and Spark script artifacts.
  "storage.googleapis.com",
  # Required for Dataproc Serverless batch submission and execution.
  "dataproc.googleapis.com",
  # Required by Dataproc serverless networking/runtime dependencies.
  "compute.googleapis.com",
  # Required for service accounts and IAM policy bindings.
  "iam.googleapis.com",
  # Required by GitHub OIDC auth flow and token exchange.
  "iamcredentials.googleapis.com"
]

# Set to true if you want APIs removed from `apis` to be disabled on destroy.
api_disable_on_destroy = true

# Service account will be created as: sa-{environment}-{service_account_name_suffix}
service_account_name_suffix  = "retail-dataproc"
service_account_display_name = "Retail Dataproc Service Account"
service_account_description  = "Used by Dataproc and pipeline jobs in dev."
service_account_disabled     = false

# Project-level role for creating and viewing Dataproc Serverless batches.
service_account_project_roles = [
  "roles/dataproc.editor"
]

# Each entry provisions one bucket via for_each.
buckets = {
  input = {
    bucket_name       = "your-gcp-project-id-dev-retail-input"
    location          = "asia-south1"
    enable_versioning = true
    labels = {
      purpose = "input"
    }
  }

  output = {
    bucket_name = "your-gcp-project-id-dev-retail-output"
    location    = "asia-south1"
    labels = {
      purpose = "output"
    }
  }

  jobs = {
    bucket_name = "your-gcp-project-id-dev-retail-jobs"
    location    = "asia-south1"
    labels = {
      purpose = "jobs"
    }
  }
}

# Least-privilege bucket permissions for runtime and upload flows.
service_account_bucket_role_bindings = {
  "your-gcp-project-id-dev-retail-input" = [
    "roles/storage.objectAdmin"
  ]
  "your-gcp-project-id-dev-retail-jobs" = [
    "roles/storage.objectAdmin"
  ]
  "your-gcp-project-id-dev-retail-output" = [
    "roles/storage.objectAdmin"
  ]
}

input_bucket_key  = "input"
jobs_bucket_key   = "jobs"
output_bucket_key = "output"

# GitHub OIDC federation settings.
github_repository       = "nsriramcharan/gcp-pipeline-poc"
github_repository_owner = "nsriramcharan"

workload_identity_pool_name             = null
workload_identity_pool_id               = "github-pool"
workload_identity_pool_display_name     = "GitHub Actions Pool"
workload_identity_pool_description      = "Federation pool for GitHub Actions OIDC tokens."
workload_identity_provider_id           = "github-provider"
workload_identity_provider_display_name = "GitHub OIDC Provider"
workload_identity_provider_description  = "OIDC provider for GitHub Actions tokens."
oidc_issuer_uri                         = "https://token.actions.githubusercontent.com"

attribute_mapping = {
  "google.subject"       = "assertion.sub"
  "attribute.actor"      = "assertion.actor"
  "attribute.aud"        = "assertion.aud"
  "attribute.repository" = "assertion.repository"
  "attribute.ref"        = "assertion.ref"
}

# Leave null to use the default owner-level restriction based on github_repository_owner.
attribute_condition = null