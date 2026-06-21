import os
import re
import json

admin_dir = r"c:\Users\T_com\Documents\ملفات مشروع التخرج\smart grading\grading_system\intelligent-grading\grade\lib\screens\Admin_interface"
ar_arb = r"c:\Users\T_com\Documents\ملفات مشروع التخرج\smart grading\grading_system\intelligent-grading\grade\lib\l10n\intl_ar.arb"
en_arb = r"c:\Users\T_com\Documents\ملفات مشروع التخرج\smart grading\grading_system\intelligent-grading\grade\lib\l10n\intl_en.arb"

mapping = {
    "مكتمل": "status_completed",
    "صيغة البريد الإلكتروني غير صحيحة": "err_invalid_email_format",
    "الرجاء اختيار ملف أولاً": "please_select_file_first",
    "لم يتم اختيار ملف": "error_no_file_selected",
    "رقم الجوال قصير جداً": "error_phone_too_short",
    "البريد الإلكتروني مسجل مسبقاً": "email_exists_error",
    "تأكد من عناوين الأعمدة في ملف الإكسيل": "error_check_excel_columns",
    "لا توجد عمليات مسجلة": "error_no_recorded_operations",
    "تمت إضافة $count مستخدم بنجاح": "success_users_added",  # special case
    "خطأ في الاتصال بالخادم": "connection_error",
    "تمت إضافة المستخدم بنجاح": "success_user_added",
    "العربية": "arabic_lang",
    "ص": "am_time",
    "م": "pm_time",
    "الآن": "just_now",
    "جاري تحميل النسخة: $backupDate": "loading_backup_version", # special case
    "فشل الحذف": "error_delete_failed",
    "فشل إنشاء النسخة": "error_backup_creation_failed",
    "كامل": "full_backup",
    "تم استعادة النظام من نسخة احتياطية": "success_system_restored",
    "خطأ: $e": "error_with_msg", # special case
    "جاري إنشاء نسخة احتياطية...": "creating_new_backup_snackbar",
    "خطأ في التحميل: $e": "error_loading_with_msg", # special case
    "غير محدد": "not_specified",
    "نسخ احتياطي ناجح": "alert_backup_success",
    "غير متاح": "not_available",
    "فشل الاستعادة": "error_restore_failed",
    "تمت الاستعادة بنجاح!": "success_restored_successfully",
    "جاري استعادة النظام...": "restoring_system_snackbar",
    "تم التحميل بنجاح!": "success_downloaded",
    "تم الحذف بنجاح": "delete_success",
    "فشل جلب البيانات: ${response.statusCode}": "error_fetch_data_with_code", # special case
    "فشل التحميل": "error_download_failed",
    "تم إنشاء نسخة احتياطية كاملة للنظام": "alert_backup_success_desc",
    "لا توجد سجلات": "error_no_records",
    "جاري النسخ...": "loading_copying",
    "لا توجد نسخ احتياطية": "error_no_backups",
    "فشل جلب البيانات": "error_fetch_data_simple",
    "حدث خطأ: $e": "error_occurred_with_msg", # special case
    "جاري بناء ملف الـ PDF...": "generating_pdf",
    "فشل التصدير: ${response.statusCode}": "error_export_failed_with_code", # special case
    "خطأ في الاتصال: $e": "connection_error_with_msg", # special case
    "تم تحميل التقرير بنجاح!": "success_report_downloaded",
    "جاري التصدير...": "loading_exporting",
    "لا توجد بيانات": "error_no_data",
    "مجهول": "unknown_user",
    "معلم": "role_teacher",
    "طالب": "role_student",
    "تم تحميل السجل بنجاح!": "log_download_success",
    "خطأ في جلب الإحصائيات: $e": "error_fetch_stats_with_msg", # special case
    "فشل التصدير": "export_error",
    "إدارة": "role_admin"
}

