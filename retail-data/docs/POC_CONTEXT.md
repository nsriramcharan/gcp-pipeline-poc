# Retail Data POC Context

## Goal
Build a lightweight proof of concept for retail transaction aggregation using PySpark.

## Scope
- Ingest transaction data from CSV.
- Compute store and category level aggregates.
- Run aggregation in local mode and CI.

## Inputs
- Source file: `data/retail_transactions.csv`
- Key fields: `store_id`, `product_category`, `quantity`, `unit_price`

## Outputs
- Aggregated totals by store and category.
- Console output from Spark aggregation job.

## Next Steps
- Add unit tests for data transformations.
- Add output write path (Parquet/BigQuery).
- Parameterize input and output paths.
