import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'AppColors.' not in content:
        return

    # Replace AppColors.property with context.colors.property
    new_content = re.sub(r'AppColors\.([a-zA-Z0-9_]+)', r'context.colors.\1', content)

    # Add import if context.colors is used
    if 'context.colors.' in new_content and 'app_colors_extension.dart' not in new_content:
        imports = re.findall(r'^import .*;$', new_content, re.MULTILINE)
        if imports:
            last_import = imports[-1]
            new_content = new_content.replace(last_import, last_import + '\nimport \'package:pawcity/core/theme/app_colors_extension.dart\';')

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)

for root, dirs, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart') and file not in ['app_colors.dart', 'app_theme.dart', 'app_colors_extension.dart', 'app_gradients.dart', 'app_text_styles.dart']:
            process_file(os.path.join(root, file))