en_translations = {
    "err_invalid_email_format": "Invalid email format",
    "error_no_file_selected": "No file selected",
    "error_phone_too_short": "Phone number is too short",
    "error_check_excel_columns": "Check the columns in the Excel file",
    "error_no_recorded_operations": "No operations recorded",
    "success_users_added": "Successfully added {count} users",
    "success_user_added": "User added successfully",
    "arabic_lang": "Arabic",
    "am_time": "AM",
    "pm_time": "PM",
    "loading_backup_version": "Loading version: {backupDate}",
    "error_delete_failed": "Delete failed",
    "error_backup_creation_failed": "Backup creation failed",
    "full_backup": "Full",
    "success_system_restored": "System restored from backup",
    "error_with_msg": "Error: {e}",
    "error_loading_with_msg": "Loading error: {e}",
    "not_available": "Not available",
    "error_restore_failed": "Restore failed",
    "success_restored_successfully": "Restored successfully!",
    "success_downloaded": "Downloaded successfully!",
    "error_fetch_data_with_code": "Failed to fetch data: {statusCode}",
    "error_download_failed": "Download failed",
    "error_no_records": "No records found",
    "loading_copying": "Copying...",
    "error_no_backups": "No backups found",
    "error_fetch_data_simple": "Failed to fetch data",
    "error_occurred_with_msg": "Error occurred: {e}",
    "error_export_failed_with_code": "Export failed: {statusCode}",
    "connection_error_with_msg": "Connection error: {e}",
    "success_report_downloaded": "Report downloaded successfully!",
    "loading_exporting": "Exporting...",
    "error_no_data": "No data found",
    "unknown_user": "Unknown",
    "error_fetch_stats_with_msg": "Error fetching stats: {e}"
}

with open(ar_arb, 'r', encoding='utf-8') as f:
    ar_data = json.load(f)
with open(en_arb, 'r', encoding='utf-8') as f:
    en_data = json.load(f)

# Update ARB
for ar_str, key in mapping.items():
    if key not in ar_data:
        # Check if it has a variable
        if "$" in ar_str:
            clean_str = ar_str.replace("$count", "{count}").replace("$backupDate", "{backupDate}").replace("$e", "{e}").replace("${response.statusCode}", "{statusCode}")
            ar_data[key] = clean_str
            en_data[key] = en_translations.get(key, clean_str)
            ar_data[f"@{key}"] = {"placeholders": {}}
            en_data[f"@{key}"] = {"placeholders": {}}
            if "{count}" in clean_str:
                ar_data[f"@{key}"]["placeholders"]["count"] = {}
                en_data[f"@{key}"]["placeholders"]["count"] = {}
            if "{backupDate}" in clean_str:
                ar_data[f"@{key}"]["placeholders"]["backupDate"] = {}
                en_data[f"@{key}"]["placeholders"]["backupDate"] = {}
            if "{e}" in clean_str:
                ar_data[f"@{key}"]["placeholders"]["e"] = {}
                en_data[f"@{key}"]["placeholders"]["e"] = {}
            if "{statusCode}" in clean_str:
                ar_data[f"@{key}"]["placeholders"]["statusCode"] = {}
                en_data[f"@{key}"]["placeholders"]["statusCode"] = {}
        else:
            ar_data[key] = ar_str
            en_data[key] = en_translations.get(key, ar_str)

with open(ar_arb, 'w', encoding='utf-8') as f:
    json.dump(ar_data, f, ensure_ascii=False, indent=2)
with open(en_arb, 'w', encoding='utf-8') as f:
    json.dump(en_data, f, ensure_ascii=False, indent=2)

# Replace in files
for root, _, files in os.walk(admin_dir):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            modified = False
            for ar_str, key in mapping.items():
                if ar_str in content:
                    modified = True
                    # If it has variables, we need to pass them to S.of(context).key(variables)
                    # This is tricky without parsing. Let's do a simple replace for specific ones
                    if "$count" in ar_str:
                        content = content.replace(f"'{ar_str}'", f"S.of(context).{key}(count)")
                        content = content.replace(f'"{ar_str}"', f"S.of(context).{key}(count)")
                    elif "$backupDate" in ar_str:
                        content = content.replace(f"'{ar_str}'", f"S.of(context).{key}(backupDate)")
                        content = content.replace(f'"{ar_str}"', f"S.of(context).{key}(backupDate)")
                    elif "$e" in ar_str:
                        content = content.replace(f"'{ar_str}'", f"S.of(context).{key}(e.toString())")
                        content = content.replace(f'"{ar_str}"', f"S.of(context).{key}(e.toString())")
                    elif "${response.statusCode}" in ar_str:
                        content = content.replace(f"'{ar_str}'", f"S.of(context).{key}(response.statusCode.toString())")
                        content = content.replace(f'"{ar_str}"', f"S.of(context).{key}(response.statusCode.toString())")
                    else:
                        content = content.replace(f"'{ar_str}'", f"S.of(context).{key}")
                        content = content.replace(f'"{ar_str}"', f"S.of(context).{key}")
            
            if modified:
                # add import if not present
                if "import '../generated/l10n.dart';" not in content and "import '../../generated/l10n.dart';" not in content:
                    # simplistic: add at top
                    content = "import '../../generated/l10n.dart';\n" + content
                
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"Updated {file}")
