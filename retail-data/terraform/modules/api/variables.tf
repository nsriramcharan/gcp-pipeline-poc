variable "project_id" {
  description = "GCP project ID where APIs are enabled."
  type        = string
}

variable "apis" {
  description = "List of Google APIs to enable in the project."
  type        = list(string)
}

variable "disable_on_destroy" {
  description = "Whether to disable APIs when destroying Terraform resources."
  type        = bool
  default     = false
}