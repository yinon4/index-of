#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 <input directory> <output directory> [--css <path to css file>]"
    exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    usage
fi

INPUT_DIR="${1%/}"
OUTPUT_DIR="${2%/}"
CSS_FILE=""

# Parse optional arguments
while [[ "$#" -gt 0 ]]; do
    case $3 in
        (--css)
            CSS_FILE="$4"
            shift 2
            ;;
        (*)
            break
            ;;
    esac
done

# Check if the input directory exists
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Directory '$INPUT_DIR' does not exist."
    exit 1
fi

# Create output directory for HTML files
mkdir -p "$OUTPUT_DIR"

# If CSS_FILE is not provided, use a default or leave empty
if [[ -n "$CSS_FILE" && -f "$CSS_FILE" ]]; then
    CSS_CONTENT=$(<"$CSS_FILE")
else
    CSS_CONTENT=""
fi

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
    
    # Add <style> tag with CSS to the bottom of the HTML file, if CSS_CONTENT is not empty
    if [[ -n "$CSS_CONTENT" ]]; then
        echo "<style>${CSS_CONTENT}</style>" >> "$output_file"
    fi
    
    # Optional: Print conversion status
    echo "Converted '$md_file' to '$output_file'"
done

echo "Conversion completed. HTML files are located in '$OUTPUT_DIR'."

# Function to delete index.md files
delete_indexes() {
    find "$1" -name 'index.md' -type f -exec rm -f {} +
}

delete_indexes "$INPUT_DIR"
echo "All index.md files deleted."
