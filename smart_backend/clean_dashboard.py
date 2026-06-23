import re

filepath = r'c:\Users\G.B\Downloads\intelligent-grading\smart_backend\crud\student_dashbord.py'
with open(filepath, 'r', encoding='utf-8') as f:
    lines = f.readlines()

new_lines = []
for line in lines:
    if line.strip().startswith('#'):
        new_lines.append(line)
        continue
    
    # We want to remove the lines that set user_lang from DB in active code
    if 'user_lang = profile["language_code"]' in line:
        new_lines.append(line.replace('user_lang = profile["language_code"] if profile and profile["language_code"] else "ar"', '# removed user_lang DB override'))
        continue
        
    if 'user_lang = db.execute(lang_query' in line:
        new_lines.append(line.replace('user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"', '# removed user_lang DB override'))
        continue

    if 'lang_query = text("SELECT language_code' in line:
        new_lines.append(line.replace('lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")', '# removed lang_query'))
        continue

    new_lines.append(line)

with open(filepath, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)
print('Done cleaning student_dashbord.py')
