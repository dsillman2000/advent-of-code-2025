#!/usr/bin/env python3
"""
Super tiny CLI to convert a text file to a parquet file of lines.
"""

import argparse
import sys
from pathlib import Path

import pyarrow as pa
import pyarrow.parquet as pq


def text_to_parquet(input_file: Path, output_file: Path, verbose: bool = False) -> None:
    """
    Read a text file line by line and write to a parquet file.

    The parquet file will have a single column named "line" containing each line
    from the input file as a string.
    """
    if verbose:
        print(f"Reading lines from {input_file}")

    lines = []
    try:
        with open(input_file, "r", encoding="utf-8") as f:
            for line_num, line in enumerate(f, start=1):
                # Remove trailing newline but keep empty lines as empty strings
                lines.append(line.rstrip("\n"))
                if verbose and line_num % 1000 == 0:
                    print(f"  Read {line_num} lines...")
    except FileNotFoundError:
        sys.exit(f"Error: Input file '{input_file}' not found.")
    except PermissionError:
        sys.exit(f"Error: No permission to read '{input_file}'.")
    except Exception as e:
        sys.exit(f"Error reading '{input_file}': {e}")

    if verbose:
        print(f"Read {len(lines)} lines total.")

    # Create a pyarrow Table
    table = pa.table({"line": lines})

    if verbose:
        print(f"Writing {len(lines)} lines to {output_file}")

    try:
        pq.write_table(table, output_file)
    except Exception as e:
        sys.exit(f"Error writing to '{output_file}': {e}")

    if verbose:
        print("Done.")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert a text file to a parquet file of lines.",
        epilog="Example: %(prog)s input.txt output.parquet",
    )
    parser.add_argument(
        "input_file",
        type=Path,
        help="Path to the input text file",
    )
    parser.add_argument(
        "output_file",
        type=Path,
        nargs="?",
        default=Path("output.parquet"),
        help="Path to the output parquet file (default: output.parquet)",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Print progress information",
    )

    args = parser.parse_args()

    text_to_parquet(args.input_file, args.output_file, args.verbose)


if __name__ == "__main__":
    main()
