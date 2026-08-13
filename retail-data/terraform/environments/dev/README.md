# Dev Environment Terraform Runbook

This document lists the required checks and setup steps to complete before running `terraform plan` or `terraform apply` in this folder.

## 1. Tooling Prerequisites

- Install Terraform 1.5+.
- Install Google Cloud SDK (`gcloud`) and authenticate locally.
- Ensure your account can manage:
  - Project APIs
  - IAM policy bindings
  - Service accounts
  - GCS buckets
  - Workload Identity Pool/Provider resources

## 2. Set Target Project and Identity

From this folder, verify active project and caller identity:

```bash
gcloud config set project <YOUR_PROJECT_ID>
gcloud auth list
gcloud config get-value project
```

## 3. Review and Update terraform.tfvars

Update [terraform.tfvars](terraform.tfvars) with real values:

- `project_id`
- `region`
- `environment`
- `buckets` names (must be globally unique)
- `service_account_bucket_role_bindings` bucket names must match the bucket names in `buckets`
- `github_repository` (owner/repo)
- `github_repository_owner`

Notes:

- Keep `api_disable_on_destroy = false` unless you intentionally want API disable behavior when resources are removed.
- Service account ID is generated as `sa-{environment}-{service_account_name_suffix}` (sanitized and truncated to GCP limits).

## 4. Validate Required APIs and IAM Intent

Confirm your API list (`apis`) includes at least:

- `storage.googleapis.com`
- `dataproc.googleapis.com`
- `compute.googleapis.com`
- `iam.googleapis.com`
- `iamcredentials.googleapis.com`

Confirm roles are least-privilege for this POC:

- Project roles in `service_account_project_roles`
- Bucket roles in `service_account_bucket_role_bindings`

## 5. Initialize and Validate Terraform

Run from this directory:

```bash
terraform init
terraform validate
terraform fmt -check
```

## 6. Create and Review a Plan

```bash
terraform plan -out=tfplan
terraform show tfplan
```

Review all planned actions carefully, especially:

- API enablement changes
- IAM binding additions
- Workload Identity Pool/Provider creation
- Bucket creation and labels

## 7. Apply Changes

```bash
terraform apply tfplan
```

## 8. Capture Outputs for GitHub Actions

After apply, capture these outputs and map them to GitHub repository variables:

```bash
terraform output workload_identity_provider_name
terraform output service_account_email
terraform output input_data_uri
terraform output jobs_script_uri
terraform output output_data_uri
```

Recommended GitHub variables mapping:

- `GCP_PROJECT_ID` <- your project id
- `GCP_REGION` <- your region
- `GCP_WIF_PROVIDER` <- `workload_identity_provider_name`
- `GCP_DEPLOYER_SERVICE_ACCOUNT` <- service account that GitHub auth action should impersonate
- `GCP_DATAPROC_SERVICE_ACCOUNT` <- runtime service account email for Dataproc batches
- `GCS_INPUT_URI` <- `input_data_uri`
- `GCS_JOBS_URI` <- `jobs_script_uri`
- `GCS_OUTPUT_URI` <- `output_data_uri`

## 9. Optional Safety Checks Before Re-Apply

- Run `terraform plan` again and confirm no unexpected drift.
- If changing bucket names, update bucket IAM bindings in the same change.
- If changing repository owner/repo, verify OIDC condition and provider mapping still match.
