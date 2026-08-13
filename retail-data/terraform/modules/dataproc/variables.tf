variable "project_id" {
  description = "GCP project ID where the Dataproc batch job is submitted."
  type        = string
}

variable "region" {
  description = "Region for Dataproc Serverless batch execution."
  type        = string
}

variable "batch_id" {
  description = "Unique Dataproc batch ID."
  type        = string
}

variable "main_python_file_uri" {
  description = "GCS URI of the main PySpark job file."
  type        = string
}

variable "service_account" {
  description = "Service account email used by the Dataproc batch."
  type        = string
}

variable "args" {
  description = "Command line arguments passed to the PySpark application."
  type        = list(string)
  default     = []
}

variable "jar_file_uris" {
  description = "Optional JAR dependencies for the PySpark batch."
  type        = list(string)
  default     = []
}

variable "file_uris" {
  description = "Optional files made available to the batch runtime."
  type        = list(string)
  default     = []
}

variable "archive_uris" {
  description = "Optional archives extracted for the batch runtime."
  type        = list(string)
  default     = []
}

variable "runtime_version" {
  description = "Dataproc runtime version, for example 2.2."
  type        = string
  default     = "2.2"
}

variable "runtime_properties" {
  description = "Spark/Dataproc runtime properties."
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Labels applied to the Dataproc batch."
  type        = map(string)
  default     = {}
}

variable "network_uri" {
  description = "Optional VPC network URI for batch execution."
  type        = string
  default     = null
}

variable "subnetwork_uri" {
  description = "Optional VPC subnetwork URI for batch execution."
  type        = string
  default     = null
}

variable "staging_bucket" {
  description = "Optional GCS staging bucket URI (gs://bucket-name)."
  type        = string
  default     = null
}