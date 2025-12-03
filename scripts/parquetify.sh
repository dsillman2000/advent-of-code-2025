text_files=$(find inputs/ -type f -name "*.txt")

for file in $text_files; do
    # Replace .txt extension with .parquet while preserving directory structure
    parquet_path="${file%.txt}.parquet"
    echo "Processing $file -> $parquet_path"
    uv run python3 to_parquet.py "$file" "$parquet_path"
done;
