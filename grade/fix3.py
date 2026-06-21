import re

path = r'c:\Users\G.B\Downloads\intelligent-grading\grade\lib\screens\student_setting.dart'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the broken Builder syntax
content = content.replace('isMobile ? _buildMobileLayout() : _buildWebLayout(),; }),', 'isMobile ? _buildMobileLayout() : _buildWebLayout(); }),')
content = content.replace(',; }),', '; }),')

# Remove .value from ctrl variables
content = re.sub(r'(ctrl\.[a-zA-Z0-9_]+)\.value', r'\1', content)

# Fix Get.isRegistered and Get.find remaining issues
content = re.sub(r'if\s*\(Get\.isRegistered<StudentDashboardController>\(\)\)', r'if (context.mounted)', content)
content = re.sub(r'Get\.find<StudentDashboardController>\(\)', r'context.read<StudentDashboardController>()', content)

content = re.sub(r'if\s*\(Get\.isRegistered<SubjectScreenController>\(\)\)', r'if (context.mounted)', content)
content = re.sub(r'Get\.find<SubjectScreenController>\(\)', r'context.read<SubjectScreenController>()', content)

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Done")
