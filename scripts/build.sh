#!/bin/bash

# Source the functions file
source "$(dirname "$0")/functions.sh"


# Check if enough arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <input directory> <output directory> [--public <path to public directory>]"
    exit 1
fi

INPUT_DIR="${1%/}"
OUTPUT_DIR="${2%/}"
PUBLIC_DIR=""

# Parse optional arguments
if [ "$3" == "--public" ]; then
    PUBLIC_DIR="$4"
fi

# Check if the input directory exists
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Directory '$INPUT_DIR' does not exist."
    exit 1
fi

# Check if the output directory exists and delete it
rm -rf ${OUTPUT_DIR} 2>/dev/null

# Generate index.md files for all directories
generate_index "$INPUT_DIR"

# Convert all markdown files to html files
md_to_html "$INPUT_DIR" "$OUTPUT_DIR"

# Copy public directory to the output directory
if [ -n "$PUBLIC_DIR" ]; then
    cp -r "$PUBLIC_DIR" "$OUTPUT_DIR"
    echo "Copied public directory to the output directory"
fi

# Delete the index.md files
delete_indexes "$INPUT_DIR"

echo "Build completed successfully."