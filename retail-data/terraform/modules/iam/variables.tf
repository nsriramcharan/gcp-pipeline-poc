variable "project_id" {
  description = "GCP project ID for project-level IAM bindings."
  type        = string
}

variable "member" {
  description = "IAM member identity, for example serviceAccount:sa@project.iam.gserviceaccount.com."
  type        = string
}

variable "project_roles" {
  description = "Project-level IAM roles to grant to the member."
  type        = list(string)
  default     = []
}

variable "bucket_name" {
  description = "Bucket name for bucket-level IAM bindings. Required when bucket_roles is not empty."
  type        = string
  default     = null
}

variable "bucket_roles" {
  description = "Bucket-level IAM roles to grant to the member."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.bucket_roles) == 0 || (var.bucket_name != null && var.bucket_name != "")
    error_message = "bucket_name must be provided when bucket_roles are set."
  }
}

variable "bucket_role_bindings" {
  description = "Map of bucket names to bucket-level roles for the same member (for example, object viewer/admin permissions per bucket)."
  type        = map(list(string))
  default     = {}
}