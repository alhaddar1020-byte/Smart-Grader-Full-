import os
import re
import json

admin_dir = r"c:\Users\T_com\Documents\ملفات مشروع التخرج\smart grading\grading_system\intelligent-grading\grade\lib\screens\Admin_interface"

arabic_pattern = re.compile(r'[\u0600-\u06FF]')

extracted = []

for root, _, files in os.walk(admin_dir):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Find all string literals (single or double quotes)
            matches = re.findall(r'([\'"])(.*?)\1', content)
            
            # We want unique strings per file
            unique_strings = set()
            for quote, text in matches:
                if arabic_pattern.search(text):
                    unique_strings.add(text)
                    
            for text in unique_strings:
                extracted.append({"file": file, "text": text})

# Save to JSON
with open('arabic_strings.json', 'w', encoding='utf-8') as f:
    json.dump(extracted, f, ensure_ascii=False, indent=4)
