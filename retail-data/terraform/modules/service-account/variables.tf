variable "project_id" {
  description = "GCP project ID where the service account is created."
  type        = string
}

variable "account_id" {
  description = "Service account ID (without domain)."
  type        = string
}

variable "display_name" {
  description = "Friendly display name for the service account."
  type        = string
  default     = null
}

variable "description" {
  description = "Service account description."
  type        = string
  default     = null
}

variable "disabled" {
  description = "Whether the service account is disabled."
  type        = bool
  default     = false
}