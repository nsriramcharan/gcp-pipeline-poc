resource "google_dataproc_batch" "this" {
  provider = google-beta

  project  = var.project_id
  location = var.region
  batch_id = var.batch_id
  labels   = var.labels

  pyspark_batch {
    main_python_file_uri = var.main_python_file_uri
    args                 = var.args
    jar_file_uris        = var.jar_file_uris
    file_uris            = var.file_uris
    archive_uris         = var.archive_uris
  }

  runtime_config {
    version    = var.runtime_version
    properties = var.runtime_properties
  }

  environment_config {
    execution_config {
      service_account = var.service_account
      network_uri     = var.network_uri
      subnetwork_uri  = var.subnetwork_uri
      staging_bucket  = var.staging_bucket
    }
  }
}