#!/bin/bash

# Source the functions file
source "$(dirname "$0")/functions.sh"


# Check if enough arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <input directory> <output directory> [--css <path to css file>]"
    exit 1
fi

INPUT_DIR="${1%/}"
OUTPUT_DIR="${2%/}"
CSS_FILE=""

# Parse optional arguments
if [ "$3" == "--css" ]; then
    CSS_FILE="$4"
fi

# Check if the input directory exists
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Directory '$INPUT_DIR' does not exist."
    exit 1
fi

# Generate index.md files for all directories
generate_index "$INPUT_DIR"

# Convert all markdown files to html files
md_to_html "$INPUT_DIR" "$OUTPUT_DIR" "$CSS_FILE"

# Delete the index.md files
delete_indexes "$INPUT_DIR"

echo "Build completed successfully."