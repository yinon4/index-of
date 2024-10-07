#!/bin/bash

# Check if the directories are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input directory> <output directory>"
    exit 1
fi

INPUT_DIR="${1%/}"
OUTPUT_DIR="${2%/}"

# Check if the provided directory exists
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Directory '$INPUT_DIR' does not exist."
    exit 1
fi

# Create output directory for HTML files
mkdir -p "$OUTPUT_DIR"

# Find all .md files and convert them to .html
find "$INPUT_DIR" -type f -name '*.md' | while read -r md_file; do
    # Get the relative path of the md file
    relative_path="${md_file#$INPUT_DIR/}"
    
    # Create the corresponding output path by replacing .md with .html
    output_file="$OUTPUT_DIR/${relative_path%.md}.html"
    
    # Create the output directory if it doesn't exist
    mkdir -p "$(dirname "$output_file")"
    
    # Convert using pandoc
    pandoc "$md_file" -o "$output_file"
    
    # Optional: Print conversion status
    echo "Converted '$md_file' to '$output_file'"
done

echo "Conversion completed. HTML files are located in '$OUTPUT_DIR'."
