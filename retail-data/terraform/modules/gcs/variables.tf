variable "project_id" {
  description = "GCP project ID where the bucket is created."
  type        = string
}

variable "bucket_name" {
  description = "Globally unique GCS bucket name."
  type        = string
}

variable "location" {
  description = "Bucket location/region (for example US, EU, asia-south1)."
  type        = string
}

variable "storage_class" {
  description = "Storage class for the bucket."
  type        = string
  default     = "STANDARD"
}

variable "uniform_bucket_level_access" {
  description = "Enable uniform bucket-level access."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow deleting non-empty buckets when destroying resources."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable object versioning for the bucket."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels to apply to the bucket."
  type        = map(string)
  default     = {}
}

variable "lifecycle_rules" {
  description = "Optional lifecycle rules for objects in the bucket."
  type = list(object({
    age                  = number
    with_state           = string
    action_type          = string
    action_storage_class = string
  }))
  default = []
}