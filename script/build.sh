#!/bin/bash
 
# Set input and output directories
INPUT_DIR="./content"
OUTPUT_DIR="./docs"
 
# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"
 
# Function to create an index file
create_index_file() {
    local dir="$1"
    # Derive the output directory from the input directory
    local relative_path="${dir#"$INPUT_DIR/"}"
    local output_dir="$OUTPUT_DIR/$relative_path"
    local index_file="$output_dir/index.html"

    # Create the output directory if it doesn't exist
    mkdir -p "$output_dir"

    if [[ -f "$index_file" ]]; then return; fi

    {
        echo "<h1>Index</h1>"
        echo "<p><a href='../'>..</a></p>"  # Link to the parent directory

        # Link to subdirectories and Markdown files
        for entry in "$dir"/*; do
            if [[ -d "$entry" ]]; then
                echo "<p><a href='${entry#"$INPUT_DIR/"}index.html'>$(basename "$entry")</a></p>"
            elif [[ $entry == *.md ]]; then
                echo "<p><a href='${entry%.md}.html'>$(basename "$entry" .md)</a></p>"
            fi
        done
    } > "$index_file"

    echo "Created index file at $index_file"
}
 
# Function to convert Markdown files to HTML
convert_markdown_to_html() {
    for file in "$INPUT_DIR"/**/*.md; do
        if [[ -f "$file" ]]; then
            # Get the relative path without the leading './'
            relative_path="${file#"$INPUT_DIR/"}"
            # Create the output file path
            local output_file="$OUTPUT_DIR/${relative_path%.md}.html"
            # Create necessary directories
            mkdir -p "$(dirname "$output_file")"
            # Convert the file
            pandoc "$file" -o "$output_file"
            echo "Converted $file to $output_file"
        fi
    done
}
 
# Main execution
find "$INPUT_DIR" -type d | while read -r dir; do
    create_index_file "$dir"
done
 
convert_markdown_to_html
