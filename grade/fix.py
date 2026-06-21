import re

path = r'c:\Users\G.B\Downloads\intelligent-grading\grade\lib\screens\student_setting.dart'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Remove GetX import
content = re.sub(r"import 'package:get/get\.dart';\n?", '', content)

# 2. Replace Get.put
content = content.replace('final ctrl = Get.put(SettingsController());', 'SettingsController get ctrl => context.read<SettingsController>();')

# 3. Replace Get.isRegistered and Get.find
content = re.sub(r'if\s*\(Get\.isRegistered<StudentDashboardController>\(\)\)\s*\{\s*Get\.find<StudentDashboardController>\(\)\.fetchDashboardData\(', r'if (context.mounted) {\n              context.read<StudentDashboardController>().fetchDashboardData(', content)
content = re.sub(r'if\s*\(Get\.isRegistered<SubjectScreenController>\(\)\)\s*\{\s*Get\.find<SubjectScreenController>\(\)\.fetchSubjectsData\(', r'if (context.mounted) {\n              context.read<SubjectScreenController>().fetchSubjectsData(', content)

# 4. Replace Get.deleteAll and Get.offAll
content = content.replace('Get.deleteAll();', '')
content = content.replace('Get.offAll(() => const SmartCorrectorUI());', 'Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SmartCorrectorUI()), (route) => false);')

# 5. Replace Get.snackbar with ScaffoldMessenger
content = re.sub(r'Get\.snackbar\(\s*([^,]+),\s*([^,]+),\s*backgroundColor:\s*([^,]+),\s*colorText:\s*([^,]+),\s*snackPosition:\s*([^,)]+),\s*\);', r'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(\2), backgroundColor: \3));', content)
content = re.sub(r'Get\.snackbar\(\s*([^,]+),\s*([^,)]+),\s*\);', r'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(\2)));', content)

# Remove Obx(...) usages manually or with regex
# Replace Obx( () => ... ) with Consumer
# Wait, let's just use Builder for Obx: Obx(() => child) -> Builder(builder: (context) { context.watch<SettingsController>(); return child; })
content = re.sub(r'Obx\(\s*\(\)\s*=>\s*([\s\S]*?)\n\s*\),', r'Builder(builder: (context) { context.watch<SettingsController>(); return \1; }),', content)

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Done")
