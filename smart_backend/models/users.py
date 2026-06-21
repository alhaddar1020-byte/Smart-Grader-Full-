# ==========================================
# ملف: users.py
# وظيفته: إدارة هويات الأشخاص الذين يدخلون النظام والمصادقة.
# الجداول:
# - User: بيانات المستخدم الأساسية (الاسم، الإيميل، الرقم السري).
# - Role: أنواع الصلاحيات (آدمن، معلم، طالب).
# - VerificationCode: رموز التحقق (OTP) لاستعادة كلمة المرور.
# ==========================================

    # ==========================================
# ملف: users.py
# وظيفته: إدارة هويات الأشخاص الذين يدخلون النظام والمصادقة.
# ==========================================
from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from .base import Base

class User(Base):
    __tablename__ = "users"
    user_id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String(100), nullable=False, index=True) # فهرس لتسريع البحث بالاسم
    email = Column(String(100), unique=True, nullable=False)
    password = Column(String(255), nullable=True)
    phone_number = Column(String(20), unique=True, nullable=True)
    is_active = Column(Boolean, default=True)
    last_password_change = Column(DateTime, default=datetime.utcnow)
    language_code = Column(String(10), default="ar")
    is_dark_mode = Column(Boolean, default=False)

class Role(Base):
    __tablename__ = "roles"
    role_id = Column(Integer, primary_key=True, index=True)
    role_name = Column(String(50), nullable=False)

class VerificationCode(Base):
    __tablename__ = "verification_codes"
    code_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.user_id", ondelete="CASCADE"), nullable=False, index=True) # فهرس
    otp_code = Column(String(6), nullable=False)
    expiry_time = Column(DateTime, nullable=False)
    is_used = Column(Boolean, default=False)