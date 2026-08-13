variable "project_id" {
  description = "GCP project ID for this environment."
  type        = string
}

variable "region" {
  description = "Primary region used for resources."
  type        = string
  default     = "asia-south1"
}

variable "environment" {
  description = "Environment name used in naming and labels."
  type        = string
  default     = "dev"
}

variable "common_labels" {
  description = "Common labels applied to created resources."
  type        = map(string)
  default = {
    app = "retail-data-poc"
  }
}

variable "apis" {
  description = "List of APIs to enable. Remove APIs from this list to disable them when api_disable_on_destroy is true."
  type        = list(string)
  default = [
    "storage.googleapis.com",
    "dataproc.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com"
  ]
}

variable "api_disable_on_destroy" {
  description = "Disable APIs when they are removed from state/list and Terraform destroys those resources."
  type        = bool
  default     = false
}

variable "buckets" {
  description = "Map of bucket configurations; each map entry provisions one bucket."
  type = map(object({
    bucket_name                 = string
    location                    = optional(string, "asia-south1")
    storage_class               = optional(string, "STANDARD")
    uniform_bucket_level_access = optional(bool, true)
    force_destroy               = optional(bool, false)
    enable_versioning           = optional(bool, false)
    labels                      = optional(map(string), {})
    lifecycle_rules = optional(list(object({
      age                  = number
      with_state           = string
      action_type          = string
      action_storage_class = string
    })), [])
  }))
  default = {}
}

variable "service_account_name_suffix" {
  description = "Suffix appended to sa-{env}- for service account account_id creation."
  type        = string
  default     = "retail-pipeline"
}

variable "service_account_display_name" {
  description = "Display name for the provisioned service account."
  type        = string
  default     = null
}

variable "service_account_description" {
  description = "Description for the provisioned service account."
  type        = string
  default     = "Service account for retail data pipeline resources."
}

variable "service_account_disabled" {
  description = "Whether the provisioned service account should be disabled."
  type        = bool
  default     = false
}

variable "service_account_project_roles" {
  description = "Project-level IAM roles for the pipeline service account (for example Dataproc Serverless batch submission)."
  type        = list(string)
  default = [
    "roles/dataproc.editor"
  ]
}

variable "service_account_bucket_role_bindings" {
  description = "Bucket-level IAM roles by bucket name for the pipeline service account (least-privilege object permissions)."
  type        = map(list(string))
  default     = {}
}

variable "input_bucket_key" {
  description = "Logical key in the buckets map used as input data bucket."
  type        = string
  default     = "input"
}

variable "jobs_bucket_key" {
  description = "Logical key in the buckets map used for PySpark job script uploads."
  type        = string
  default     = "jobs"
}

variable "output_bucket_key" {
  description = "Logical key in the buckets map used for aggregation outputs."
  type        = string
  default     = "output"
}

variable "github_repository" {
  description = "GitHub repository in owner/repo format allowed to authenticate through OIDC."
  type        = string
}

variable "github_repository_owner" {
  description = "GitHub organization or user owner allowed by provider attribute condition."
  type        = string
}

variable "workload_identity_pool_name" {
  description = "Existing Workload Identity Pool full name; keep null to create a new pool."
  type        = string
  default     = null
}

variable "workload_identity_pool_id" {
  description = "Workload Identity Pool ID used when creating or referencing the pool."
  type        = string
  default     = "github-pool"
}

variable "workload_identity_pool_display_name" {
  description = "Display name for the Workload Identity Pool resource."
  type        = string
  default     = "GitHub Actions Pool"
}

variable "workload_identity_pool_description" {
  description = "Description for the Workload Identity Pool resource."
  type        = string
  default     = "Federation pool for GitHub Actions OIDC tokens."
}

variable "workload_identity_provider_id" {
  description = "Workload Identity Provider ID inside the selected pool."
  type        = string
  default     = "github-provider"
}

variable "workload_identity_provider_display_name" {
  description = "Display name for the Workload Identity Provider resource."
  type        = string
  default     = "GitHub OIDC Provider"
}

variable "workload_identity_provider_description" {
  description = "Description for the Workload Identity Provider resource."
  type        = string
  default     = "OIDC provider for GitHub Actions tokens."
}

variable "oidc_issuer_uri" {
  description = "OIDC issuer URI for GitHub Actions tokens."
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "attribute_mapping" {
  description = "Attribute mapping for GitHub OIDC token claims to Google attributes."
  type        = map(string)
  default = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
  }
}

variable "attribute_condition" {
  description = "Optional custom CEL condition; when null, repository owner restriction is applied."
  type        = string
  default     = null
}