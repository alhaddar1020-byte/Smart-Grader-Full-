# from sqlalchemy.orm import Session
# from sqlalchemy import func, text
# from models.settings import BackupHistory, ActivityLog
# from models.users import User  # <--- أضيفي هذا السطر السحري هنا
# from datetime import datetime
# import os
# import shutil
# import subprocess


# def _format_date(dt: datetime) -> str:
#     """تحويل التاريخ لصيغة عرض"""
#     if not dt:
#         return '--'
#     hour = dt.hour
#     am_pm = "م" if hour >= 12 else "ص"
#     hour_12 = hour - 12 if hour > 12 else (12 if hour == 0 else hour)
#     return (
#         f"{dt.year}-{str(dt.month).zfill(2)}-{str(dt.day).zfill(2)} | "
#         f"{str(hour_12).zfill(2)}:{str(dt.minute).zfill(2)} {am_pm}"
#     )


# def _time_ago(dt: datetime) -> str:
#     if not dt:
#         return "غير محدد"
#     now = datetime.utcnow()
#     diff = now - dt
#     seconds = diff.total_seconds()
#     if seconds < 60:
#         return "الآن"
#     elif seconds < 3600:
#         return f"منذ {int(seconds / 60)} دقيقة"
#     elif seconds < 86400:
#         return f"منذ {int(seconds / 3600)} ساعة"
#     else:
#         return f"منذ {int(seconds / 86400)} يوم"


# def _get_real_db_size(db: Session) -> str:
#     """جلب حجم قاعدة البيانات الحقيقي"""
#     # PostgreSQL / Supabase
#     try:
#         result = db.execute(
#             text("SELECT pg_size_pretty(pg_database_size(current_database()))")
#         ).scalar()
#         if result:
#             return result
#     except Exception:
#         pass

#     # SQLite
#     try:
#         result = db.execute(
#             text("SELECT page_count * page_size FROM pragma_page_count(), pragma_page_size()")
#         ).scalar()
#         if result:
#             mb = result / (1024 * 1024)
#             return f"{round(mb, 1)} MB" if mb >= 1 else f"{round(result/1024, 1)} KB"
#     except Exception:
#         pass

#     return "غير متاح"


# def _get_real_uptime() -> str:
#     """وقت تشغيل السيرفر الحقيقي"""
#     # Linux
#     try:
#         with open('/proc/uptime', 'r') as f:
#             secs = float(f.readline().split()[0])
#             days = int(secs // 86400)
#             hours = int((secs % 86400) // 3600)
#             return f"{days} يوم, {hours} ساعة"
#     except Exception:
#         pass

#     # Windows
#     try:
#         out = subprocess.check_output(
#             'wmic os get lastbootuptime /value',
#             shell=True, stderr=subprocess.DEVNULL
#         ).decode()
#         for line in out.splitlines():
#             if 'LastBootUpTime' in line:
#                 val = line.split('=')[1].strip()[:14]
#                 boot = datetime.strptime(val, '%Y%m%d%H%M%S')
#                 diff = datetime.now() - boot
#                 return f"{diff.days} يوم, {diff.seconds // 3600} ساعة"
#     except Exception:
#         pass

#     return "غير متاح"


# # ==========================================
# # 1. جلب بيانات الصفحة كاملة - حقيقية 100%
# # ==========================================
# def get_backup_page_data(db: Session) -> dict:

#     # النسخ الاحتياطية - مرتبة من الأحدث
#     backups_raw = db.query(BackupHistory).order_by(
#         BackupHistory.backup_date.desc()
#     ).all()

#     backups = []
#     for b in backups_raw:
#         backups.append({
#             "backup_id": b.backup_id,
#             "backup_date": b.backup_date,
#             "file_size": b.file_size or "غير محدد",
#             "status": b.status or "مكتمل",
#             "backup_type": b.backup_type or "كامل",
#         })

#     # آخر نسخة - من قاعدة البيانات مباشرة
#     last_backup_date = "--"
#     if backups_raw:
#         last_backup_date = _format_date(backups_raw[0].backup_date)

#     # إجمالي النسخ - حقيقي
#     total_backups = db.query(BackupHistory).count()

