# مسار الملف: schemas/settings.py

from pydantic import BaseModel, EmailStr, ConfigDict
from typing import Optional
from datetime import datetime

# ══════════════════════════════════════════════════════════════════════════════
# إعدادات المستخدم والملف الشخصي والأمان (User Profile & Security Schemas)
# ══════════════════════════════════════════════════════════════════════════════

class ForgotPasswordSendOtp(BaseModel):
    user_id: int

class ForgotPasswordVerifyOtp(BaseModel):
    user_id: int
    otp_code: str

class ForgotPasswordReset(BaseModel):
    user_id: int
    otp_code: str
    new_password: str

class ProfileResponse(BaseModel):
    user_id: int 
    full_name: str
    email: str
    phone_number: Optional[str] = None
    level_name: Optional[str] = None
    department_name: Optional[str] = None
    last_password_change: Optional[str] = None
    language_code: Optional[str] = None  
    is_dark_mode: Optional[bool] = None  

class SendEmailOtpRequest(BaseModel):
    user_id: int
    new_email: EmailStr

class VerifyEmailOtpRequest(BaseModel):
    user_id: int  
    new_email: EmailStr
    otp_code: str

class UpdateProfileRequest(BaseModel):
    user_id: int
    full_name: str
    phone_number: Optional[str] = None
    email: Optional[EmailStr] = None

class ChangePasswordRequest(BaseModel):
    user_id: int
    old_password: str
    new_password: str
    confirm_password: str

class DisplayPreferencesSchema(BaseModel):
    user_id: int
    language_code: str
    is_dark_mode: bool


# ══════════════════════════════════════════════════════════════════════════════
# إعدادات النظام والسجلات (System Settings & Logs Schemas)
# ══════════════════════════════════════════════════════════════════════════════

# ==========================================
# Schemas for System Settings
# ==========================================
class SystemSettingBase(BaseModel):
    university_name: str
    college_name: str
    right_logo_path: Optional[str] = None
    left_logo_path: Optional[str] = None

class SystemSettingUpdate(SystemSettingBase):
    pass

class SystemSettingResponse(SystemSettingBase):
    setting_id: int
    model_config = ConfigDict(from_attributes=True)

# ==========================================
# Schemas for Activity Log (للقراءة فقط - Response)
# ==========================================
class ActivityLogResponse(BaseModel):
    log_id: int
    user_id: Optional[int]
    action_type: str
    table_affected: Optional[str]
    action_details: str
    ip_address: Optional[str]
    timestamp: datetime
    model_config = ConfigDict(from_attributes=True)

# ==========================================
# Schemas for Import History (سجل الاستيراد)
# ==========================================
class ImportHistoryResponse(BaseModel):
    import_id: int
    admin_id: Optional[int]
    file_name: str
    import_date: datetime
    record_count: int
    import_type: str
    model_config = ConfigDict(from_attributes=True)