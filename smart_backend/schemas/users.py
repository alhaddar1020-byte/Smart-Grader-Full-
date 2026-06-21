# from pydantic import BaseModel, EmailStr, ConfigDict
# from typing import Optional
# from datetime import datetime

# # ==========================================
# # Schemas for Roles
# # ==========================================
# class RoleBase(BaseModel):
#     role_name: str

# class RoleResponse(RoleBase):
#     role_id: int
#     model_config = ConfigDict(from_attributes=True) # هذا السطر السحري يخلي Pydantic يفهم بيانات الداتا بيس

# # ==========================================
# # Schemas for Users
# # ==========================================
# class UserBase(BaseModel):
#     full_name: str
#     email: EmailStr # حارس أمن يتأكد إن النص هو إيميل حقيقي
#     phone_number: Optional[str] = None
#     is_active: bool = True

# class UserCreate(UserBase):
#     password: str # الباسورد مطلوب فقط وقت الإنشاء

# class UserResponse(UserBase):
#     user_id: int
#     last_password_change: datetime
#     # لاحظي: ما حطينا الباسورد هنا عشان ما يرجع لتطبيق الفلاتر وينسرق!
#     model_config = ConfigDict(from_attributes=True)

# # ==========================================
# # Schema for Login / Token
# # ==========================================
# class Token(BaseModel):
#     access_token: str
#     token_type: str

from pydantic import BaseModel, EmailStr, ConfigDict
from typing import Optional
from datetime import datetime

# ==========================================
# 1. مخططات الصلاحيات (Roles)
# ==========================================
class RoleBase(BaseModel):
    role_name: str

class RoleResponse(RoleBase):
    role_id: int
    # هذا السطر السحري يخلي Pydantic يفهم بيانات الداتا بيس
    model_config = ConfigDict(from_attributes=True)

# ==========================================
# 2. مخططات المستخدمين الأساسية (Users)
# ==========================================
class UserBase(BaseModel):
    full_name: str
    email: EmailStr  # حارس أمن يتأكد إن النص هو إيميل حقيقي
    phone_number: Optional[str] = None
    is_active: bool = True

class UserCreate(UserBase):
    password: str  # الباسورد مطلوب فقط وقت الإنشاء

class UserResponse(UserBase):
    user_id: int
    last_password_change: Optional[datetime] = None
    # لاحظي: ما حطينا الباسورد هنا عشان ما يرجع لتطبيق الفلاتر وينسرق!
    model_config = ConfigDict(from_attributes=True)

# ==========================================
# 3. مخططات الملف الشخصي والتحديث (Profile)
# ==========================================
# هذا المخطط مخصص لعملية التحديث من شاشة الإعدادات
class AdminProfileUpdate(BaseModel):
    full_name: str
    email: EmailStr
    phone_number: Optional[str] = None

# مخطط استرجاع بيانات الملف الشخصي (تم دمج المخططات المكررة هنا)
class UserProfileResponse(BaseModel):
    user_id: int
    full_name: str
    email: EmailStr
    phone_number: Optional[str] = None
    department_name: Optional[str] = "الإدارة العليا" # مضاف للتوافق مع واجهة فلاتر
    
    model_config = ConfigDict(from_attributes=True)

# ==========================================
# 4. مخططات الأمان والمصادقة (Auth)
# ==========================================
class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None