import random
from datetime import datetime, timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi_mail import MessageSchema, FastMail, ConnectionConfig
from pydantic import BaseModel
from sqlalchemy.orm import Session
import httpx
import httpcore

# استيرادات الكود الثاني
from db.database import supabase
from db.database import get_db
from schemas.users import UserCreate, Token
from models.users import User
from models.settings import ActivityLog

from core.security import create_access_token, verify_password, get_password_hash # 👈 الاستيراد الجديد من الملف الذي أنشأناه


# ملاحظة: سنحتاج لاحقاً لإضافة مكتبة التشفير Passlib هنا

import os
from dotenv import load_dotenv

load_dotenv()

conf = ConnectionConfig(
    MAIL_USERNAME=os.environ.get("OTP_EMAIL", ""),
    MAIL_PASSWORD=os.environ.get("OTP_PASSWORD", ""), 
    MAIL_FROM=os.environ.get("OTP_EMAIL", ""),
    MAIL_PORT=587,               # 👈 غيرنا البورت هنا
    MAIL_SERVER="smtp.gmail.com",
    MAIL_STARTTLS=True,          # 👈 جعلناها True
    MAIL_SSL_TLS=False,          # 👈 جعلناها False
    USE_CREDENTIALS=True
)

# تم دمج العلامات (tags) من الملفين
router = APIRouter(prefix="/auth", tags=["Auth", "Auth (المصادقة)"])

# الـ Schemas
class LoginRequest(BaseModel):
    email: str
    password: str

class OtpRequest(BaseModel):
    email: str

class VerifyOtpRequest(BaseModel):
    email: str
    otp_code: str

class SetPasswordRequest(BaseModel):
    email: str
    otp_code: str
    new_password: str


# ==========================================
# مسارات تسجيل الدخول المدمجة
# ==========================================




@router.post("/login")
def login(request: LoginRequest, db: Session = Depends(get_db)):
    # 1. التحقق من الإيميل وكلمة المرور
    user_query = supabase.table("users") \
        .select("user_id", "email", "password", "language_code") \
        .eq("email", request.email) \
        .maybe_single() \
        .execute()
        
    user_data = (user_query.data if user_query else None)
    
    if not user_data:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, 
            detail="error_invalid_credentials"
        )
        
    user_id = user_data["user_id"]
    db_password = user_data.get("password")
    
    # Check password match (supports both hashed and plaintext for backward compatibility)
    is_valid = False
    if db_password:
        if verify_password(request.password.strip(), db_password):
            is_valid = True
        elif request.password == db_password:
            is_valid = True
            
    if not is_valid:
        # تسجيل فشل الدخول
        db.add(ActivityLog(user_id=user_id, action_type="LOGIN_FAILED", action_details=f"محاولة تسجيل دخول فاشلة للإيميل: {request.email}"))
        db.commit()
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, 
            detail="error_invalid_credentials"
        )
    
    # 2. التحقق من الصلاحية (Role)
    role_query = supabase.table("user_roles").select("role_id").eq("user_id", user_id).maybe_single().execute()
    role_data = (role_query.data if role_query else None)
    
    if not role_data:
        db.add(ActivityLog(user_id=user_id, action_type="LOGIN_FAILED", action_details=f"لا توجد صلاحية للمستخدم: {request.email}"))
        db.commit()
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, 
            detail="error_no_role"
        )

    # 3. ⭐️ السحر هنا: إنشاء التوكن الحقيقي المشفر ⭐️
    access_token = create_access_token(data={"sub": str(user_id)})
    
    # تسجيل نجاح الدخول
    db.add(ActivityLog(user_id=user_id, action_type="LOGIN_SUCCESS", action_details=f"تسجيل دخول ناجح"))
    db.commit()

    # 4. إرجاع الرد النهائي الذي ينتظره فلاتر
    return {
        "status": "success", 
        "user_id": user_id, 
        "role_id": int(role_data["role_id"]),
        "access_token": access_token, # 👈 إرسال التوكن لكي تحفظيه في SharedPreferences
        "token_type": "bearer",
        "language_code": user_data.get("language_code", "ar")
    }

# ==========================================
# مسارات رموز التحقق (OTP)
# ==========================================

@router.post("/send-new-user-otp")
async def send_new_user_otp(request: OtpRequest):
    # 1. البحث عن المستخدم
    user_query = supabase.table("users").select("user_id", "email", "password").eq("email", request.email).maybe_single().execute()
    user = (user_query.data if user_query else None)
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="error_email_not_found"
        )

    if user.get("password") is not None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, 
            detail="error_email_already_registered"
        )
    
    user_id = user["user_id"]
    otp_code = str(random.randint(100000, 999999))
    expiry_time = datetime.now() + timedelta(minutes=10)
    
    # 2. حفظ الرمز
    try:
        supabase.table("verification_codes").upsert({
            "user_id": user_id,
            "email": request.email,
            "otp_code": otp_code,
            "expiry_time": expiry_time.isoformat(),
            "is_used": False
        }).execute()
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="حدث خطأ أثناء حفظ بيانات التحقق."
        )

    # 3. إرسال الإيميل عبر SendGrid API
    sendgrid_key = os.environ.get("SENDGRID_API_KEY")
    sender_email = os.environ.get("OTP_EMAIL")
    
    payload = {
        "personalizations": [{"to": [{"email": request.email}]}],
        "from": {"email": sender_email, "name": "Intelligent Grading System"},
        "subject": "رمز التحقق",
        "content": [{"type": "text/plain", "value": f"رمز التحقق الخاص بك هو: {otp_code}"}]
    }
    
    headers = {
        "Authorization": f"Bearer {sendgrid_key}",
        "Content-Type": "application/json"
    }
    
    try:
        async with httpx.AsyncClient() as client:
            print("--- جاري إرسال إيميل المستخدم الجديد عبر SendGrid API ---")
            response = await client.post("https://api.sendgrid.com/v3/mail/send", json=payload, headers=headers)
            
            if response.status_code not in (200, 202):
                print(f"🔴 خطأ من SendGrid: {response.text}")
                raise Exception("فشل إرسال البريد من السيرفر المزود")
                
            print("--- تم الإرسال بنجاح! ---")
            
    except Exception as e:
        print("\n🔴 ERROR IN SENDGRID:", repr(e), "\n") 
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="خطأ في إرسال البريد الإلكتروني السحابي."
        )
        
    return {"status": "success", "message": "تم إرسال الرمز بنجاح"}
