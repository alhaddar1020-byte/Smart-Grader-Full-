# ==========================================
# ملف: settings.py
# وظيفته: تتبع الحركات في النظام، الإعدادات العامة، وعمليات الاستيراد والنسخ الاحتياطي.
# الجداول:
# - SystemSetting: إعدادات الكلية والشعارات للطباعة.
# - ActivityLog: سجل مراقبة تحركات المستخدمين.
# - BackupHistory: سجل النسخ الاحتياطي لقاعدة البيانات.
# - ImportHistory: سجل عمليات استيراد الطلاب/المعلمين من ملفات Excel.
# ==========================================
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from datetime import datetime
from .base import Base

class SystemSetting(Base):
    __tablename__ = "system_settings"
    setting_id = Column(Integer, primary_key=True, default=1)
    university_name = Column(String(150), nullable=False)
    college_name = Column(String(150), nullable=False)
    right_logo_path = Column(String(500), nullable=True)
    left_logo_path = Column(String(500), nullable=True)

class ActivityLog(Base):
    __tablename__ = "activity_log"
    log_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.user_id", ondelete="SET NULL"), nullable=True)
    action_type = Column(String(50), nullable=False)
    table_affected = Column(String(50), nullable=True)
    action_details = Column(String, nullable=False)
    ip_address = Column(String(45), nullable=True)
    timestamp = Column(DateTime, default=datetime.utcnow, index=True) # فهرس الوقت
    semester_id = Column(Integer, ForeignKey("semesters.semester_id", ondelete="SET NULL"), nullable=True)

class BackupHistory(Base):
    __tablename__ = "backup_history"
    backup_id = Column(Integer, primary_key=True, index=True)
    backup_type = Column(String(50), nullable=True)
    admin_id = Column(Integer, ForeignKey("admin.admin_id", ondelete="SET NULL"), nullable=True)
    backup_date = Column(DateTime, default=datetime.utcnow)
    file_path = Column(String(500), nullable=False)
    status = Column(String(50), nullable=True)
    file_size = Column(String(50), nullable=True)
    semester_id = Column(Integer, ForeignKey("semesters.semester_id", ondelete="SET NULL"), nullable=True)

class ImportHistory(Base):
    __tablename__ = "import_history"
    import_id = Column(Integer, primary_key=True, index=True)
    admin_id = Column(Integer, ForeignKey("admin.admin_id"), nullable=True)
    file_name = Column(String(255), nullable=False)
    import_date = Column(DateTime, default=datetime.utcnow)
    record_count = Column(Integer, nullable=False)
    import_type = Column(String(50), nullable=False)
    semester_id = Column(Integer, ForeignKey("semesters.semester_id", ondelete="SET NULL"), nullable=True)