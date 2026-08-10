from pyspark.sql import SparkSession
from pyspark.sql import functions as F


def main() -> None:
    spark = (
        SparkSession.builder
        .appName("retail-data-poc")
        .master("local[*]")
        .getOrCreate()
    )

    input_path = "data/retail_transactions.csv"

    df = (
        spark.read
        .option("header", True)
        .option("inferSchema", True)
        .csv(input_path)
        .withColumn("sales_amount", F.col("quantity") * F.col("unit_price"))
    )

    summary_df = (
        df.groupBy("store_id", "product_category")
        .agg(
            F.sum("sales_amount").alias("total_sales"),
            F.sum("quantity").alias("total_quantity"),
            F.count("transaction_id").alias("transaction_count"),
        )
        .orderBy("store_id", "product_category")
    )

    summary_df.show(truncate=False)
    spark.stop()


if __name__ == "__main__":
    main()