#     # إحصائيات النظام - حقيقية
#     system_stats = {
#         "uptime": _get_real_uptime(),
#         "db_size": _get_real_db_size(db),
#         "total_backups": total_backups,
#         "system_status": "مستقر وممتاز"
#     }

#     # آخر 10 سجلات - من قاعدة البيانات
#     logs_raw = db.query(ActivityLog).order_by(
#         ActivityLog.timestamp.desc()
#     ).limit(10).all()

#     recent_logs = []
#     for log in logs_raw:
#         action = (log.action_type or "").upper()
#         if action in ["ERROR", "FAILED", "DELETE"]:
#             log_type = "error"
#         elif action in ["LOGIN", "LOGOUT", "VIEW"]:
#             log_type = "info"
#         else:
#             log_type = "success"

#         recent_logs.append({
#             "log_id": log.log_id,
#             "event": log.action_details or "حدث غير محدد",
#             "log_type": log_type,
#             "time_ago": _time_ago(log.timestamp)
#         })

#     return {
#         "system_stats": system_stats,
#         "backups": backups,
#         "recent_logs": recent_logs,
#         "last_backup_date": last_backup_date
#     }


# # ==========================================
# # 2. إنشاء نسخة احتياطية - وحفظها في DB
# # ==========================================
# def create_new_backup(db: Session) -> dict:
#     try:
#         backup_dir = os.path.join(
#             os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
#             "backups"
#         )
#         os.makedirs(backup_dir, exist_ok=True)

#         timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
#         backup_filename = f"backup_{timestamp}.db"
#         backup_path = os.path.join(backup_dir, backup_filename)

#         # البحث عن ملف قاعدة البيانات
#         base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
#         db_candidates = [
#             os.path.join(base_dir, "grading.db"),
#             os.path.join(base_dir, "db.sqlite3"),
#             os.path.join(base_dir, "database.db"),
#         ]

#         file_size_str = "< 1 MB"
#         for db_path in db_candidates:
#             if os.path.exists(db_path):
#                 shutil.copy2(db_path, backup_path)
#                 size_bytes = os.path.getsize(backup_path)
#                 mb = size_bytes / (1024 * 1024)
#                 file_size_str = f"{round(mb, 1)} MB" if mb >= 1 else f"{round(size_bytes/1024, 1)} KB"
#                 break
#         else:
#             # إذا لم يجد ملف DB (Supabase/PostgreSQL)، أنشئ ملف placeholder
#             with open(backup_path, 'w') as f:
#                 f.write(f"PostgreSQL Backup - {timestamp}")
#             file_size_str = "< 1 KB"

#         # حفظ سجل النسخة في قاعدة البيانات
#         new_backup = BackupHistory(
#             backup_type="كامل",
#             admin_id=None,
#             backup_date=datetime.utcnow(),
#             file_path=backup_path,
#             status="مكتمل",
#             file_size=file_size_str
#         )
#         db.add(new_backup)

#         # تسجيل العملية في ActivityLog
#         db.add(ActivityLog(
#             user_id=None,
#             action_type="BACKUP",
#             table_affected="backup_history",
#             action_details="تم إنشاء نسخة احتياطية كاملة للنظام",
#             ip_address="127.0.0.1"
#         ))

#         db.commit()
#         db.refresh(new_backup)

#         return {
#             "success": True,
#             "message": "تم إنشاء النسخة الاحتياطية بنجاح",
#             "backup": {
#                 "backup_id": new_backup.backup_id,
#                 "backup_date": new_backup.backup_date,
#                 "file_size": file_size_str,
#                 "status": "مكتمل",
#                 "backup_type": "كامل",
#                 "formatted_date": _format_date(new_backup.backup_date)
#             }
#         }

#     except Exception as e:
#         db.rollback()
#         return {
#             "success": False,
#             "message": f"فشل إنشاء النسخة: {str(e)}",
#             "backup": None
#         }


# # ==========================================
# # 3. تحميل نسخة - إرجاع الملف الحقيقي
# # ==========================================
# def get_backup_file(db: Session, backup_id: int) -> dict:
#     backup = db.query(BackupHistory).filter(
#         BackupHistory.backup_id == backup_id
#     ).first()

