import os
import shutil

base_dir = './content'
output_dir = './out'

def generate_index(dir_path, output_path):
    items = os.listdir(dir_path)
    index_content = '# Index\n\n'

    parent_dir = os.path.basename(os.path.dirname(dir_path))
    if parent_dir != '.':
        index_content += f'- [🔙 Back to {parent_dir}](../index.md)\n\n'

    for item in items:
        if item == 'index.md':
            continue

        full_path = os.path.join(dir_path, item)
        if os.path.isdir(full_path):
            index_content += f'- [📁 {item}](./{item}/index.md)\n'
        else:
            index_content += f'- [📄 {item}]({item})\n'

    # Ensure the output directory exists
    os.makedirs(output_path, exist_ok=True)

    # Write the index.md to the output directory
    with open(os.path.join(output_path, 'index.md'), 'w') as index_file:
        index_file.write(index_content)

def copy_files_with_back_button(dir_path, output_path):
    items = os.listdir(dir_path)

    for item in items:
        if item == 'index.md':
            continue

        full_path = os.path.join(dir_path, item)
        if os.path.isfile(full_path) and item.endswith('.md'):
            # Create a back button to the parent directory
            parent_dir = os.path.basename(dir_path)
            back_button = f'- [🔙 Back to {parent_dir}](../index.md)\n\n'

            with open(full_path, 'r') as md_file:
                content = md_file.read()

            # Write to the output directory with the back button
            output_file_path = os.path.join(output_path, item)
            os.makedirs(output_path, exist_ok=True)  # Ensure output path exists
            with open(output_file_path, 'w') as md_file:
                md_file.write(back_button + content)

def walk_dir(dir_path, output_path):
    # Create or update the index.md in the output directory
    generate_index(dir_path, output_path)

    # Copy other Markdown files with back buttons
    copy_files_with_back_button(dir_path, output_path)

    for entry in os.listdir(dir_path):
        full_path = os.path.join(dir_path, entry)
        if os.path.isdir(full_path):
            # Create a corresponding output directory for subdirectories
            sub_output_path = os.path.join(output_path, entry)
            walk_dir(full_path, sub_output_path)

if __name__ == '__main__':
    # Clean up existing output directory if it exists
    if os.path.exists(output_dir):
        shutil.rmtree(output_dir)
    
    walk_dir(base_dir, output_dir)
