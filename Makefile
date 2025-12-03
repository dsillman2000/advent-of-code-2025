install:
	@echo "Installing the application..."
	uv sync
	sh scripts/check-duckdb.sh
	@echo "Installation complete."

parquets:
	@echo "Converting .txt files in the inputs/ directory to Parquet format..."
	sh scripts/parquetify.sh
	@echo "Parquet conversion complete."

solve:
	@echo "Running SQL solutions on DuckDB..."
	sh scripts/solve.sh
	@echo "SQL solutions complete."

.PHONY: install parquets solve
