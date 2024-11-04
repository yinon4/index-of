#!/bin/bash

# Convert a single file from markdown to html (including relative paths)
# takes a relative path and an output path as arguments

# Generate index.md files for all directories
generate_index() {
    local dir="$1"
    local output_file="$dir/index.md"
    local relative_path=$(realpath --relative-to="$INPUT_DIR" "$dir")


    # Start the index file
    {
        echo "# Index of /$relative_path"
        echo ""
        
        # Add a back link if this is not the root directory
        if [ "$dir" != "$INPUT_DIR" ]; then
            local parent_dir="$(dirname "$dir")"
            echo "- [⭠ **Back**](..)"
            echo ""
        fi
        
        # List all Markdown files
        find "$dir" -maxdepth 1 -type f -name '*.md' | while read -r md_file; do
            local md_filename=$(basename "$md_file")
            if [[ "$md_filename" != "index.md" ]]; then
                echo "- [**${md_filename%.md}**](${md_filename%.md})"
            fi
        done
        
        echo ""

        # List all subdirectories and generate their index files
        find "$dir" -maxdepth 1 -type d ! -name '.' | while read -r subdir; do
            if [ "$subdir" != "$dir" ]; then
                echo "- 📁 [**$(basename "$subdir")**]($(basename "$subdir"))"
            fi
        done
    } > "$output_file"

    echo "Generated index of $dir"

    # Recursively generate index.md for each subdirectory
    find "$dir" -maxdepth 1 -type d ! -name '.' | while read -r subdir; do
        if [ "$subdir" != "$dir" ]; then
          generate_index "$subdir"
        fi
    done
}


# Convert all markdown files to html files
md_to_html() {
  INPUT_DIR="${1%/}"
  OUTPUT_DIR="${2%/}"

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

    #   # Convert the markdown file to HTML
    #   html=$(perl ./scripts/Markdown.pl --html4tags "$md_file")
      # Convert the markdown file to HTML using Pandoc

    #   base=$(cat ./public/base.html)
    #   relPath=$(realpath --relative-to="$(dirname "$output_file")" "$OUTPUT_DIR/")
    #   relBase="${base//relative_path/$relPath}"
    #   filename=$(basename -- "$output_file")
    #   filename="${filename%.*}"

      html=$(pandoc "$md_file" -f markdown -t html -s)

    #   relBase="${relBase//page_title/$filename}"
    #   file="${relBase/md_content/$html}"

      echo $html > $output_file
      
      # Optional: Print conversion status
      echo "Converted '$md_file' to '$output_file'"
  done

  echo "Conversion completed. HTML files are located in '$OUTPUT_DIR'."
}

# Delete the index.md files
  delete_indexes() {
      find "$1" -name 'index.md' -type f -exec rm -f {} +
  }
