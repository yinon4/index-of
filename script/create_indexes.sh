#!/bin/bash

# Function to generate index.md in the specified directory
generate_index() {
    local dir="$1"
    local output_file="$dir/index.md"

    # Start the index file
    {
        echo "# Index of $(basename "$dir")"
        echo ""
        
        # Add a back link if this is not the root directory
        if [ "$dir" != "$INPUT_DIR" ]; then
            local parent_dir="$(dirname "$dir")"
            echo "- [🔙 Back](..)"
            echo ""
        fi
        
        # List all Markdown files
        find "$dir" -maxdepth 1 -type f -name '*.md' | while read -r md_file; do
            local md_filename=$(basename "$md_file")
            if [[ "$md_filename" != "index.md" ]]; then
                echo "- 📄 [${md_filename%.md}](${md_filename%.md})"
            fi
        done
        
        echo ""

        # List all subdirectories and generate their index files
        find "$dir" -maxdepth 1 -type d ! -name '.' | while read -r subdir; do
            if [ "$subdir" != "$dir" ]; then
                echo "- 📁 [$(basename "$subdir")]($(basename "$subdir"))"
            fi
        done
    } > "$output_file"

    # Recursively generate index.md for each subdirectory
    find "$dir" -maxdepth 1 -type d ! -name '.' | while read -r subdir; do
        if [ "$subdir" != "$dir" ]; then
          echo "found subdir: $subdir"
          generate_index "$subdir"
        fi
    done
}

# Check if a directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

INPUT_DIR="${1%/}"

# Check if the provided directory exists
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Directory '$INPUT_DIR' does not exist."
    exit 1
fi

# Generate the index files starting from the input directory
generate_index "$INPUT_DIR"

echo "Index files created recursively in '$INPUT_DIR'."
