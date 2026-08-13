# Retail Data Processing POC - Context

## 1. Project Overview

This project is a Proof of Concept (POC) for building a GCP-based retail
data processing pipeline.

The overall target architecture will eventually look like:

GitHub Actions
      |
      v
Cloud Storage
      |
      v
Dataproc Serverless
      |
      v
PySpark
      |
      v
Apache Iceberg
      |
      v
Cloud Storage
      |
      v
BigQuery / BigQuery Metastore
      |
      v
Looker / Looker Studio

However, the current implementation must focus ONLY on Phase 1.

Do NOT implement Iceberg, BigQuery Metastore, BigQuery, Looker,
Cloud Scheduler, Kafka, Kinesis, or any other future-phase component
in Phase 1.

---

# 2. POC Objective

The objective of Phase 1 is to prove that:

1. A retail dataset can be maintained in the GitHub repository.
2. GitHub Actions can upload the dataset to Google Cloud Storage (GCS).
3. GitHub Actions can submit a PySpark job to Dataproc Serverless.
4. Dataproc Serverless can execute the PySpark job.
5. PySpark can read the dataset from GCS.
6. PySpark can perform market-wise retail aggregation.
7. PySpark can write the processed result back to GCS.

The complete Phase-1 flow is:

GitHub Repository
      |
      | GitHub Actions
      v
GCS Input
      |
      | Dataproc Serverless
      v
PySpark
      |
      | Process and Aggregate
      v
GCS Output

---

# 3. Business Scenario

The POC represents a retail organization operating in multiple markets.

For Phase 1, use the following five markets:

- India
- United States
- United Kingdom
- Germany
- Australia

The source dataset represents retail transactions from these markets.

The objective is to process transaction-level data and generate
market-level aggregated results.

---

# 4. Input Dataset

Create a sample CSV dataset named:

data/retail_transactions.csv

The dataset should contain realistic but mock retail transaction data.

Required columns:

- transaction_id
- transaction_date
- market
- customer_id
- product_id
- product_name
- category
- quantity
- unit_price

Example:

transaction_id,transaction_date,market,customer_id,product_id,product_name,category,quantity,unit_price

TXN001,2026-08-01,India,CUST001,P001,Laptop,Electronics,2,750
TXN002,2026-08-01,United States,CUST002,P002,Phone,Electronics,1,900
TXN003,2026-08-01,United Kingdom,CUST003,P003,Chair,Furniture,4,120

The dataset should contain enough records across all five markets to
properly demonstrate aggregation.

Use mock data only.

Do not use real customer information or personally identifiable information.

---

# 5. GCS Structure

Use a single GCS bucket for this POC.

The bucket name should be configurable and should NOT be hardcoded
throughout the code.

Recommended structure:

gs://<PROJECT_ID>-<ENV>-retail-poc/

    input/
        retail_transactions.csv

    output/
        market_summary/

    jobs/
        retail_aggregation.py

The input dataset should be uploaded to:

gs://<BUCKET>/input/retail_transactions.csv

The PySpark job should be stored in GCS under:

gs://<BUCKET>/jobs/retail_aggregation.py

The processed output should be written under:

gs://<BUCKET>/output/market_summary/

---

# 6. PySpark Processing

Create:

src/spark/retail_aggregation.py

The PySpark application must:

1. Read the CSV dataset from GCS.
2. Infer or explicitly define the schema.
3. Validate the required columns.
4. Calculate:

   total_sales = quantity * unit_price

5. Group the data by market.
6. Generate the following aggregation:

- market
- total_transactions
- total_quantity
- total_sales
- average_order_value

The aggregation should be based on transaction-level data.

For example:

Market: India

total_transactions = count of transactions
total_quantity = sum(quantity)
total_sales = sum(quantity * unit_price)
average_order_value = total_sales / total_transactions

---

# 7. Output

The PySpark job should write the aggregated result to:

gs://<BUCKET>/output/market_summary/

For Phase 1, write the output as CSV or Parquet.

Prefer Parquet if practical because this POC is eventually going
to introduce Apache Iceberg and analytical processing.

DO NOT use Iceberg in Phase 1.

Example output:

market,total_transactions,total_quantity,total_sales,average_order_value

India,100,250,125000,1250
United States,120,300,180000,1500
United Kingdom,90,210,98000,1088.89
Germany,80,190,85000,1062.50
Australia,70,160,72000,1028.57

The actual numbers must be calculated from the input dataset and
must not be hardcoded.

---

# 8. GitHub Actions

Create:

.github/workflows/retail-poc.yml

The workflow should perform the following stages.

## Stage 1 - Checkout

Checkout the repository.

## Stage 2 - Authenticate to GCP

Authenticate GitHub Actions with GCP using:

- GitHub OIDC / Workload Identity Federation
- A dedicated GCP service account

DO NOT use long-lived GCP service account JSON keys.

Do not commit credentials, tokens, or secrets to the repository.

## Stage 3 - Upload Dataset

Upload:

data/retail_transactions.csv

to:

gs://<BUCKET>/input/retail_transactions.csv

## Stage 4 - Upload PySpark Job

Upload:

src/spark/retail_aggregation.py

to:

gs://<BUCKET>/jobs/retail_aggregation.py

## Stage 5 - Submit Dataproc Serverless Job

Submit the PySpark application using:

gcloud dataproc batches submit pyspark

The job should reference the PySpark script stored in GCS.

Example conceptual command:

