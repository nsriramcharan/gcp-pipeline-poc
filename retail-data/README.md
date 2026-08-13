# retail-data

Proof of concept for retail transaction aggregation with PySpark and GitHub Actions.

## Project Structure

```text
gcp-pipeline-poc/
|-- .github/workflows/retail-poc.yml
`-- retail-data/
   |-- data/retail_transactions.csv
   |-- src/spark/retail_aggregation.py
   |-- docs/POC_CONTEXT.md
   `-- README.md
```

## Run Locally

1. Install Python 3.11+ and Java (required by Spark).
2. Install dependencies:
   ```bash
   pip install pyspark
   ```
3. Run the job:
   ```bash
   python src/spark/retail_aggregation.py
   ```
