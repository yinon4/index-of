import os

base_dir = './content'

def generate_index(dir_path):
    items = os.listdir(dir_path)
    index_content = '# Index\n\n'

    for item in items:
        full_path = os.path.join(dir_path, item)
        if os.path.isdir(full_path):
            index_content += f'- [📁 {item}](./{item}/index.md)\n'
        else:
            index_content += f'- [📄 {item}]({item})\n'

    with open(os.path.join(dir_path, 'index.md'), 'w') as index_file:
        index_file.write(index_content)

def walk_dir(dir_path):
    generate_index(dir_path)
    for entry in os.listdir(dir_path):
        full_path = os.path.join(dir_path, entry)
        if os.path.isdir(full_path):
            walk_dir(full_path)

if __name__ == '__main__':
    walk_dir(base_dir)
