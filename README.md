# Advent of Code 2025 - DuckDB SQL Solutions

This repository contains my solutions to [Advent of Code 2025](https://adventofcode.com/2025) using DuckDB SQL.

Each day's input file is converted from text to Parquet format using a small Python script (`to_parquet.py`), then queried with DuckDB to solve the puzzles.

## Usage

To convert any .txt files in the `inputs/` directory to Parquet format, run:

```bash
sh scripts/parquetify.sh
```

Then use DuckDB to query a given Parquet file:

```sql
SELECT * FROM 'inputs/day-1/input.parquet';
```

## Structure

- `to_parquet.py` – Python script for text-to-Parquet conversion
- `solutions/day-*/part-*.sql` – Daily solution SQL files
- `inputs/` - Input files (not committed)

## Requirements

- Python ≥3.13
- pyarrow ≥22.0.0
- DuckDB CLI ≥1.3.0
