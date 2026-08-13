import argparse

from pyspark.sql import SparkSession
from pyspark.sql import functions as F


SUPPORTED_MARKETS = [
    "India",
    "United States",
    "United Kingdom",
    "Germany",
    "Australia",
]

REQUIRED_COLUMNS = [
    "transaction_id",
    "transaction_date",
    "market",
    "customer_id",
    "product_id",
    "product_name",
    "category",
    "quantity",
    "unit_price",
]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Retail market aggregation job")
    parser.add_argument(
        "--input",
        default="data/retail_transactions.csv",
        help="Input CSV path (local or gs://...).",
    )
    parser.add_argument(
        "--output",
        default="",
        help="Output path (local or gs://...). If omitted, results are shown in console.",
    )
    parser.add_argument(
        "--output-format",
        choices=["parquet", "csv"],
        default="parquet",
        help="Output format when --output is provided.",
    )
    return parser.parse_args()


def validate_columns(df_columns: list[str]) -> None:
    missing = [col for col in REQUIRED_COLUMNS if col not in df_columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")


def main() -> None:
    args = parse_args()

    spark = SparkSession.builder.appName("retail-data-poc").getOrCreate()

    df = (
        spark.read
        .option("header", True)
        .option("inferSchema", True)
        .csv(args.input)
    )

    validate_columns(df.columns)

    df = (
        df.filter(F.col("market").isin(SUPPORTED_MARKETS))
        .withColumn("total_sales", F.col("quantity") * F.col("unit_price"))
    )

    summary_df = (
        df.groupBy("market")
        .agg(
            F.count("transaction_id").alias("total_transactions"),
            F.sum("quantity").alias("total_quantity"),
            F.round(F.sum("total_sales"), 2).alias("total_sales"),
        )
        .withColumn(
            "average_order_value",
            F.round(F.col("total_sales") / F.col("total_transactions"), 2),
        )
        .orderBy("market")
    )

    if args.output:
        writer = summary_df.coalesce(1).write.mode("overwrite")
        if args.output_format == "csv":
            writer.option("header", True).csv(args.output)
        else:
            writer.parquet(args.output)
    else:
        summary_df.show(truncate=False)

    spark.stop()


if __name__ == "__main__":
    main()