gcloud dataproc batches submit pyspark \
  gs://<BUCKET>/jobs/retail_aggregation.py \
  --project=<PROJECT_ID> \
  --region=<REGION> \
  --service-account=<DATAPROC_SERVICE_ACCOUNT>

The exact implementation may use GitHub Actions environment variables
or repository variables.

---

# 9. Configuration

Do not hardcode environment-specific values.

The following should be configurable:

PROJECT_ID
REGION
ENVIRONMENT
GCS_BUCKET
DATAPROC_SERVICE_ACCOUNT

Recommended environment:

ENVIRONMENT=dev

Recommended region:

REGION=us-central1

Use GitHub Actions variables/secrets where appropriate.

Do not store sensitive credentials in the repository.

---

# 10. GCP Resources for Phase 1

Only the following GCP resources are required:

1. Google Cloud Storage bucket
2. Dataproc Serverless
3. GCP Service Account
4. IAM permissions
5. Workload Identity Federation for GitHub Actions
6. Cloud Logging

Cloud Logging should be used to troubleshoot Dataproc job execution.

No dedicated Dataproc cluster is required because this POC uses
Dataproc Serverless batches.

---

# 11. IAM Requirements

Use least-privilege permissions.

GitHub Actions needs permissions to:

- authenticate using Workload Identity Federation
- upload files to the GCS bucket
- submit Dataproc Serverless jobs

The Dataproc runtime service account needs permissions to:

- read the PySpark job from GCS
- read the input dataset from GCS
- write the processed output to GCS
- write/read required Dataproc logs

Do not grant Owner or Editor roles just to make the POC work.

Use the minimum practical IAM roles.

---

# 12. Expected End-to-End Execution

When a developer pushes code to the configured branch:

GitHub Push
    |
    v
GitHub Actions
    |
    v
Authenticate to GCP using OIDC
    |
    v
Upload retail_transactions.csv
    |
    v
Upload retail_aggregation.py
    |
    v
Submit Dataproc Serverless PySpark Job
    |
    v
Dataproc executes PySpark
    |
    v
Read CSV from GCS
    |
    v
Calculate total_sales
    |
    v
Aggregate by market
    |
    v
Write Parquet/CSV output to GCS
    |
    v
POC Complete

---

# 13. Expected Result

After successful execution, the GCS bucket should contain:

gs://<BUCKET>/

    input/
        retail_transactions.csv

    jobs/
        retail_aggregation.py

    output/
        market_summary/
            <generated-output-files>

The output must contain one aggregated result for each market.

Expected markets:

- India
- United States
- United Kingdom
- Germany
- Australia

---

# 14. Code Quality Requirements

All code must contain proper comments explaining:

- What the file does
- Why the file exists
- Important configuration
- Important processing logic
- GCP integration points
- Input and output locations

Comments should explain the PURPOSE of the code, not simply repeat
what the code is doing.

Example of a GOOD comment:

# Read the transaction dataset from GCS because the dataset is the
# input source for the Dataproc processing pipeline.

Avoid comments like:

# Read CSV
df = spark.read.csv(...)

---

# 15. Error Handling

The PySpark application should fail clearly if:

- Input file does not exist
- Required columns are missing
- Numeric columns contain invalid values
- The processing operation fails

The GitHub Actions workflow must fail if:

- GCP authentication fails
- Dataset upload fails
- PySpark job upload fails
- Dataproc job submission fails

Do not hide errors using `|| true` or equivalent commands.

---

# 16. Phase 1 Scope Restrictions

DO NOT implement the following in Phase 1:

- Apache Iceberg
- BigQuery
- BigQuery Metastore
- Looker
- Looker Studio
- Cloud Scheduler
- Kafka
- Kinesis
- Pub/Sub
- Cloud Functions
- Cloud Run
- GKE
- Terraform
- Production-grade orchestration
- Streaming processing
- Real customer data

The purpose of Phase 1 is only to prove:

GitHub Actions → GCS → Dataproc Serverless → PySpark → GCS

---

# 17. Future Phases

The architecture will be extended after Phase 1.

## Phase 2 - Apache Iceberg

Replace the Phase-1 output with an Iceberg table stored in GCS.

Flow:

Dataproc
    |
    v
PySpark
    |
    v
Apache Iceberg
    |
    v
GCS

---

## Phase 3 - BigQuery

Expose/query the Iceberg data through BigQuery.

Flow:

Dataproc
    |
    v
Iceberg
    |
    v
GCS
    |
    v
BigQuery
    |
    v
SQL Analytics

---

## Phase 4 - Metadata / Catalog

Introduce the appropriate BigQuery/Iceberg catalog or metadata
integration required by the final architecture.

---

## Phase 5 - Reporting

Connect Looker/Looker Studio to BigQuery.

Final flow:

GitHub Actions
      |
      v
GCS
      |
      v
Dataproc Serverless
      |
      v
PySpark
      |
      v
Iceberg
      |
      v
GCS
      |
      v
BigQuery / Metadata
      |
      v
Looker

---

# 18. Important Implementation Rule

Implement ONLY Phase 1 unless explicitly instructed to move to the
next phase.

Do not introduce additional GCP services or architecture components
just because they may be useful in a production environment.

The first goal is to get a complete working pipeline:

GitHub Actions
→ GCS
→ Dataproc Serverless
→ PySpark
→ Market Aggregation
→ GCS Output

Once this works successfully, the next phase can be implemented
incrementally.