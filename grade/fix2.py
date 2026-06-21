import re

path = r'c:\Users\G.B\Downloads\intelligent-grading\grade\lib\screens\student_setting.dart'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace any remaining Get.snackbar
content = re.sub(r'Get\.snackbar\(\s*([^,]+),\s*([^,]+),\s*backgroundColor:\s*([^,]+),\s*colorText:\s*([^,]+),\s*snackPosition:\s*([^,)]+),\s*\);', r'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(\2), backgroundColor: \3));', content)
content = re.sub(r'Get\.snackbar\(\s*([^,]+),\s*([^,)]+),\s*\);', r'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(\2)));', content)

# There might be some with 3 arguments or similar? Let's do a more robust replace for Get.snackbar
# Or just replace all `Get.snackbar(...)`
def replacer(match):
    args = match.group(1)
    # The second argument is usually the message.
    # A simple fallback:
    return 'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).settingsError))); // Needs manual fix if args are complex'

# Let's replace the remaining ones precisely:
content = re.sub(r'Get\.snackbar\(\s*S\.of\(context\)\.[^,]+,\s*(S\.of\(context\)\.[^,)]+),\s*\);', r'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(\1)));', content)

content = re.sub(r'Get\.snackbar\(\s*S\.of\(context\)\.[^,]+,\s*(S\.of\(context\)\.[^,]+),\s*backgroundColor:\s*([^,]+),\s*colorText:\s*([^,]+),\s*\);', r'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(\1), backgroundColor: \2));', content)

# Get.isRegistered<SubjectScreenController>
content = re.sub(r'if\s*\(Get\.isRegistered<SubjectScreenController>\(\)\)\s*\{\s*Get\.find<SubjectScreenController>\(\)\.fetchSubjectsData\(', r'if (context.mounted) {\n              context.read<SubjectScreenController>().fetchSubjectsData(', content)

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Done")
