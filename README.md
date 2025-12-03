# Advent of Code 2025 - DuckDB SQL Solutions

This repository contains my solutions to [Advent of Code 2025](https://adventofcode.com/2025) using DuckDB SQL.

Each day's input file is converted from text to Parquet format using a small Python script (`main.py`), then queried with DuckDB to solve the puzzles.

## Usage

To convert a text input file to Parquet:

```bash
python main.py input.txt output.parquet
```

Then use DuckDB to query the Parquet file:

```sql
SELECT * FROM 'output.parquet';
```

## Structure

- `main.py` – Python script for text-to-Parquet conversion
- Daily solution SQL files (to be added)
- Input files (not committed)

## Requirements

- Python ≥3.13
- pyarrow ≥22.0.0
- DuckDB