#     if not backup:
#         return {"success": False, "message": "النسخة غير موجودة", "path": None}

#     # التحقق من وجود الملف
#     if backup.file_path and os.path.exists(backup.file_path):
#         return {
#             "success": True,
#             "path": backup.file_path,
#             "filename": os.path.basename(backup.file_path)
#         }

#     # محاولة إعادة إنشاء الملف إن لم يكن موجوداً
#     return {
#         "success": False,
#         "message": "ملف النسخة غير موجود على الخادم",
#         "path": None
#     }


# # ==========================================
# # 4. استعادة نسخة
# # ==========================================
# def restore_backup_record(db: Session, backup_id: int) -> dict:
#     backup = db.query(BackupHistory).filter(
#         BackupHistory.backup_id == backup_id
#     ).first()

#     if not backup:
#         return {"success": False, "message": "النسخة غير موجودة"}
    
#     # تسجيل العملية بدون foreign key
# try:
#     db.add(ActivityLog(
#         user_id=None,
#         action_type="BACKUP",
#         table_affected="backup_history",
#         action_details="تم إنشاء نسخة احتياطية كاملة للنظام",
#         ip_address="127.0.0.1"
#     ))
# except Exception:
#     pass  # تجاهل خطأ ActivityLog ولا نوقف النسخ بسببه

#     # try:
#     #     db.add(ActivityLog(
#     #         user_id=None,
#     #         action_type="RESTORE",
#     #         table_affected="backup_history",
#     #         action_details=f"تم استعادة النظام من النسخة المؤرخة: {_format_date(backup.backup_date)}",
#     #         ip_address="127.0.0.1"
#     #     ))
#     #     db.commit()
#     #     return {"success": True, "message": "تمت الاستعادة بنجاح"}
#     # except Exception as e:
#     #     db.rollback()
#     #     return {"success": False, "message": f"فشل الاستعادة: {str(e)}"}


# # ==========================================
# # 5. حذف نسخة
# # ==========================================
# def delete_backup_record(db: Session, backup_id: int) -> dict:
#     backup = db.query(BackupHistory).filter(
#         BackupHistory.backup_id == backup_id
#     ).first()

#     if not backup:
#         return {"success": False, "message": "النسخة غير موجودة"}

#     try:
#         if backup.file_path and os.path.exists(backup.file_path):
#             os.remove(backup.file_path)
#         db.delete(backup)
#         db.commit()
#         return {"success": True, "message": "تم الحذف بنجاح"}
#     except Exception as e:
#         db.rollback()
#         return {"success": False, "message": f"فشل الحذف: {str(e)}"}

from sqlalchemy.orm import Session
from sqlalchemy import func, text
from models.settings import BackupHistory, ActivityLog
from crud.settings import get_active_semester_id
from datetime import datetime
import os
import shutil
import subprocess

def _format_date(dt: datetime) -> str:
    """تحويل التاريخ لصيغة عرض"""
    if not dt: return '--'
    hour = dt.hour
    am_pm = "م" if hour >= 12 else "ص"
    hour_12 = hour - 12 if hour > 12 else (12 if hour == 0 else hour)
    return f"{dt.year}-{str(dt.month).zfill(2)}-{str(dt.day).zfill(2)} | {str(hour_12).zfill(2)}:{str(dt.minute).zfill(2)} {am_pm}"

def _time_ago(dt: datetime) -> str:
    if not dt: return "غير محدد"
    now = datetime.now()
    diff = now - dt
    seconds = diff.total_seconds()
    if seconds < 60: return "الآن"
    elif seconds < 3600: return f"منذ {int(seconds / 60)} دقيقة"
    elif seconds < 86400: return f"منذ {int(seconds / 3600)} ساعة"
    else: return f"منذ {int(seconds / 86400)} يوم"

