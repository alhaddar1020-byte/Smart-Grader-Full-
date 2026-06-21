from fastapi import Depends
from core.security import get_current_user_id
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db.database import get_db
from crud import users_crud 
from schemas.users import UserCreate, AdminProfileUpdate

# قمنا بتعريف راوترين منفصلين لضمان عدم التداخل في العناوين (Prefixes)
user_router = APIRouter(prefix="/users", tags=["Users (إدارة المستخدمين)"])
admin_router = APIRouter(prefix="/admin", tags=["Admin Profile (الملف الشخصي للمدير)"], dependencies=[Depends(get_current_user_id)])

# ==========================================
# 1. مسارات المستخدمين العامة (Registration)
# ==========================================

@user_router.post("/register")
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    """مسار تسجيل حساب جديد للطلاب والمدرسين"""
    # التأكد إذا الإيميل مسجل من قبل
    db_user = users_crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="الإيميل مسجل مسبقاً!")
    
    # إنشاء المستخدم عبر استدعاء دالة الـ CRUD
    new_user = users_crud.create_user(db, user_data=user)
    
    return {"message": "تم تسجيل الحساب بنجاح!", "user_id": new_user.user_id}


# ==========================================
# 2. مسارات إدارة الملف الشخصي (Admin)
# ==========================================

@admin_router.get("/profile")
def get_profile(db: Session = Depends(get_db)):
    """مسار جلب بيانات المدير الحقيقية"""
    admin = users_crud.get_admin_profile(db)
    if not admin:
        raise HTTPException(status_code=404, detail="المدير غير موجود")
    
    return {
        "full_name": admin.full_name,
        "email": admin.email,
        "phone_number": admin.phone_number,
        "department_name": "الإدارة العليا" # يتم تحديدها برمجياً للمدير
    }

@admin_router.put("/profile")
def update_profile(profile_data: AdminProfileUpdate, db: Session = Depends(get_db)):
    """مسار تحديث بيانات المدير وحفظها في الداتا بيس"""
    updated_admin = users_crud.update_admin_profile(db, profile_data)
    if not updated_admin:
        raise HTTPException(status_code=404, detail="فشل تحديث البيانات، المستخدم غير موجود")
    
    return {"message": "تم تحديث البيانات بنجاح"}