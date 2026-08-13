variable "project_id" {
  description = "GCP project ID where Workload Identity resources are managed."
  type        = string
}

variable "service_account_id" {
  description = "Service account resource name to grant Workload Identity access on."
  type        = string
}

variable "repository" {
  description = "GitHub repository in owner/repo format allowed to impersonate the service account."
  type        = string
}

variable "repository_owner" {
  description = "GitHub organization or user owner used in the default provider attribute condition."
  type        = string
}

variable "workload_identity_pool_name" {
  description = "Existing Workload Identity Pool full name; when null, this module creates a pool."
  type        = string
  default     = null
}

variable "workload_identity_pool_id" {
  description = "Workload Identity Pool ID (used when creating a pool and referenced by provider)."
  type        = string
  default     = "github-pool"
}

variable "workload_identity_pool_display_name" {
  description = "Display name for the Workload Identity Pool."
  type        = string
  default     = "GitHub Actions Pool"
}

variable "workload_identity_pool_description" {
  description = "Description for the Workload Identity Pool resource."
  type        = string
  default     = "Federation pool for GitHub Actions OIDC tokens."
}

variable "workload_identity_provider_id" {
  description = "Workload Identity Provider ID inside the pool."
  type        = string
  default     = "github-provider"
}

variable "workload_identity_provider_display_name" {
  description = "Display name for the Workload Identity Provider."
  type        = string
  default     = "GitHub OIDC Provider"
}

variable "workload_identity_provider_description" {
  description = "Description for the Workload Identity Provider resource."
  type        = string
  default     = "OIDC provider for token.actions.githubusercontent.com."
}

variable "oidc_issuer_uri" {
  description = "OIDC issuer URI used by the workload identity provider."
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
  description = "Optional custom CEL condition for provider token acceptance."
  type        = string
  default     = null
}