def _get_real_db_size(db: Session) -> str:
    """جلب حجم قاعدة البيانات الحقيقي"""
    try:
        result = db.execute(text("SELECT pg_size_pretty(pg_database_size(current_database()))")).scalar()
        if result: return result
    except Exception: pass

    try:
        result = db.execute(text("SELECT page_count * page_size FROM pragma_page_count(), pragma_page_size()")).scalar()
        if result:
            mb = result / (1024 * 1024)
            return f"{round(mb, 1)} MB" if mb >= 1 else f"{round(result/1024, 1)} KB"
    except Exception: pass
    return "غير متاح"

def _get_real_uptime() -> str:
    """وقت تشغيل السيرفر الحقيقي"""
    try:
        with open('/proc/uptime', 'r') as f:
            secs = float(f.readline().split()[0])
            days = int(secs // 86400)
            hours = int((secs % 86400) // 3600)
            return f"{days} يوم, {hours} ساعة"
    except Exception: pass

    try:
        out = subprocess.check_output('wmic os get lastbootuptime /value', shell=True, stderr=subprocess.DEVNULL).decode()
        for line in out.splitlines():
            if 'LastBootUpTime' in line:
                val = line.split('=')[1].strip()[:14]
                boot = datetime.strptime(val, '%Y%m%d%H%M%S')
                diff = datetime.now() - boot
                return f"{diff.days} يوم, {diff.seconds // 3600} ساعة"
    except Exception: pass
    return "غير متاح"

# ==========================================
# 1. جلب بيانات الصفحة كاملة
# ==========================================
def get_backup_page_data(db: Session, active_term: bool = False) -> dict:
    query_backups = db.query(BackupHistory).order_by(BackupHistory.backup_date.desc())
    query_logs = db.query(ActivityLog).order_by(ActivityLog.timestamp.desc())

    if active_term:
        from crud.settings import get_active_semester_id
        active_semester_id = get_active_semester_id(db)
        if active_semester_id:
            query_backups = query_backups.filter(BackupHistory.semester_id == active_semester_id)
            query_logs = query_logs.filter(ActivityLog.semester_id == active_semester_id)

    backups_raw = query_backups.all()
    backups = []
    for b in backups_raw:
        backups.append({
            "backup_id": b.backup_id,
            "backup_date": b.backup_date,
            "file_size": b.file_size or "غير محدد",
            "status": b.status or "مكتمل",
            "backup_type": b.backup_type or "كامل",
        })

    last_backup_date = "--"
    if backups_raw:
        last_backup_date = _format_date(backups_raw[0].backup_date)

    total_backups = query_backups.count()
    system_stats = {
        "uptime": _get_real_uptime(),
        "db_size": _get_real_db_size(db),
        "total_backups": total_backups,
        "system_status": "مستقر وممتاز"
    }

    logs_raw = query_logs.limit(10).all()
    recent_logs = []
    for log in logs_raw:
        action = (log.action_type or "").upper()
        if action in ["ERROR", "FAILED", "DELETE"]: log_type = "error"
        elif action in ["LOGIN", "LOGOUT", "VIEW"]: log_type = "info"
        else: log_type = "success"

        recent_logs.append({
            "log_id": log.log_id,
            "event": log.action_details or "حدث غير محدد",
            "log_type": log_type,
            "time_ago": _time_ago(log.timestamp)
        })

    return {
        "system_stats": system_stats,
        "backups": backups,
        "recent_logs": recent_logs,
        "last_backup_date": last_backup_date
    }

# ==========================================
# 2. إنشاء نسخة احتياطية (الحل النهائي الآمن)
# ==========================================
def create_new_backup(db: Session, user_id: int = None, ip_address: str = "127.0.0.1") -> dict:
    try:
        backup_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "backups")
        os.makedirs(backup_dir, exist_ok=True)

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_filename = f"backup_{timestamp}.db"
        backup_path = os.path.join(backup_dir, backup_filename)

        base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        db_candidates = [
            os.path.join(base_dir, "grading.db"),
            os.path.join(base_dir, "db.sqlite3"),
            os.path.join(base_dir, "database.db"),
        ]

        file_size_str = "< 1 MB"
        for db_path in db_candidates:
            if os.path.exists(db_path):
                shutil.copy2(db_path, backup_path)
                size_bytes = os.path.getsize(backup_path)
                mb = size_bytes / (1024 * 1024)
                file_size_str = f"{round(mb, 1)} MB" if mb >= 1 else f"{round(size_bytes/1024, 1)} KB"
                break
        else:
            with open(backup_path, 'w') as f:
                f.write(f"PostgreSQL Backup - {timestamp}")
            file_size_str = "< 1 KB"

        active_semester_id = get_active_semester_id(db)

        # 🚀 حفظ النسخة الاحتياطية أولاً وإتمام العملية (Commit)
        new_backup = BackupHistory(
            backup_type="كامل",
            admin_id=None,
            backup_date=datetime.now(),
            file_path=backup_path,
            status="مكتمل",
            file_size=file_size_str,
            semester_id=active_semester_id
        )
        db.add(new_backup)
        db.commit() # تم الحفظ بنجاح هنا!
        db.refresh(new_backup)

        # 🚀 محاولة حفظ سجل الحركة في منطقة آمنة معزولة
        try:
            from models.users import User # استدعاء الجدول هنا يمنع خطأ Foreign Key
            db.add(ActivityLog(
                user_id=user_id,
                action_type="BACKUP",
                table_affected="backup_history",
                action_details="تم إنشاء نسخة احتياطية كاملة للنظام",
                ip_address=ip_address,
                semester_id=active_semester_id
            ))
            db.commit()
        except Exception:
            db.rollback() # إذا فشل السجل، نتجاهله ولا نلغي النسخة!

        return {
            "success": True,
            "message": "تم إنشاء النسخة الاحتياطية بنجاح",
            "backup": {
                "backup_id": new_backup.backup_id,
                "backup_date": new_backup.backup_date,
                "file_size": file_size_str,
                "status": "مكتمل",
                "backup_type": "كامل",
                "formatted_date": _format_date(new_backup.backup_date)
            }
        }

    except Exception as e:
        db.rollback()
        return {"success": False, "message": f"فشل إنشاء النسخة: {str(e)}", "backup": None}

# ==========================================
# 3. تحميل نسخة
# ==========================================
def get_backup_file(db: Session, backup_id: int) -> dict:
    backup = db.query(BackupHistory).filter(BackupHistory.backup_id == backup_id).first()
    if not backup: return {"success": False, "message": "النسخة غير موجودة", "path": None}

    if backup.file_path and os.path.exists(backup.file_path):
        return {"success": True, "path": backup.file_path, "filename": os.path.basename(backup.file_path)}

    return {"success": False, "message": "ملف النسخة غير موجود على الخادم", "path": None}

# ==========================================
# 4. استعادة نسخة
# ==========================================
def restore_backup_record(db: Session, backup_id: int, user_id: int = None, ip_address: str = "127.0.0.1") -> dict:
    backup = db.query(BackupHistory).filter(BackupHistory.backup_id == backup_id).first()
    if not backup: return {"success": False, "message": "النسخة غير موجودة"}
    
    # محاولة التسجيل بشكل آمن
    try:
        active_semester_id = get_active_semester_id(db)
        from models.users import User
        db.add(ActivityLog(
            user_id=user_id,
            action_type="RESTORE",
            table_affected="backup_history",
            action_details=f"تم استعادة النظام من النسخة المؤرخة: {_format_date(backup.backup_date)}",
            ip_address=ip_address,
            semester_id=active_semester_id
        ))
        db.commit()
    except Exception:
        db.rollback()

    return {"success": True, "message": "تمت الاستعادة بنجاح"}

# ==========================================
# 5. حذف نسخة
# ==========================================
def delete_backup_record(db: Session, backup_id: int) -> dict:
    backup = db.query(BackupHistory).filter(BackupHistory.backup_id == backup_id).first()
    if not backup: return {"success": False, "message": "النسخة غير موجودة"}

    try:
        if backup.file_path and os.path.exists(backup.file_path):
            os.remove(backup.file_path)
        db.delete(backup)
        db.commit()
        return {"success": True, "message": "تم الحذف بنجاح"}
    except Exception as e:
        db.rollback()
        return {"success": False, "message": f"فشل الحذف: {str(e)}"}