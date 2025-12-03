#!/bin/bash
# Script can take no arguments or one argument

if [ "$#" -gt 1 ]; then
    echo "Usage: $0 [solution_script]"
    exit 1
fi

if [ "$#" -eq 1 ]; then
    solution_script="$1"
    if [ ! -f "$solution_script" ]; then
        echo "Error: File '$solution_script' not found!"
        exit 1
    fi
    echo "Executing $solution_script..."
    duckdb -csv -c ".read '$solution_script'"
    exit 0
else
    solution_scripts=$(find solutions/ -type f -name "part-*.sql")

    for script in $solution_scripts; do
        echo "Executing $script..."
        duckdb -csv -c ".read '$script'"
    done
    exit 0
fi
