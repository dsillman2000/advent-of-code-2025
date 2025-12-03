#!/bin/sh

if ! command -v duckdb > /dev/null 2>&1; then
    echo "DuckDB could not be found. Please install DuckDB before proceeding."
    exit 1
else
    DUCKDB_VERSION=$(duckdb --version 2>&1)
    echo "Found DuckDB version: $DUCKDB_VERSION"
    exit 0
fi