# 👇 الدالة الخاصة بنسيت كلمة المرور 👇

@router.post("/send-forgot-password-otp")
async def send_forgot_password_otp(request: OtpRequest):
    # 1. البحث عن المستخدم
    user_query = supabase.table("users").select("user_id", "email", "password").eq("email", request.email).maybe_single().execute()
    user = (user_query.data if user_query else None)
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="error_email_not_found"
        )

    if user.get("password") is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, 
            detail="error_account_not_activated"
        )
    
    user_id = user["user_id"]
    otp_code = str(random.randint(100000, 999999))
    expiry_time = datetime.now() + timedelta(minutes=10)
    
    # 2. حفظ الرمز
    try:
        supabase.table("verification_codes").upsert({
            "user_id": user_id,
            "email": request.email,
            "otp_code": otp_code,
            "expiry_time": expiry_time.isoformat(),
            "is_used": False
        }).execute()
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="حدث خطأ أثناء حفظ بيانات التحقق."
        )

    # 3. إرسال الإيميل عبر SendGrid API
    sendgrid_key = os.environ.get("SENDGRID_API_KEY")
    sender_email = os.environ.get("OTP_EMAIL")
    
    payload = {
        "personalizations": [{"to": [{"email": request.email}]}],
        "from": {"email": sender_email, "name": "Intelligent Grading System"},
        "subject": "استعادة كلمة المرور",
        "content": [{"type": "text/plain", "value": f"رمز التحقق الخاص باستعادة كلمة المرور هو: {otp_code}"}]
    }
    
    headers = {
        "Authorization": f"Bearer {sendgrid_key}",
        "Content-Type": "application/json"
    }
    
    try:
        async with httpx.AsyncClient() as client:
            print("--- جاري إرسال إيميل الاستعادة عبر SendGrid API ---")
            response = await client.post("https://api.sendgrid.com/v3/mail/send", json=payload, headers=headers)
            
            if response.status_code not in (200, 202):
                print(f"🔴 خطأ من SendGrid: {response.text}")
                raise Exception("فشل إرسال البريد من السيرفر المزود")
                
            print("--- تم الإرسال بنجاح! ---")
            
    except Exception as e:
        print("\n🔴 ERROR IN SENDGRID:", repr(e), "\n") 
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="خطأ في إرسال البريد الإلكتروني السحابي."
        )
        
    return {"status": "success", "message": "تم إرسال رمز الاستعادة بنجاح"}

@router.post("/verify-otp")
def verify_otp(request: VerifyOtpRequest):
    try:
        otp_query = supabase.table("verification_codes") \
            .select("*") \
            .eq("email", request.email) \
            .eq("otp_code", request.otp_code) \
            .eq("is_used", False) \
            .maybe_single() \
            .execute()
    except (httpx.ConnectError, httpcore.ConnectError):
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="error_connection_failed"
        )

    if not (otp_query.data if otp_query else None):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="error_invalid_otp"
        )

    expiry_time = datetime.fromisoformat((otp_query.data if otp_query else None)["expiry_time"].replace("Z", ""))
    if expiry_time < datetime.now():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="error_expired_otp"
        )

    return {"status": "success", "message": "الرمز صحيح"}


@router.post("/verify-and-set-password")
def verify_and_set_password(request: SetPasswordRequest):
    # 1. التأكد من صلاحية الرمز
    try:
        otp_query = supabase.table("verification_codes") \
            .select("*") \
            .eq("email", request.email) \
            .eq("otp_code", request.otp_code) \
            .eq("is_used", False) \
            .maybe_single() \
            .execute()
    except (httpx.ConnectError, httpcore.ConnectError):
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="error_connection_failed"
        )

    if not (otp_query.data if otp_query else None):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="error_invalid_otp"
        )

    expiry_time = datetime.fromisoformat((otp_query.data if otp_query else None)["expiry_time"].replace("Z", ""))
    if expiry_time < datetime.now():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="error_expired_otp"
        )

    # 2. تحديث كلمة المرور 
    hashed_password = get_password_hash(request.new_password.strip())
    update_user = supabase.table("users") \
        .update({"password": hashed_password}) \
        .eq("email", request.email) \
        .execute()

    if not (update_user.data if update_user else None):
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="error_update_password_failed"
        )

    # 3. إغلاق الرمز
    supabase.table("verification_codes") \
        .update({"is_used": True}) \
        .eq("email", request.email) \
        .execute()

    # 👇 التعديل هنا: جلب بيانات المستخدم والصلاحية بعد تفعيل الحساب 👇
    user_id = (otp_query.data if otp_query else None)["user_id"]
    role_query = supabase.table("user_roles").select("role_id").eq("user_id", user_id).maybe_single().execute()
    role_data = (role_query.data if role_query else None)
    
    role_id = int(role_data["role_id"]) if role_data and role_data.get("role_id") is not None else None

    return {
        "status": "success", 
        "message": "تم تفعيل حسابك بنجاح!",
        "user_id": user_id,
        "role_id": role_id
    }