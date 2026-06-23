# # # from fastapi import APIRouter, Depends, HTTPException, status
# # # from sqlalchemy.orm import Session
# # # from sqlalchemy import text
# # # from pydantic import BaseModel, EmailStr
# # # from passlib.context import CryptContext
# # # from datetime import datetime, timedelta, timezone
# # # import random
# # # import smtplib
# # # from email.mime.text import MIMEText
# # # from email.mime.multipart import MIMEMultipart

# # # # 🌟 استيراد حزمة الترجمة التلقائية السحرية بأمان
# # # from deep_translator import GoogleTranslator

# # # # ── استيرادات قاعدة البيانات والموديلات ──────────────────────────────────────────
# # # from db.database import get_db
# # # from models.users import User, VerificationCode
# # # from models.profiles import Student  

# # # from fastapi_mail import MessageSchema, FastMail, ConnectionConfig
# # # router = APIRouter(prefix="/settings", tags=["Settings"])
# # # pwd_ctx = CryptContext(schemes=["bcrypt"], deprecated="auto")
# # # # ── إعدادات بريد النظام ────────────────────────────────────────────────────────
# # # SMTP_SERVER = "smtp.sendgrid.net"
# # # SMTP_PORT = 587
# # # SMTP_USERNAME = "apikey"
# # # SENDER_EMAIL = "aryjth953@gmail.com" # 🌟 إيميلك الموثق رسمياً
# # # SENDER_PASSWORD = "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"


# # # conf = ConnectionConfig(
# # #     MAIL_USERNAME="apikey", 
# # #     MAIL_PASSWORD="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", 
# # #     MAIL_FROM="aryjth953@gmail.com", 
# # #     MAIL_FROM_NAME="Intelligent Grading System", # 🌟 ضفنا هذي عشان SendGrid يطابق الاسم 100%
# # #     MAIL_PORT=587,             
# # #     MAIL_SERVER="smtp.sendgrid.net", 
# # #     MAIL_STARTTLS=True,       
# # #     MAIL_SSL_TLS=False,         
# # #     USE_CREDENTIALS=True,
# # #     VALIDATE_CERTS=True
# # # )

# # # # ══════════════════════════════════════════════════════════════════════════════
# # # # النماذج (Schemas)
# # # # ══════════════════════════════════════════════════════════════════════════════

# # # class ForgotPasswordSendOtp(BaseModel):
# # #     user_id: int

# # # class ForgotPasswordVerifyOtp(BaseModel):
# # #     user_id: int
# # #     otp_code: str

# # # class ForgotPasswordReset(BaseModel):
# # #     user_id: int
# # #     otp_code: str
# # #     new_password: str

# # # class ProfileResponse(BaseModel):
# # #     user_id: int 
# # #     full_name: str
# # #     email: str
# # #     phone_number: str | None
# # #     level_name: str | None
# # #     department_name: str | None
# # #     last_password_change: str | None
# # #     language_code: str | None  
# # #     is_dark_mode: bool | None  
# # #     full_name_en: str | None
# # #     level_name_en: str | None
# # #     department_name_en: str | None

# # # class SendEmailOtpRequest(BaseModel):
# # #     user_id: int  

# # # class VerifyEmailOtpRequest(BaseModel):
# # #     user_id: int  
# # #     new_email: EmailStr
# # #     otp_code: str

# # # class UpdateProfileRequest(BaseModel):
# # #     user_id: int
# # #     full_name: str

# # # class ChangePasswordRequest(BaseModel):
# # #     user_id: int
# # #     old_password: str
# # #     new_password: str
# # #     confirm_password: str

# # # # ══════════════════════════════════════════════════════════════════════════════
# # # # الوظائف المساعدة الذكية
# # # # ══════════════════════════════════════════════════════════════════════════════

# # # def auto_translate_profile(profile_dict: dict, target_lang: str) -> dict:
# # #     """🌟 الدالة المطورة: تترجم المستوى والتخصص فقط عبر المكتبة وتمنع ترجمة الاسم نهائياً"""
    
# # #     # 1. تثبيت حقل الاسم الإنجليزي ليكون مطابقاً للاسم العربي الأصلي القادم من الداتابيز بدون ترجمة خاطئة
# # #     profile_dict["full_name_en"] = profile_dict.get("full_name")
    
# # #     # 2. تجهيز نسخ احتياطية للمستوى والتخصص
# # #     profile_dict["level_name_en"] = profile_dict.get("level_name")
# # #     profile_dict["department_name_en"] = profile_dict.get("department_name")

# # #     # 3. 🎯 هنا أخرجنا الاسم من القائمة، وتركنا فقط حقول النظام ليتم ترجمتها تلقائياً عبر المكتبة
# # #     fields_to_translate = ["level_name", "department_name"]
    
# # #     for key in fields_to_translate:
# # #         value = profile_dict.get(key)
# # #         if value and isinstance(value, str):
# # #             try:
# # #                 # مكتبة جوجل تترجم التخصص والمستوى حياً هنا
# # #                 profile_dict[f"{key}_en"] = GoogleTranslator(source='ar', target='en').translate(value)
# # #             except Exception as e:
# # #                 print(f"⚠️ خطأ غير مؤثر في ترجمة {key}: {e}")
                    
# # #     return profile_dict


# # # def send_security_otp(receiver_email: str, otp_code: str, purpose: str):
# # #     try:
# # #         msg = MIMEMultipart()
# # #         # 💡 التعديل هنا: وضعنا الإيميل الصافي فقط بدون نصوص عربية لتفادي حساسية SendGrid
# # #         msg['From'] = SENDER_EMAIL 
# # #         msg['To'] = receiver_email
# # #         msg['Subject'] = f"رمز أمان: {purpose}"
        
# # #         body = f"""
# # #         <div dir="rtl" style="font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 10px;">
# # #             <h2 style="color: #c0392b;">تنبيه أمني من نظام التصحيح</h2>
# # #             <p>لقد تلقينا طلباً لـ <b>{purpose}</b>.</p>
# # #             <p>رمز التحقق الخاص بك هو:</p>
# # #             <div style="background: #f4f4f4; padding: 15px; text-align: center; font-size: 26px; font-weight: bold;">
# # #                 {otp_code}
# # #             </div>
# # #         </div>
# # #         """
# # #         msg.attach(MIMEText(body, 'html'))
        
# # #         with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
# # #             server.starttls()
# # #             server.login(SMTP_USERNAME, SENDER_PASSWORD) 
# # #             server.send_message(msg)
# # #         return True
# # #     except Exception as e:
# # #         print(f"SMTP Error: {e}")
# # #         return False
# # # # ══════════════════════════════════════════════════════════════════════════════
# # # # العمليات (Endpoints)
# # # # ══════════════════════════════════════════════════════════════════════════════

# # # # 1. جلب البيانات الشاملة عبر student_id مع الترجمة التلقائية الآمنة
# # # @router.get("/profile/{student_id}", response_model=ProfileResponse)
# # # def get_profile(student_id: int, db: Session = Depends(get_db)):
# # #     query = text("""
# # #         SELECT s.student_id AS user_id, u.full_name, u.email, u.phone_number, 
# # #                l.level_name, d.department_name, u.language_code, u.is_dark_mode,
# # #                CAST(u.last_password_change AS TEXT) AS last_password_change
# # #         FROM student s
# # #         JOIN users u ON s.user_id = u.user_id
# # #         LEFT JOIN level l ON s.level_id = l.level_id
# # #         LEFT JOIN department d ON s.department_id = d.department_id
# # #         WHERE s.student_id = :sid
# # #     """)
# # #     result = db.execute(query, {"sid": student_id}).mappings().first()
# # #     if not result:
# # #         raise HTTPException(status_code=404, detail="بيانات الطالب غير موجودة")
        
# # #     # تحويل النتيجة لـ dict قياسي لضمان التوافق مع معايير الويب وفلاتر
# # #     profile_data = dict(result)
    
# # #     # معرفة لغة المستخدم المفضلة المخزنة في الداتابيز
# # #     user_lang = profile_data.get("language_code", "ar")
    
# # #     # تمرير البيانات عبر دالة الترجمة الذكية لحقول النصوص المحددة فقط
# # #     final_data = auto_translate_profile(profile_data, user_lang)
    
# # #     return final_data

# # # # 2. إرسال الكود (الربط عبر student_id)
# # # @router.post("/send-email-otp")
# # # def send_email_otp(body: SendEmailOtpRequest, db: Session = Depends(get_db)):
# # #     student = db.query(Student).filter(Student.student_id == body.user_id).first()
# # #     if not student:
# # #         raise HTTPException(status_code=404, detail="الطالب غير موجود")
    
# # #     user = db.query(User).filter(User.user_id == student.user_id).first()
# # #     if not user:
# # #         raise HTTPException(status_code=404, detail="المستخدم المرتبط بهذا الطالب غير موجود")

# # #     otp = str(random.randint(100000, 999999))
# # #     expiry = datetime.now(timezone.utc) + timedelta(minutes=10)

# # #     db.query(VerificationCode).filter(VerificationCode.user_id == body.user_id).delete()
    
# # #     new_code = VerificationCode(
# # #         user_id=body.user_id, 
# # #         otp_code=otp,
# # #         expiry_time=expiry,
# # #         is_used=False
# # #     )
# # #     db.add(new_code)
    
# # #     if send_security_otp(user.email, otp, "تغيير البريد الإلكتروني"):
# # #         db.commit()
# # #         return {"message": f"تم إرسال الكود إلى بريدك الحالي"}
# # #     else:
# # #         db.rollback()
# # #         raise HTTPException(status_code=500, detail="فشل في إرسال البريد")

# # # # 3. التحقق (الربط عبر student_id)
# # # @router.post("/verify-email-otp")
# # # def verify_email_otp(body: VerifyEmailOtpRequest, db: Session = Depends(get_db)):
# # #     print(f"--- محاولة تحقق جديدة لـ: {body.user_id} ---")

# # #     record = db.query(VerificationCode).filter(
# # #         VerificationCode.user_id == body.user_id,
# # #         VerificationCode.otp_code == body.otp_code,
# # #         VerificationCode.is_used == False
# # #     ).first()

# # #     if record is None:
# # #         print("❌ الرمز غير موجود أو استُخدم سابقاً")
# # #         raise HTTPException(status_code=400, detail="الرمز غير صحيح")

# # #     try:
# # #         student = db.query(Student).filter(Student.student_id == body.user_id).first()
# # #         if not student:
# # #             raise HTTPException(status_code=404, detail="Student not found")

# # #         user = db.query(User).filter(User.user_id == student.user_id).first()
        
# # #         user.email = body.new_email
# # #         record.is_used = True
# # #         db.commit()
        
# # #         print(f"✅ نجاح: تم تحديث إيميل الطالب {body.user_id}")
# # #         return {"message": "Success"}

# # #     except Exception as e:
# # #         db.rollback()
# # #         print(f"❌ خطأ أثناء التحديث: {e}")
# # #         raise HTTPException(status_code=500, detail="فشل تحديث قاعدة البيانات")

# # # # 4. تغيير كلمة المرور
# # # @router.put("/change-password")
# # # def change_password(body: ChangePasswordRequest, db: Session = Depends(get_db)):
# # #     try:
# # #         student = db.query(Student).filter(Student.student_id == body.user_id).first()
# # #         if not student:
# # #             raise HTTPException(status_code=404, detail="لم يتم العثور على بيانات الطالب / Student not found")
            
# # #         user = db.query(User).filter(User.user_id == student.user_id).first()
# # #         if not user:
# # #             raise HTTPException(status_code=404, detail="المستخدم غير موجود / User not found")

# # #         # 1. التحقق من كلمة المرور القديمة (تدعم المشفر والعادي للحسابات القديمة)
# # #         try:
# # #             is_valid_password = pwd_ctx.verify(body.old_password, user.password)
# # #         except ValueError:
# # #             # إذا كانت كلمة المرور في الداتابيز غير مشفرة (نص عادي)
# # #             is_valid_password = (user.password == body.old_password)

# # #         if not is_valid_password:
# # #             raise HTTPException(status_code=400, detail="كلمة المرور الحالية غير صحيحة / Current password is incorrect")

# # #         # 2. التحقق أن الكلمة الجديدة لا تساوي القديمة
# # #         if body.old_password == body.new_password:
# # #             raise HTTPException(status_code=400, detail="كلمة المرور الجديدة يجب أن تكون مختلفة عن الكلمة الحالية / New password must be different from the current one")

# # #         # 3. التحقق من التطابق (احتياطاً للباك إند)
# # #         if body.new_password != body.confirm_password:
# # #             raise HTTPException(status_code=400, detail="كلمة المرور الجديدة غير متطابقة / Passwords do not match")

# # #         # 4. تشفير الكلمة الجديدة قبل حفظها 🔒
# # #         user.password = pwd_ctx.hash(body.new_password)
# # #         user.last_password_change = datetime.now()
# # #         db.commit()

# # #         return {"message": "تم تغيير كلمة المرور بنجاح / Password changed successfully"}

# # #     except HTTPException:
# # #         raise # إعادة إرسال أخطاء التحقق كما هي
# # #     except Exception as e:
# # #         db.rollback() # تراجع عن أي تغيير في الداتابيس لتفادي تخريب البيانات
# # #         print(f"🔴 Database Error in change_password: {e}")
# # #         raise HTTPException(status_code=500, detail="حدث خطأ في النظام، يرجى المحاولة لاحقاً / System error, please try again later")
# # # class DisplayPreferencesSchema(BaseModel):
# # #     user_id: int
# # #     language_code: str
# # #     is_dark_mode: bool

# # # @router.put("/update-display-preferences")
# # # def update_preferences(body: DisplayPreferencesSchema, db: Session = Depends(get_db)):
# # #     student = db.query(Student).filter(Student.student_id == body.user_id).first()
# # #     if not student:
# # #         raise HTTPException(status_code=404, detail="Student not found")
        
# # #     user = db.query(User).filter(User.user_id == student.user_id).first()
# # #     if not user:
# # #         raise HTTPException(status_code=404, detail="User not found")
    
# # #     user.language_code = body.language_code
# # #     user.is_dark_mode = body.is_dark_mode
    
# # #     db.commit()
# # #     db.refresh(user)
    
# # #     return {"message": "Preferences updated successfully"}

# # # @router.get("/display-preferences/{student_id}")
# # # def get_display_preferences(student_id: int, db: Session = Depends(get_db)):
# # #     student = db.query(Student).filter(Student.student_id == student_id).first()
# # #     if not student:
# # #         raise HTTPException(status_code=404, detail="Student not found")

# # #     user = db.query(User).filter(User.user_id == student.user_id).first()
# # #     if not user:
# # #         raise HTTPException(status_code=404, detail="User not found")

# # #     return {
# # #         "language_code": user.language_code or "ar",
# # #         "is_dark_mode": user.is_dark_mode or False
# # #     }


# # # # 5. إرسال رمز استعادة كلمة المرور من داخل الإعدادات
# # # # 5. إرسال رمز استعادة كلمة المرور من داخل الإعدادات
# # # @router.post("/forgot-password/send-otp")
# # # async def settings_forgot_password_send_otp(body: ForgotPasswordSendOtp, db: Session = Depends(get_db)):
# # #     try:
# # #         student = db.query(Student).filter(Student.student_id == body.user_id).first()
# # #         if not student:
# # #             raise HTTPException(status_code=404, detail="الطالب غير موجود / Student not found")
        
# # #         user = db.query(User).filter(User.user_id == student.user_id).first()
        
# # #         otp = str(random.randint(100000, 999999))
# # #         expiry = datetime.now(timezone.utc) + timedelta(minutes=10)

# # #         # مسح الرموز القديمة لنفس المستخدم لتفادي التكرار
# # #         db.query(VerificationCode).filter(VerificationCode.user_id == body.user_id).delete()
        
# # #         new_code = VerificationCode(
# # #             user_id=body.user_id,
# # #             otp_code=otp,
# # #             expiry_time=expiry,
# # #             is_used=False
# # #         )
# # #         db.add(new_code)
        
# # #         # 🌟 إرسال الإيميل باللغتين
# # #         message = MessageSchema(
# # #             subject="استعادة كلمة المرور / Password Reset", 
# # #             recipients=[user.email], 
# # #             body=f"رمز التحقق الخاص باستعادة كلمة المرور هو: {otp}\nالرمز صالح لمدة 10 دقائق.\n\nYour password reset OTP is: {otp}\nValid for 10 minutes.", 
# # #             subtype="plain"
# # #         )
# # #         fm = FastMail(conf)
# # #         print("--- جاري إرسال إيميل الاستعادة من الإعدادات ---") 
# # #         await fm.send_message(message)
# # #         print("--- تم الإرسال بنجاح ---")
        
# # #         # حفظ التعديلات في الداتابيز فقط بعد نجاح إرسال الإيميل
# # #         db.commit()
# # #         return {"message": "تم إرسال رمز الاستعادة لبريدك بنجاح / Password reset OTP sent successfully"}
        
# # #     except HTTPException:
# # #         raise
# # #     except Exception as e:
# # #         db.rollback()
# # #         print(f"🔴 خطأ في إرسال الإيميل: {e}")
# # #         raise HTTPException(status_code=500, detail="فشل إرسال البريد الإلكتروني / Failed to send email")


# # # # 6. التحقق من الرمز
# # # @router.post("/forgot-password/verify-otp")
# # # def settings_forgot_password_verify_otp(body: ForgotPasswordVerifyOtp, db: Session = Depends(get_db)):
# # #     try:
# # #         record = db.query(VerificationCode).filter(
# # #             VerificationCode.user_id == body.user_id,
# # #             VerificationCode.otp_code == body.otp_code,
# # #             VerificationCode.is_used == False
# # #         ).first()

# # #         if record is None:
# # #             raise HTTPException(status_code=400, detail="الرمز غير صحيح أو استُخدم مسبقاً / Invalid or already used OTP code")
            
# # #         return {"message": "الرمز صحيح / OTP is valid"}
        
# # #     except HTTPException:
# # #         raise
# # #     except Exception as e:
# # #         print(f"🔴 Error in verify_otp: {e}")
# # #         raise HTTPException(status_code=500, detail="حدث خطأ في النظام، يرجى المحاولة لاحقاً / System error, please try again later")


# # # # 7. تعيين كلمة المرور الجديدة (مع التشفير والـ Try-Except)
# # # @router.post("/forgot-password/reset")
# # # def settings_forgot_password_reset(body: ForgotPasswordReset, db: Session = Depends(get_db)):
# # #     try:
# # #         record = db.query(VerificationCode).filter(
# # #             VerificationCode.user_id == body.user_id,
# # #             VerificationCode.otp_code == body.otp_code,
# # #             VerificationCode.is_used == False
# # #         ).first()

# # #         if record is None:
# # #             raise HTTPException(status_code=400, detail="الرمز غير صالح أو منتهي الصلاحية / Invalid or expired OTP code")

# # #         student = db.query(Student).filter(Student.student_id == body.user_id).first()
# # #         user = db.query(User).filter(User.user_id == student.user_id).first()

# # #         # تشفير كلمة المرور الجديدة قبل الحفظ 🔒
# # #         user.password = pwd_ctx.hash(body.new_password)
# # #         user.last_password_change = datetime.now()
        
# # #         # إبطال الرمز
# # #         record.is_used = True
# # #         db.commit()

# # #         return {"message": "تم تحديث كلمة المرور بنجاح / Password updated successfully"}

# # #     except HTTPException:
# # #         raise
# # #     except Exception as e:
# # #         db.rollback()
# # #         print(f"🔴 Database Error in password_reset: {e}")
# # #         raise HTTPException(status_code=500, detail="حدث خطأ أثناء تحديث كلمة المرور / Error updating password")




































# # # # @router.post("/forgot-password/reset")
# # # # def settings_forgot_password_reset(body: ForgotPasswordReset, db: Session = Depends(get_db)):
# # # #     try:
# # # #         record = db.query(VerificationCode).filter(
# # # #             VerificationCode.user_id == body.user_id,
# # # #             VerificationCode.otp_code == body.otp_code,
# # # #             VerificationCode.is_used == False
# # # #         ).first()

# # # #         if record is None:
# # # #             raise HTTPException(status_code=400, detail="الرمز غير صالح أو منتهي الصلاحية / Invalid or expired OTP code")

# # # #         student = db.query(Student).filter(Student.student_id == body.user_id).first()
# # # #         user = db.query(User).filter(User.user_id == student.user_id).first()

# # # #         # تشفير كلمة المرور الجديدة قبل الحفظ 🔒
# # # #         user.password = pwd_ctx.hash(body.new_password)
# # # #         user.last_password_change = datetime.now()
        
# # # #         # إبطال الرمز
# # # #         record.is_used = True
# # # #         db.commit()

# # # #         return {"message": "تم تحديث كلمة المرور بنجاح / Password updated successfully"}

# # # #     except HTTPException:
# # # #         raise
# # # #     except Exception as e:
# # # #         db.rollback()
# # # #         print(f"🔴 Database Error in password_reset: {e}")
# # # #         raise HTTPException(status_code=500, detail="حدث خطأ أثناء تحديث كلمة المرور / Error updating password")
    

# # # # @router.post("/forgot-password/verify-otp")
# # # # def settings_forgot_password_verify_otp(body: ForgotPasswordVerifyOtp, db: Session = Depends(get_db)):
# # # #     record = db.query(VerificationCode).filter(
# # # #         VerificationCode.user_id == body.user_id,
# # # #         VerificationCode.otp_code == body.otp_code,
# # # #         VerificationCode.is_used == False
# # # #     ).first()

# # # #     if record is None:
# # # #         raise HTTPException(status_code=400, detail="الرمز غير صحيح أو استُخدم مسبقاً")
        
# # # #     return {"message": "الرمز صحيح"}

# # # # # 7. تعيين كلمة المرور الجديدة
# # # # @router.post("/forgot-password/reset")
# # # # def settings_forgot_password_reset(body: ForgotPasswordReset, db: Session = Depends(get_db)):
# # # #     record = db.query(VerificationCode).filter(
# # # #         VerificationCode.user_id == body.user_id,
# # # #         VerificationCode.otp_code == body.otp_code,
# # # #         VerificationCode.is_used == False
# # # #     ).first()

# # # #     if record is None:
# # # #         raise HTTPException(status_code=400, detail="الرمز غير صالح")

# # # #     student = db.query(Student).filter(Student.student_id == body.user_id).first()
# # # #     user = db.query(User).filter(User.user_id == student.user_id).first()

# # # #     # تحديث الباسوورد
# # # #     user.password = body.new_password
# # # #     user.last_password_change = datetime.now()
    
# # # #     # إبطال الرمز
# # # #     record.is_used = True
# # # #     db.commit()

# # # #     return {"message": "تم تحديث كلمة المرور بنجاح"}


















# # # # # from fastapi import APIRouter, Depends, HTTPException, status
# # # # # from sqlalchemy.orm import Session
# # # # # from sqlalchemy import text
# # # # # from pydantic import BaseModel, EmailStr
# # # # # from passlib.context import CryptContext
# # # # # from datetime import datetime, timedelta, timezone
# # # # # import random
# # # # # import smtplib
# # # # # from email.mime.text import MIMEText
# # # # # from email.mime.multipart import MIMEMultipart
# # # # # from pydantic import BaseModel


# # # # # # ── استيرادات قاعدة البيانات والموديلات ──────────────────────────────────────────
# # # # # from db.database import get_db
# # # # # from models.users import User, VerificationCode
# # # # # from models.profiles import Student  # تأكدي أن هذا المسار صحيح في مشروعك

# # # # router = APIRouter(prefix="/settings", tags=["Settings"])
# # # # pwd_ctx = CryptContext(schemes=["bcrypt"], deprecated="auto")
# # # # # ── إعدادات بريد النظام ────────────────────────────────────────────────────────
# # # # SMTP_SERVER = "smtp.gmail.com"
# # # # SMTP_PORT = 587
# # # # SENDER_EMAIL = "alhaddar1020@gmail.com"
# # # # SENDER_PASSWORD = "iypm vdrf ogzi hvuw"

# # # # # ══════════════════════════════════════════════════════════════════════════════
# # # # # النماذج (Schemas)
# # # # # ══════════════════════════════════════════════════════════════════════════════

# # # # class ProfileResponse(BaseModel):
# # # #     user_id: int # هذا سيمثل student_id في رد السيرفر للتوافق مع الفلاتر
# # # #     full_name: str
# # # #     email: str
# # # #     phone_number: str | None
# # # #     level_name: str | None
# # # #     department_name: str | None
# # # #     last_password_change: str | None
# # # #     language_code: str | None  # 💡 أضيفي هذا السطر
# # # #     is_dark_mode: bool | None  # 💡 أضيفي هذا السطر
# # # # class SendEmailOtpRequest(BaseModel):
# # # #     user_id: int  # هنا الفلاتر ترسل الـ student_id

# # # # class VerifyEmailOtpRequest(BaseModel):
# # # #     user_id: int  # هنا الفلاتer ترسل الـ student_id
# # # #     new_email: EmailStr
# # # #     otp_code: str

# # # # class UpdateProfileRequest(BaseModel):
# # # #     user_id: int
# # # #     full_name: str

# # # # class ChangePasswordRequest(BaseModel):
# # # #     user_id: int
# # # #     old_password: str
# # # #     new_password: str
# # # #     confirm_password: str

# # # # # ══════════════════════════════════════════════════════════════════════════════
# # # # # الوظائف المساعدة
# # # # # ══════════════════════════════════════════════════════════════════════════════

# # # # def send_security_otp(receiver_email: str, otp_code: str, purpose: str):
# # # #     try:
# # # #         msg = MIMEMultipart()
# # # #         msg['From'] = f"نظام التصحيح الذكي <{SENDER_EMAIL}>"
# # # #         msg['To'] = receiver_email
# # # #         msg['Subject'] = f"رمز أمان: {purpose}"
        
# # # #         body = f"""
# # # #         <div dir="rtl" style="font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd; border-radius: 10px;">
# # # #             <h2 style="color: #c0392b;">تنبيه أمني من نظام التصحيح</h2>
# # # #             <p>لقد تلقينا طلباً لـ <b>{purpose}</b>.</p>
# # # #             <p>رمز التحقق الخاص بك هو:</p>
# # # #             <div style="background: #f4f4f4; padding: 15px; text-align: center; font-size: 26px; font-weight: bold;">
# # # #                 {otp_code}
# # # #             </div>
# # # #         </div>
# # # #         """
# # # #         msg.attach(MIMEText(body, 'html'))
# # # #         with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
# # # #             server.starttls()
# # # #             server.login(SENDER_EMAIL, SENDER_PASSWORD)
# # # #             server.send_message(msg)
# # # #         return True
# # # #     except Exception as e:
# # # #         print(f"SMTP Error: {e}")
# # # #         return False

# # # # # ══════════════════════════════════════════════════════════════════════════════
# # # # # العمليات (Endpoints)
# # # # # ══════════════════════════════════════════════════════════════════════════════

# # # # # 1. جلب البيانات عبر student_id
# # # # # 1. جلب البيانات الشاملة عبر student_id بما فيها تفاصيل اللغة والثيم
# # # # # 1. جلب البيانات الشاملة عبر student_id بما فيها تفاصيل اللغة والثيم
# # # # @router.get("/profile/{student_id}", response_model=ProfileResponse)
# # # # def get_profile(student_id: int, db: Session = Depends(get_db)):
# # # #     query = text("""
# # # #         SELECT s.student_id AS user_id, u.full_name, u.email, u.phone_number, 
# # # #                l.level_name, d.department_name, u.language_code, u.is_dark_mode,
# # # #                CAST(u.last_password_change AS TEXT) AS last_password_change
# # # #         FROM student s
# # # #         JOIN users u ON s.user_id = u.user_id
# # # #         LEFT JOIN level l ON s.level_id = l.level_id
# # # #         LEFT JOIN department d ON s.department_id = d.department_id
# # # #         WHERE s.student_id = :sid
# # # #     """)
# # # #     result = db.execute(query, {"sid": student_id}).mappings().first()
# # # #     if not result:
# # # #         raise HTTPException(status_code=404, detail="بيانات الطالب غير موجودة")
        
# # # #     # 🌟 التعديل السحري: تحويل النتيجة لـ dict قياسي لضمان صياغة قيم الـ Boolean والـ Null بشكل يفهمه الـ Web
# # # #     return dict(result)

# # # # # 2. إرسال الكود (الربط عبر student_id)
# # # # @router.post("/send-email-otp")
# # # # def send_email_otp(body: SendEmailOtpRequest, db: Session = Depends(get_db)):
# # # #     # الربط الصحيح: نبحث عن الطالب أولاً ثم المستخدم المرتبط به
# # # #     student = db.query(Student).filter(Student.student_id == body.user_id).first()
# # # #     if not student:
# # # #         raise HTTPException(status_code=404, detail="الطالب غير موجود")
    
# # # #     user = db.query(User).filter(User.user_id == student.user_id).first()
# # # #     if not user:
# # # #         raise HTTPException(status_code=404, detail="المستخدم المرتبط بهذا الطالب غير موجود")

# # # #     otp = str(random.randint(100000, 999999))
# # # #     expiry = datetime.now(timezone.utc) + timedelta(minutes=10)

# # # #     # تنظيف الأكواد القديمة
# # # #     db.query(VerificationCode).filter(VerificationCode.user_id == body.user_id).delete()
    
# # # #     new_code = VerificationCode(
# # # #         user_id=body.user_id, # هنا نحفظ الـ student_id ليتطابق مع طلب الفلاتر
# # # #         otp_code=otp,
# # # #         expiry_time=expiry,
# # # #         is_used=False
# # # #     )
# # # #     db.add(new_code)
    
# # # #     if send_security_otp(user.email, otp, "تغيير البريد الإلكتروني"):
# # # #         db.commit()
# # # #         return {"message": f"تم إرسال الكود إلى بريدك الحالي"}
# # # #     else:
# # # #         db.rollback()
# # # #         raise HTTPException(status_code=500, detail="فشل في إرسال البريد")

# # # # # 3. التحقق (الربط عبر student_id)

# # # # @router.post("/verify-email-otp")
# # # # def verify_email_otp(body: VerifyEmailOtpRequest, db: Session = Depends(get_db)):
# # # #     print(f"--- محاولة تحقق جديدة لـ: {body.user_id} ---")

# # # #     # البحث عن الكود المطابق بالضبط
# # # #     record = db.query(VerificationCode).filter(
# # # #         VerificationCode.user_id == body.user_id,
# # # #         VerificationCode.otp_code == body.otp_code,
# # # #         VerificationCode.is_used == False
# # # #     ).first()

# # # #     # إذا لم يجد الكود، نرسل خطأ 400 فوراً دون محاولة طباعة "آخر كود"
# # # #     if record is None:
# # # #         print("❌ الرمز غير موجود أو استُخدم سابقاً")
# # # #         raise HTTPException(status_code=400, detail="الرمز غير صحيح")

# # # #     # إذا وجد الكود، نكمل عملية التحديث
# # # #     try:
# # # #         student = db.query(Student).filter(Student.student_id == body.user_id).first()
# # # #         if not student:
# # # #             raise HTTPException(status_code=404, detail="Student not found")

# # # #         user = db.query(User).filter(User.user_id == student.user_id).first()
        
# # # #         # التحديث الفعلي
# # # #         user.email = body.new_email
# # # #         record.is_used = True
# # # #         db.commit()
        
# # # #         print(f"✅ نجاح: تم تحديث إيميل الطالب {body.user_id}")
# # # #         return {"message": "Success"}

# # # #     except Exception as e:
# # # #         db.rollback()
# # # #         print(f"❌ خطأ أثناء التحديث: {e}")
# # # #         raise HTTPException(status_code=500, detail="فشل تحديث قاعدة البيانات")

# # # # # 4. تحديث الاسم (عبر student_id)
# # # # @router.put("/change-password")
# # # # def change_password(body: ChangePasswordRequest, db: Session = Depends(get_db)):

# # # #     student = db.query(Student).filter(Student.student_id == body.user_id).first()
# # # #     user = db.query(User).filter(User.user_id == student.user_id).first()

# # # #     # التحقق بدون hashing
# # # #     if user.password != body.old_password:
# # # #         raise HTTPException(status_code=400, detail="كلمة المرور الحالية غير صحيحة")

# # # #     # التحقق من التطابق
# # # #     if body.new_password != body.confirm_password:
# # # #         raise HTTPException(status_code=400, detail="كلمة المرور الجديدة غير متطابقة")

# # # #     # تحديث مباشر بدون تشفير
# # # #     user.password = body.new_password
# # # #     user.last_password_change = datetime.now()
# # # #     db.commit()

# # # #     return {"message": "تم تغيير كلمة المرور بنجاح"}



# # # # class DisplayPreferencesSchema(BaseModel):
# # # #     user_id: int
# # # #     language_code: str
# # # #     is_dark_mode: bool
# # # # @router.put("/update-display-preferences")
# # # # def update_preferences(body: DisplayPreferencesSchema, db: Session = Depends(get_db)):
# # # #     # 1. البحث في جدول الـ student باستخدام الـ ID القادم من فلاتر (الذي هو 1)
# # # #     student = db.query(Student).filter(Student.student_id == body.user_id).first()
# # # #     if not student:
# # # #         raise HTTPException(status_code=404, detail="Student not found")
        
# # # #     # 2. 🌟 السر هنا: جلب اليوزر الحقيقي المرتبط بالطالب عبر (student.user_id) 
# # # #     # في حالتنا هذه: سيجلب تلقائياً اليوزر رقم 2 غصباً عن المتصفح!
# # # #     user = db.query(User).filter(User.user_id == student.user_id).first()
# # # #     if not user:
# # # #         raise HTTPException(status_code=404, detail="User not found")
    
# # # #     # 3. تحديث قيم اللغة والثيم لليوزر الصحيح
# # # #     user.language_code = body.language_code
# # # #     user.is_dark_mode = body.is_dark_mode
    
# # # #     # 4. تثبيت واعتماد الحفظ في سحابة Supabase
# # # #     db.commit()
# # # #     db.refresh(user)
    
# # # #     return {"message": "Preferences updated successfully"}

# # # # @router.get("/display-preferences/{student_id}")
# # # # def get_display_preferences(student_id: int, db: Session = Depends(get_db)):
# # # #     student = db.query(Student).filter(Student.student_id == student_id).first()
# # # #     if not student:
# # # #         raise HTTPException(status_code=404, detail="Student not found")

# # # #     user = db.query(User).filter(User.user_id == student.user_id).first()
# # # #     if not user:
# # # #         raise HTTPException(status_code=404, detail="User not found")

# # # #     return {
# # # #         "language_code": user.language_code or "ar",
# # # #         "is_dark_mode": user.is_dark_mode or False
# # # #     }


# # from fastapi import APIRouter, Depends, HTTPException, status
# # from sqlalchemy.orm import Session
# # from sqlalchemy import text
# # from pydantic import BaseModel, EmailStr
# # from passlib.context import CryptContext
# # from datetime import datetime, timedelta, timezone
# # import random
# # import smtplib
# # from email.mime.text import MIMEText
# # from email.mime.multipart import MIMEMultipart

# # # 🌟 استيراد حزمة الترجمة التلقائية السحرية بأمان
# # from deep_translator import GoogleTranslator

# # # ── استيرادات قاعدة البيانات والموديلات ──────────────────────────────────────────
# # from db.database import get_db
# # from models.users import User, VerificationCode
# # from models.profiles import Student  

# # from fastapi_mail import MessageSchema, FastMail, ConnectionConfig
# # router = APIRouter(prefix="/settings", tags=["Settings"])
# # pwd_ctx = CryptContext(schemes=["bcrypt"], deprecated="auto")

# # # ── إعدادات بريد النظام ────────────────────────────────────────────────────────
# # SMTP_SERVER = "smtp.sendgrid.net"
# # SMTP_PORT = 587
# # SMTP_USERNAME = "apikey"
# # SENDER_EMAIL = "aryjth953@gmail.com" # 🌟 إيميلك الموثق رسمياً
# # SENDER_PASSWORD = "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"

# # conf = ConnectionConfig(
# #     MAIL_USERNAME="apikey", 
# #     MAIL_PASSWORD="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", 
# #     MAIL_FROM="aryjth953@gmail.com", 
# #     MAIL_FROM_NAME="Intelligent Grading System", # 🌟 ضفنا هذي عشان SendGrid يطابق الاسم 100%
# #     MAIL_PORT=587,             
# #     MAIL_SERVER="smtp.sendgrid.net", 
# #     MAIL_STARTTLS=True,        
# #     MAIL_SSL_TLS=False,         
# #     USE_CREDENTIALS=True,
# #     VALIDATE_CERTS=True
# # )

# # # ══════════════════════════════════════════════════════════════════════════════
# # # النماذج (Schemas)
# # # ══════════════════════════════════════════════════════════════════════════════

# # class ForgotPasswordSendOtp(BaseModel):
# #     user_id: int

# # class ForgotPasswordVerifyOtp(BaseModel):
# #     user_id: int
# #     otp_code: str

# # class ForgotPasswordReset(BaseModel):
# #     user_id: int
# #     otp_code: str
# #     new_password: str

# # class ProfileResponse(BaseModel):
# #     user_id: int 
# #     full_name: str
# #     email: str
# #     phone_number: str | None
# #     level_name: str | None
# #     department_name: str | None
# #     last_password_change: str | None
# #     language_code: str | None  
# #     is_dark_mode: bool | None  
# #     full_name_en: str | None
# #     level_name_en: str | None
# #     department_name_en: str | None

# # class SendEmailOtpRequest(BaseModel):
# #     user_id: int  

# # class VerifyEmailOtpRequest(BaseModel):
# #     user_id: int  
# #     new_email: EmailStr
# #     otp_code: str

# # class UpdateProfileRequest(BaseModel):
# #     user_id: int
# #     full_name: str

# # class ChangePasswordRequest(BaseModel):
# #     user_id: int
# #     old_password: str
# #     new_password: str
# #     confirm_password: str

# # # ══════════════════════════════════════════════════════════════════════════════
# # # الوظائف المساعدة الذكية
# # # ══════════════════════════════════════════════════════════════════════════════

# # def get_msg(user: User | None, ar_msg: str, en_msg: str) -> str:
# #     """🌟 الدالة السحرية: تفحص لغة المستخدم من الداتابيز وترجع النص الصحيح بلغة واحدة فقط"""
# #     lang = user.language_code if user and user.language_code else "ar"
# #     return en_msg if lang == "en" else ar_msg

# # def auto_translate_profile(profile_dict: dict, target_lang: str) -> dict:
# #     """🌟 الدالة المطورة: تترجم المستوى والتخصص فقط عبر المكتبة وتمنع ترجمة الاسم نهائياً"""
# #     profile_dict["full_name_en"] = profile_dict.get("full_name")
# #     profile_dict["level_name_en"] = profile_dict.get("level_name")
# #     profile_dict["department_name_en"] = profile_dict.get("department_name")

# #     fields_to_translate = ["level_name", "department_name"]
# #     for key in fields_to_translate:
# #         value = profile_dict.get(key)
# #         if value and isinstance(value, str):
# #             try:
# #                 profile_dict[f"{key}_en"] = GoogleTranslator(source='ar', target='en').translate(value)
# #             except Exception as e:
# #                 print(f"⚠️ خطأ غير مؤثر في ترجمة {key}: {e}")
                    
# #     return profile_dict


# # def send_security_otp(receiver_email: str, otp_code: str, purpose_ar: str, purpose_en: str, lang: str):
# #     try:
# #         is_en = (lang == "en")
# #         purpose = purpose_en if is_en else purpose_ar
# #         subject = f"Security Code: {purpose}" if is_en else f"رمز أمان: {purpose}"
# #         title = "Security Alert" if is_en else "تنبيه أمني من نظام التصحيح"
# #         p1 = f"We received a request to <b>{purpose}</b>." if is_en else f"لقد تلقينا طلباً لـ <b>{purpose}</b>."
# #         p2 = "Your verification code is:" if is_en else "رمز التحقق الخاص بك هو:"
# #         dir_attr = "ltr" if is_en else "rtl"
# #         align = "left" if is_en else "right"

# #         msg = MIMEMultipart()
# #         msg['From'] = SENDER_EMAIL 
# #         msg['To'] = receiver_email
# #         msg['Subject'] = subject
        
# #         body = f"""
# #         <div dir="{dir_attr}" style="font-family: Arial, sans-serif; padding: 20px; text-align: {align}; border: 1px solid #ddd; border-radius: 10px;">
# #             <h2 style="color: #c0392b;">{title}</h2>
# #             <p>{p1}</p>
# #             <p>{p2}</p>
# #             <div style="background: #f4f4f4; padding: 15px; text-align: center; font-size: 26px; font-weight: bold;">
# #                 {otp_code}
# #             </div>
# #         </div>
# #         """
# #         msg.attach(MIMEText(body, 'html'))
        
# #         with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
# #             server.starttls()
# #             server.login(SMTP_USERNAME, SENDER_PASSWORD) 
# #             server.send_message(msg)
# #         return True
# #     except Exception as e:
# #         print(f"SMTP Error: {e}")
# #         return False

# # # ══════════════════════════════════════════════════════════════════════════════
# # # العمليات (Endpoints)
# # # ══════════════════════════════════════════════════════════════════════════════

# # # 1. جلب البيانات الشاملة عبر student_id مع الترجمة التلقائية الآمنة
# # @router.get("/profile/{student_id}", response_model=ProfileResponse)
# # def get_profile(student_id: int, db: Session = Depends(get_db)):
# #     query = text("""
# #         SELECT s.student_id AS user_id, u.full_name, u.email, u.phone_number, 
# #                l.level_name, d.department_name, u.language_code, u.is_dark_mode,
# #                CAST(u.last_password_change AS TEXT) AS last_password_change
# #         FROM student s
# #         JOIN users u ON s.user_id = u.user_id
# #         LEFT JOIN level l ON s.level_id = l.level_id
# #         LEFT JOIN department d ON s.department_id = d.department_id
# #         WHERE s.student_id = :sid
# #     """)
# #     result = db.execute(query, {"sid": student_id}).mappings().first()
# #     if not result:
# #         # هنا ليس لدينا يوزر لنقرأ لغته، فسنتركها باللغتين كحالة نادرة جداً
# #         raise HTTPException(status_code=404, detail="بيانات الطالب غير موجودة / Student data not found")
        
# #     profile_data = dict(result)
# #     user_lang = profile_data.get("language_code", "ar")
# #     final_data = auto_translate_profile(profile_data, user_lang)
    
# #     return final_data

# # # 2. إرسال الكود (الربط عبر student_id)
# # @router.post("/send-email-otp")
# # def send_email_otp(body: SendEmailOtpRequest, db: Session = Depends(get_db)):
# #     student = db.query(Student).filter(Student.student_id == body.user_id).first()
# #     user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

# #     if not student:
# #         raise HTTPException(status_code=404, detail=get_msg(user, "الطالب غير موجود", "Student not found"))
# #     if not user:
# #         raise HTTPException(status_code=404, detail=get_msg(user, "المستخدم غير موجود", "User not found"))

# #     otp = str(random.randint(100000, 999999))
# #     expiry = datetime.now(timezone.utc) + timedelta(minutes=10)

# #     db.query(VerificationCode).filter(VerificationCode.user_id == body.user_id).delete()
    
# #     new_code = VerificationCode(
# #         user_id=body.user_id, 
# #         otp_code=otp,
# #         expiry_time=expiry,
# #         is_used=False
# #     )
# #     db.add(new_code)
    
# #     lang = user.language_code if user.language_code else "ar"
# #     if send_security_otp(user.email, otp, "تغيير البريد الإلكتروني", "Change Email", lang):
# #         db.commit()
# #         return {"message": get_msg(user, "تم إرسال الكود إلى بريدك", "Code sent to your email")}
# #     else:
# #         db.rollback()
# #         raise HTTPException(status_code=500, detail=get_msg(user, "فشل في إرسال البريد", "Failed to send email"))

# # # 3. التحقق (الربط عبر student_id)
# # @router.post("/verify-email-otp")
# # def verify_email_otp(body: VerifyEmailOtpRequest, db: Session = Depends(get_db)):
# #     student = db.query(Student).filter(Student.student_id == body.user_id).first()
# #     user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

# #     record = db.query(VerificationCode).filter(
# #         VerificationCode.user_id == body.user_id,
# #         VerificationCode.otp_code == body.otp_code,
# #         VerificationCode.is_used == False
# #     ).first()

# #     if record is None:
# #         raise HTTPException(status_code=400, detail=get_msg(user, "الرمز غير صحيح", "Invalid OTP"))

# #     try:
# #         if not student:
# #             raise HTTPException(status_code=404, detail=get_msg(user, "الطالب غير موجود", "Student not found"))

# #         user.email = body.new_email
# #         record.is_used = True
# #         db.commit()
        
# #         return {"message": get_msg(user, "تم تحديث البريد بنجاح", "Email updated successfully")}

# #     except Exception as e:
# #         db.rollback()
# #         raise HTTPException(status_code=500, detail=get_msg(user, "فشل تحديث قاعدة البيانات", "Database update failed"))

# # # 4. تغيير كلمة المرور
# # @router.put("/change-password")
# # def change_password(body: ChangePasswordRequest, db: Session = Depends(get_db)):
# #     try:
# #         student = db.query(Student).filter(Student.student_id == body.user_id).first()
# #         user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

# #         if not student:
# #             raise HTTPException(status_code=404, detail=get_msg(user, "الطالب غير موجود", "Student not found"))
            
# #         if not user:
# #             raise HTTPException(status_code=404, detail=get_msg(user, "المستخدم غير موجود", "User not found"))

# #         try:
# #             is_valid_password = pwd_ctx.verify(body.old_password, user.password)
# #         except ValueError:
# #             is_valid_password = (user.password == body.old_password)

# #         if not is_valid_password:
# #             raise HTTPException(status_code=400, detail=get_msg(user, "كلمة المرور الحالية غير صحيحة", "Current password is incorrect"))

# #         if body.old_password == body.new_password:
# #             raise HTTPException(status_code=400, detail=get_msg(user, "كلمة المرور الجديدة يجب أن تكون مختلفة", "New password must be different"))

# #         if body.new_password != body.confirm_password:
# #             raise HTTPException(status_code=400, detail=get_msg(user, "كلمة المرور الجديدة غير متطابقة", "Passwords do not match"))

# #         user.password = pwd_ctx.hash(body.new_password[:72])
# #         user.last_password_change = datetime.now()
# #         db.commit()

# #         return {"message": get_msg(user, "تم تغيير كلمة المرور بنجاح", "Password changed successfully")}

# #     except HTTPException:
# #         raise 
# #     except Exception as e:
# #         db.rollback()
# #         raise HTTPException(status_code=500, detail=get_msg(user, "حدث خطأ، حاول لاحقاً", "System error, try again later"))

# # class DisplayPreferencesSchema(BaseModel):
# #     user_id: int
# #     language_code: str
# #     is_dark_mode: bool

# # @router.put("/update-display-preferences")
# # def update_preferences(body: DisplayPreferencesSchema, db: Session = Depends(get_db)):
# #     student = db.query(Student).filter(Student.student_id == body.user_id).first()
# #     if not student:
# #         raise HTTPException(status_code=404, detail="Student not found")
        
# #     user = db.query(User).filter(User.user_id == student.user_id).first()
# #     if not user:
# #         raise HTTPException(status_code=404, detail="User not found")
    
# #     user.language_code = body.language_code
# #     user.is_dark_mode = body.is_dark_mode
    
# #     db.commit()
# #     db.refresh(user)
    
# #     return {"message": "Preferences updated successfully"}

# # @router.get("/display-preferences/{student_id}")
# # def get_display_preferences(student_id: int, db: Session = Depends(get_db)):
# #     student = db.query(Student).filter(Student.student_id == student_id).first()
# #     if not student:
# #         raise HTTPException(status_code=404, detail="Student not found")

# #     user = db.query(User).filter(User.user_id == student.user_id).first()
# #     if not user:
# #         raise HTTPException(status_code=404, detail="User not found")

# #     return {
# #         "language_code": user.language_code or "ar",
# #         "is_dark_mode": user.is_dark_mode or False
# #     }


# # # 5. إرسال رمز استعادة كلمة المرور من داخل الإعدادات
# # @router.post("/forgot-password/send-otp")
# # async def settings_forgot_password_send_otp(body: ForgotPasswordSendOtp, db: Session = Depends(get_db)):
# #     try:
# #         student = db.query(Student).filter(Student.student_id == body.user_id).first()
# #         user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

# #         if not student:
# #             raise HTTPException(status_code=404, detail=get_msg(user, "الطالب غير موجود", "Student not found"))
        
# #         otp = str(random.randint(100000, 999999))
# #         expiry = datetime.now(timezone.utc) + timedelta(minutes=10)

# #         db.query(VerificationCode).filter(VerificationCode.user_id == body.user_id).delete()
        
# #         new_code = VerificationCode(
# #             user_id=body.user_id,
# #             otp_code=otp,
# #             expiry_time=expiry,
# #             is_used=False
# #         )
# #         db.add(new_code)
        
# #         lang = user.language_code if user and user.language_code else "ar"
# #         subject = "Password Reset" if lang == "en" else "استعادة كلمة المرور"
# #         body_text = f"Your password reset OTP is: {otp}\nValid for 10 minutes." if lang == "en" else f"رمز التحقق الخاص باستعادة كلمة المرور هو: {otp}\nالرمز صالح لمدة 10 دقائق."

# #         message = MessageSchema(
# #             subject=subject, 
# #             recipients=[user.email], 
# #             body=body_text, 
# #             subtype="plain"
# #         )
# #         fm = FastMail(conf)
# #         await fm.send_message(message)
        
# #         db.commit()
# #         return {"message": get_msg(user, "تم إرسال رمز الاستعادة بنجاح", "Password reset OTP sent successfully")}
        
# #     except HTTPException:
# #         raise
# #     except Exception as e:
# #         db.rollback()
# #         raise HTTPException(status_code=500, detail=get_msg(user, "فشل إرسال البريد الإلكتروني", "Failed to send email"))


# # # 6. التحقق من الرمز
# # @router.post("/forgot-password/verify-otp")
# # def settings_forgot_password_verify_otp(body: ForgotPasswordVerifyOtp, db: Session = Depends(get_db)):
# #     try:
# #         student = db.query(Student).filter(Student.student_id == body.user_id).first()
# #         user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

# #         record = db.query(VerificationCode).filter(
# #             VerificationCode.user_id == body.user_id,
# #             VerificationCode.otp_code == body.otp_code,
# #             VerificationCode.is_used == False
# #         ).first()

# #         if record is None:
# #             raise HTTPException(status_code=400, detail=get_msg(user, "الرمز غير صحيح أو منتهي الصلاحية", "Invalid or expired OTP code"))
            
# #         return {"message": get_msg(user, "الرمز صحيح", "OTP is valid")}
        
# #     except HTTPException:
# #         raise
# #     except Exception as e:
# #         raise HTTPException(status_code=500, detail=get_msg(user, "حدث خطأ في النظام، يرجى المحاولة لاحقاً", "System error, please try again later"))


# # # 7. تعيين كلمة المرور الجديدة (مع التشفير والـ Try-Except)
# # @router.post("/forgot-password/reset")
# # def settings_forgot_password_reset(body: ForgotPasswordReset, db: Session = Depends(get_db)):
# #     try:
# #         student = db.query(Student).filter(Student.student_id == body.user_id).first()
# #         user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

# #         record = db.query(VerificationCode).filter(
# #             VerificationCode.user_id == body.user_id,
# #             VerificationCode.otp_code == body.otp_code,
# #             VerificationCode.is_used == False
# #         ).first()

# #         if record is None:
# #             raise HTTPException(status_code=400, detail=get_msg(user, "الرمز غير صالح أو منتهي الصلاحية", "Invalid or expired OTP code"))

# #         user.password = pwd_ctx.hash(body.new_password[:72])
# #         user.last_password_change = datetime.now()
        
# #         record.is_used = True
# #         db.commit()

# #         return {"message": get_msg(user, "تم تحديث كلمة المرور بنجاح", "Password updated successfully")}

# #     except HTTPException:
# #         raise
# #     except Exception as e:
# #         db.rollback()
# #         raise HTTPException(status_code=500, detail=get_msg(user, "حدث خطأ أثناء تحديث كلمة المرور", "Error updating password"))


# from fastapi import APIRouter, Depends, HTTPException, status
# from sqlalchemy.orm import Session
# from sqlalchemy import text
# from pydantic import BaseModel, EmailStr
# from passlib.context import CryptContext
# from datetime import datetime, timedelta, timezone
# import random
# import smtplib
# from email.mime.text import MIMEText
# from email.mime.multipart import MIMEMultipart
# from deep_translator import GoogleTranslator

# from db.database import get_db
# from models.users import User, VerificationCode
# from models.profiles import Student  

# from fastapi_mail import MessageSchema, FastMail, ConnectionConfig
# router = APIRouter(prefix="/settings", tags=["Settings"])
# pwd_ctx = CryptContext(schemes=["bcrypt"], deprecated="auto")

# # ── إعدادات بريد النظام ────────────────────────────────────────────────────────
# SMTP_SERVER = "smtp.sendgrid.net"
# SMTP_PORT = 587
# SMTP_USERNAME = "apikey"
# SENDER_EMAIL = "aryjth953@gmail.com"
# SENDER_PASSWORD = "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"

# conf = ConnectionConfig(
#     MAIL_USERNAME="apikey", 
#     MAIL_PASSWORD="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", 
#     MAIL_FROM="aryjth953@gmail.com", 
#     MAIL_FROM_NAME="Intelligent Grading System",
#     MAIL_PORT=587,             
#     MAIL_SERVER="smtp.sendgrid.net", 
#     MAIL_STARTTLS=True,        
#     MAIL_SSL_TLS=False,         
#     USE_CREDENTIALS=True,
#     VALIDATE_CERTS=True
# )

# # ══════════════════════════════════════════════════════════════════════════════
# # النماذج (Schemas)
# # ══════════════════════════════════════════════════════════════════════════════

# class ForgotPasswordSendOtp(BaseModel):
#     user_id: int

# class ForgotPasswordVerifyOtp(BaseModel):
#     user_id: int
#     otp_code: str

# class ForgotPasswordReset(BaseModel):
#     user_id: int
#     otp_code: str
#     new_password: str

# class ProfileResponse(BaseModel):
#     user_id: int 
#     full_name: str
#     email: str
#     phone_number: str | None
#     level_name: str | None
#     department_name: str | None
#     last_password_change: str | None
#     language_code: str | None  
#     is_dark_mode: bool | None  
#     full_name_en: str | None
#     level_name_en: str | None
#     department_name_en: str | None

# class SendEmailOtpRequest(BaseModel):
#     user_id: int  

# class VerifyEmailOtpRequest(BaseModel):
#     user_id: int  
#     new_email: EmailStr
#     otp_code: str

# class UpdateProfileRequest(BaseModel):
#     user_id: int
#     full_name: str

# class ChangePasswordRequest(BaseModel):
#     user_id: int
#     old_password: str
#     new_password: str
#     confirm_password: str

# class DisplayPreferencesSchema(BaseModel):
#     user_id: int
#     language_code: str
#     is_dark_mode: bool

# # ══════════════════════════════════════════════════════════════════════════════
# # الوظائف المساعدة الذكية
# # ══════════════════════════════════════════════════════════════════════════════

# def get_msg(user: User | None, ar_msg: str, en_msg: str) -> str:
#     lang = user.language_code if user and user.language_code else "ar"
#     return en_msg if lang == "en" else ar_msg

# def auto_translate_profile(profile_dict: dict, target_lang: str) -> dict:
#     profile_dict["full_name_en"] = profile_dict.get("full_name")
#     profile_dict["level_name_en"] = profile_dict.get("level_name")
#     profile_dict["department_name_en"] = profile_dict.get("department_name")

#     fields_to_translate = ["level_name", "department_name"]
#     for key in fields_to_translate:
#         value = profile_dict.get(key)
#         if value and isinstance(value, str):
#             try:
#                 profile_dict[f"{key}_en"] = GoogleTranslator(source='ar', target='en').translate(value)
#             except Exception as e:
#                 print(f"⚠️ خطأ غير مؤثر في ترجمة {key}: {e}")
                    
#     return profile_dict

# def send_security_otp(receiver_email: str, otp_code: str, purpose_ar: str, purpose_en: str, lang: str):
#     try:
#         is_en = (lang == "en")
#         purpose = purpose_en if is_en else purpose_ar
#         subject = f"Security Code: {purpose}" if is_en else f"رمز أمان: {purpose}"
#         title = "Security Alert" if is_en else "تنبيه أمني من نظام التصحيح"
#         p1 = f"We received a request to <b>{purpose}</b>." if is_en else f"لقد تلقينا طلباً لـ <b>{purpose}</b>."
#         p2 = "Your verification code is:" if is_en else "رمز التحقق الخاص بك هو:"
#         dir_attr = "ltr" if is_en else "rtl"
#         align = "left" if is_en else "right"

#         msg = MIMEMultipart()
#         msg['From'] = SENDER_EMAIL 
#         msg['To'] = receiver_email
#         msg['Subject'] = subject
        
#         body = f"""
#         <div dir="{dir_attr}" style="font-family: Arial, sans-serif; padding: 20px; text-align: {align}; border: 1px solid #ddd; border-radius: 10px;">
#             <h2 style="color: #c0392b;">{title}</h2>
#             <p>{p1}</p>
#             <p>{p2}</p>
#             <div style="background: #f4f4f4; padding: 15px; text-align: center; font-size: 26px; font-weight: bold;">
#                 {otp_code}
#             </div>
#         </div>
#         """
#         msg.attach(MIMEText(body, 'html'))
        
#         with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
#             server.starttls()
#             server.login(SMTP_USERNAME, SENDER_PASSWORD) 
#             server.send_message(msg)
#         return True
#     except Exception as e:
#         print(f"SMTP Error: {e}")
#         return False

# # ══════════════════════════════════════════════════════════════════════════════
# # العمليات (Endpoints)
# # ══════════════════════════════════════════════════════════════════════════════

# @router.get("/profile/{student_id}", response_model=ProfileResponse)
# def get_profile(student_id: int, db: Session = Depends(get_db)):
#     # 🌟 التعديل السحري هنا: يقبل user_id أو student_id بأمان
#     query = text("""
#         SELECT s.student_id AS user_id, u.full_name, u.email, u.phone_number, 
#                l.level_name, d.department_name, u.language_code, u.is_dark_mode,
#                CAST(u.last_password_change AS TEXT) AS last_password_change
#         FROM student s
#         JOIN users u ON s.user_id = u.user_id
#         LEFT JOIN level l ON s.level_id = l.level_id
#         LEFT JOIN department d ON s.department_id = d.department_id
#         WHERE s.student_id = :sid OR s.user_id = :sid
#     """)
#     result = db.execute(query, {"sid": student_id}).mappings().first()
#     if not result:
#         raise HTTPException(status_code=404, detail="بيانات الطالب غير موجودة / Student data not found")
        
#     profile_data = dict(result)
#     user_lang = profile_data.get("language_code", "ar")
#     final_data = auto_translate_profile(profile_data, user_lang)
#     return final_data

# @router.post("/send-email-otp")
# def send_email_otp(body: SendEmailOtpRequest, db: Session = Depends(get_db)):
#     # 🌟 التعديل السحري للبحث
#     student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
#     user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

#     if not student:
#         raise HTTPException(status_code=404, detail=get_msg(user, "الطالب غير موجود", "Student not found"))
#     if not user:
#         raise HTTPException(status_code=404, detail=get_msg(user, "المستخدم غير موجود", "User not found"))

#     otp = str(random.randint(100000, 999999))
#     expiry = datetime.now(timezone.utc) + timedelta(minutes=10)

#     db.query(VerificationCode).filter(VerificationCode.user_id == user.user_id).delete()
    
#     new_code = VerificationCode(
#         user_id=user.user_id, 
#         otp_code=otp,
#         expiry_time=expiry,
#         is_used=False
#     )
#     db.add(new_code)
    
#     lang = user.language_code if user.language_code else "ar"
#     if send_security_otp(user.email, otp, "تغيير البريد الإلكتروني", "Change Email", lang):
#         db.commit()
#         return {"message": get_msg(user, "تم إرسال الكود إلى بريدك", "Code sent to your email")}
#     else:
#         db.rollback()
#         raise HTTPException(status_code=500, detail=get_msg(user, "فشل في إرسال البريد", "Failed to send email"))

# @router.post("/verify-email-otp")
# def verify_email_otp(body: VerifyEmailOtpRequest, db: Session = Depends(get_db)):
#     student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
#     user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

#     if not student or not user:
#         raise HTTPException(status_code=404, detail="Student/User not found")

#     record = db.query(VerificationCode).filter(
#         VerificationCode.user_id == user.user_id,
#         VerificationCode.otp_code == body.otp_code,
#         VerificationCode.is_used == False
#     ).first()

#     if record is None:
#         raise HTTPException(status_code=400, detail=get_msg(user, "الرمز غير صحيح", "Invalid OTP"))

#     try:
#         user.email = body.new_email
#         record.is_used = True
#         db.commit()
#         return {"message": get_msg(user, "تم تحديث البريد بنجاح", "Email updated successfully")}
#     except Exception as e:
#         db.rollback()
#         raise HTTPException(status_code=500, detail=get_msg(user, "فشل تحديث قاعدة البيانات", "Database update failed"))

# @router.put("/change-password")
# def change_password(body: ChangePasswordRequest, db: Session = Depends(get_db)):
#     try:
#         student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
#         user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

#         if not student:
#             raise HTTPException(status_code=404, detail=get_msg(user, "الطالب غير موجود", "Student not found"))
#         if not user:
#             raise HTTPException(status_code=404, detail=get_msg(user, "المستخدم غير موجود", "User not found"))

#         try:
#             is_valid_password = pwd_ctx.verify(body.old_password, user.password)
#         except ValueError:
#             is_valid_password = (user.password == body.old_password)

#         if not is_valid_password:
#             raise HTTPException(status_code=400, detail=get_msg(user, "كلمة المرور الحالية غير صحيحة", "Current password is incorrect"))

#         if body.old_password == body.new_password:
#             raise HTTPException(status_code=400, detail=get_msg(user, "كلمة المرور الجديدة يجب أن تكون مختلفة", "New password must be different"))

#         if body.new_password != body.confirm_password:
#             raise HTTPException(status_code=400, detail=get_msg(user, "كلمة المرور الجديدة غير متطابقة", "Passwords do not match"))

#         user.password = pwd_ctx.hash(body.new_password[:72])
#         user.last_password_change = datetime.now()
#         db.commit()

#         return {"message": get_msg(user, "تم تغيير كلمة المرور بنجاح", "Password changed successfully")}

#     except HTTPException:
#         raise 
#     except Exception as e:
#         db.rollback()
#         raise HTTPException(status_code=500, detail=get_msg(user, "حدث خطأ، حاول لاحقاً", "System error, try again later"))

# @router.put("/update-display-preferences")
# def update_preferences(body: DisplayPreferencesSchema, db: Session = Depends(get_db)):
#     student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
#     if not student:
#         raise HTTPException(status_code=404, detail="Student not found")
        
#     user = db.query(User).filter(User.user_id == student.user_id).first()
#     if not user:
#         raise HTTPException(status_code=404, detail="User not found")
    
#     user.language_code = body.language_code
#     user.is_dark_mode = body.is_dark_mode
    
#     db.commit()
#     db.refresh(user)
#     return {"message": "Preferences updated successfully"}

# @router.get("/display-preferences/{student_id}")
# def get_display_preferences(student_id: int, db: Session = Depends(get_db)):
#     student = db.query(Student).filter((Student.student_id == student_id) | (Student.user_id == student_id)).first()
#     if not student:
#         raise HTTPException(status_code=404, detail="Student not found")

#     user = db.query(User).filter(User.user_id == student.user_id).first()
#     if not user:
#         raise HTTPException(status_code=404, detail="User not found")

#     return {
#         "language_code": user.language_code or "ar",
#         "is_dark_mode": user.is_dark_mode or False
#     }

# @router.post("/forgot-password/send-otp")
# async def settings_forgot_password_send_otp(body: ForgotPasswordSendOtp, db: Session = Depends(get_db)):
#     try:
#         student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
#         user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

#         if not student:
#             raise HTTPException(status_code=404, detail=get_msg(user, "الطالب غير موجود", "Student not found"))
        
#         otp = str(random.randint(100000, 999999))
#         expiry = datetime.now(timezone.utc) + timedelta(minutes=10)

#         db.query(VerificationCode).filter(VerificationCode.user_id == user.user_id).delete()
        
#         new_code = VerificationCode(
#             user_id=user.user_id,
#             otp_code=otp,
#             expiry_time=expiry,
#             is_used=False
#         )
#         db.add(new_code)
        
#         lang = user.language_code if user and user.language_code else "ar"
#         subject = "Password Reset" if lang == "en" else "استعادة كلمة المرور"
#         body_text = f"Your password reset OTP is: {otp}\nValid for 10 minutes." if lang == "en" else f"رمز التحقق الخاص باستعادة كلمة المرور هو: {otp}\nالرمز صالح لمدة 10 دقائق."

#         message = MessageSchema(
#             subject=subject, 
#             recipients=[user.email], 
#             body=body_text, 
#             subtype="plain"
#         )
#         fm = FastMail(conf)
#         await fm.send_message(message)
        
#         db.commit()
#         return {"message": get_msg(user, "تم إرسال رمز الاستعادة بنجاح", "Password reset OTP sent successfully")}
        
#     except HTTPException:
#         raise
#     except Exception as e:
#         db.rollback()
#         raise HTTPException(status_code=500, detail=get_msg(user, "فشل إرسال البريد الإلكتروني", "Failed to send email"))

# @router.post("/forgot-password/verify-otp")
# def settings_forgot_password_verify_otp(body: ForgotPasswordVerifyOtp, db: Session = Depends(get_db)):
#     try:
#         student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
#         user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

#         if not user:
#             raise HTTPException(status_code=404, detail="User not found")

#         record = db.query(VerificationCode).filter(
#             VerificationCode.user_id == user.user_id,
#             VerificationCode.otp_code == body.otp_code,
#             VerificationCode.is_used == False
#         ).first()

#         if record is None:
#             raise HTTPException(status_code=400, detail=get_msg(user, "الرمز غير صحيح أو منتهي الصلاحية", "Invalid or expired OTP code"))
            
#         return {"message": get_msg(user, "الرمز صحيح", "OTP is valid")}
        
#     except HTTPException:
#         raise
#     except Exception as e:
#         raise HTTPException(status_code=500, detail="System error, please try again later")

# @router.post("/forgot-password/reset")
# def settings_forgot_password_reset(body: ForgotPasswordReset, db: Session = Depends(get_db)):
#     try:
#         student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
#         user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

#         if not user:
#             raise HTTPException(status_code=404, detail="User not found")

#         record = db.query(VerificationCode).filter(
#             VerificationCode.user_id == user.user_id,
#             VerificationCode.otp_code == body.otp_code,
#             VerificationCode.is_used == False
#         ).first()

#         if record is None:
#             raise HTTPException(status_code=400, detail=get_msg(user, "الرمز غير صالح أو منتهي الصلاحية", "Invalid or expired OTP code"))

#         user.password = pwd_ctx.hash(body.new_password[:72])
#         user.last_password_change = datetime.now()
        
#         record.is_used = True
#         db.commit()

#         return {"message": get_msg(user, "تم تحديث كلمة المرور بنجاح", "Password updated successfully")}

#     except HTTPException:
#         raise
#     except Exception as e:
#         db.rollback()
#         raise HTTPException(status_code=500, detail=get_msg(user, "حدث خطأ أثناء تحديث كلمة المرور", "Error updating password"))

import os
import httpx
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import text
from pydantic import BaseModel, EmailStr
from passlib.context import CryptContext
from datetime import datetime, timedelta, timezone
import random
from deep_translator import GoogleTranslator

from db.database import get_db
from models.users import User, VerificationCode
from models.profiles import Student  

router = APIRouter(prefix="/settings", tags=["Settings"])
pwd_ctx = CryptContext(schemes=["bcrypt"], deprecated="auto")

# ══════════════════════════════════════════════════════════════════════════════
# النماذج (Schemas)
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
    phone_number: str | None
    level_name: str | None
    department_name: str | None
    last_password_change: str | None
    language_code: str | None  
    is_dark_mode: bool | None  
    full_name_en: str | None
    level_name_en: str | None
    department_name_en: str | None

class SendEmailOtpRequest(BaseModel):
    user_id: int  

class VerifyEmailOtpRequest(BaseModel):
    user_id: int  
    new_email: EmailStr
    otp_code: str

class UpdateProfileRequest(BaseModel):
    user_id: int
    full_name: str

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
# الوظائف المساعدة الذكية
# ══════════════════════════════════════════════════════════════════════════════

def get_msg(lang: str, ar_msg: str, en_msg: str) -> str:
    return en_msg if lang == "en" else ar_msg

def auto_translate_profile(profile_dict: dict, target_lang: str) -> dict:
    profile_dict["full_name_en"] = profile_dict.get("full_name")
    profile_dict["level_name_en"] = profile_dict.get("level_name")
    profile_dict["department_name_en"] = profile_dict.get("department_name")

    fields_to_translate = ["level_name", "department_name"]
    for key in fields_to_translate:
        value = profile_dict.get(key)
        if value and isinstance(value, str):
            try:
                profile_dict[f"{key}_en"] = GoogleTranslator(source='ar', target='en').translate(value)
            except Exception as e:
                print(f"⚠️ خطأ غير مؤثر في ترجمة {key}: {e}")
                    
    return profile_dict

# 🌟 تحديث الدالة لترسل عبر SendGrid API بدلاً من smtplib
async def send_security_otp(receiver_email: str, otp_code: str, purpose_ar: str, purpose_en: str, lang: str):
    try:
        is_en = (lang == "en")
        purpose = purpose_en if is_en else purpose_ar
        subject = f"Security Code: {purpose}" if is_en else f"رمز أمان: {purpose}"
        title = "Security Alert" if is_en else "تنبيه أمني من نظام التصحيح"
        p1 = f"We received a request to <b>{purpose}</b>." if is_en else f"لقد تلقينا طلباً لـ <b>{purpose}</b>."
        p2 = "Your verification code is:" if is_en else "رمز التحقق الخاص بك هو:"
        dir_attr = "ltr" if is_en else "rtl"
        align = "left" if is_en else "right"

        body_html = f"""
        <div dir="{dir_attr}" style="font-family: Arial, sans-serif; padding: 20px; text-align: {align}; border: 1px solid #ddd; border-radius: 10px;">
            <h2 style="color: #c0392b;">{title}</h2>
            <p>{p1}</p>
            <p>{p2}</p>
            <div style="background: #f4f4f4; padding: 15px; text-align: center; font-size: 26px; font-weight: bold;">
                {otp_code}
            </div>
        </div>
        """

        sendgrid_key = os.environ.get("SENDGRID_API_KEY")
        sender_email = os.environ.get("OTP_EMAIL")

        payload = {
            "personalizations": [{"to": [{"email": receiver_email}]}],
            "from": {"email": sender_email, "name": "Intelligent Grading System"},
            "subject": subject,
            "content": [{"type": "text/html", "value": body_html}]
        }
        
        headers = {
            "Authorization": f"Bearer {sendgrid_key}",
            "Content-Type": "application/json"
        }

        async with httpx.AsyncClient() as client:
            response = await client.post("https://api.sendgrid.com/v3/mail/send", json=payload, headers=headers)
            if response.status_code not in (200, 202):
                print(f"🔴 SendGrid API Error: {response.text}")
                return False
        return True
    except Exception as e:
        print(f"🔴 SendGrid Network Error: {e}")
        return False

# ══════════════════════════════════════════════════════════════════════════════
# العمليات (Endpoints)
# ══════════════════════════════════════════════════════════════════════════════

@router.get("/profile/{student_id}", response_model=ProfileResponse)
def get_profile(student_id: int, lang: str = "ar", db: Session = Depends(get_db)):
    query = text("""
        SELECT s.student_id AS user_id, u.full_name, u.email, u.phone_number, 
               l.level_name, d.department_name, u.language_code, u.is_dark_mode,
               CAST(u.last_password_change AS TEXT) AS last_password_change
        FROM student s
        JOIN users u ON s.user_id = u.user_id
        LEFT JOIN level l ON s.level_id = l.level_id
        LEFT JOIN department d ON s.department_id = d.department_id
        WHERE s.student_id = :sid OR s.user_id = :sid
    """)
    result = db.execute(query, {"sid": student_id}).mappings().first()
    if not result:
        raise HTTPException(status_code=404, detail=get_msg(lang, "بيانات الطالب غير موجودة", "Student data not found"))
        
    profile_data = dict(result)
    final_data = auto_translate_profile(profile_data, lang)
    return final_data

# 🌟 تعديل هنا: إضافة async لأننا نستخدم دالة الإرسال الجديدة
@router.post("/send-email-otp")
async def send_email_otp(body: SendEmailOtpRequest, lang: str = "ar", db: Session = Depends(get_db)):
    student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
    user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

    if not student:
        raise HTTPException(status_code=404, detail=get_msg(lang, "الطالب غير موجود", "Student not found"))
    if not user:
        raise HTTPException(status_code=404, detail=get_msg(lang, "المستخدم غير موجود", "User not found"))

    otp = str(random.randint(100000, 999999))
    expiry = datetime.now(timezone.utc) + timedelta(minutes=10)

    db.query(VerificationCode).filter(VerificationCode.user_id == user.user_id).delete()
    
    new_code = VerificationCode(
        user_id=user.user_id, 
        otp_code=otp,
        expiry_time=expiry,
        is_used=False
    )
    db.add(new_code)
    
    # انتظار (await) إرسال الإيميل
    is_sent = await send_security_otp(user.email, otp, "تغيير البريد الإلكتروني", "Change Email", lang)
    
    if is_sent:
        db.commit()
        return {"message": get_msg(lang, "تم إرسال الكود إلى بريدك", "Code sent to your email")}
    else:
        db.rollback()
        raise HTTPException(status_code=500, detail=get_msg(lang, "فشل في إرسال البريد", "Failed to send email"))

@router.post("/verify-email-otp")
def verify_email_otp(body: VerifyEmailOtpRequest, lang: str = "ar", db: Session = Depends(get_db)):
    # 1. جلب بيانات الطالب الحالي
    student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
    user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

    if not student or not user:
        raise HTTPException(status_code=404, detail="Student/User not found")

    # تنظيف الإيميل الجديد المدخل (لضمان دقة البحث)
    clean_new_email = body.new_email.strip().lower()

    # 🌟 [الإضافة الجديدة 1] التحقق: هل الإيميل الجديد هو نفس الإيميل الحالي للطالب؟
    if user.email.lower() == clean_new_email:
        raise HTTPException(
            status_code=400, 
            detail=get_msg(lang, "هذا هو بريدك الإلكتروني الحالي بالفعل", "This is already your current email")
        )

    # 🌟 [الإضافة الجديدة 2] التحقق: هل الإيميل مسجل مسبقاً لحساب آخر في قاعدة البيانات؟
    existing_user = db.query(User).filter(User.email == clean_new_email).first()
    if existing_user:
        raise HTTPException(
            status_code=400, 
            detail=get_msg(lang, "هذا البريد الإلكتروني مستخدم لحساب آخر", "This email is already in use by another account")
        )

    # 2. التحقق من صحة الرمز (OTP)
    record = db.query(VerificationCode).filter(
        VerificationCode.user_id == user.user_id,
        VerificationCode.otp_code == body.otp_code,
        VerificationCode.is_used == False
    ).first()

    if record is None:
        raise HTTPException(status_code=400, detail=get_msg(lang, "الرمز غير صحيح أو منتهي الصلاحية", "Invalid or expired OTP"))

    # 3. تحديث الإيميل بعد اجتياز كل الفحوصات الأمنية
    try:
        user.email = clean_new_email
        record.is_used = True
        db.commit()
        return {"message": get_msg(lang, "تم تحديث البريد بنجاح", "Email updated successfully")}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=get_msg(lang, "فشل تحديث قاعدة البيانات", "Database update failed"))

@router.put("/change-password")
def change_password(body: ChangePasswordRequest, lang: str = "ar", db: Session = Depends(get_db)):
    try:
        student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
        user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

        if not student:
            raise HTTPException(status_code=404, detail=get_msg(lang, "الطالب غير موجود", "Student not found"))
        if not user:
            raise HTTPException(status_code=404, detail=get_msg(lang, "المستخدم غير موجود", "User not found"))

        try:
            is_valid_password = pwd_ctx.verify(body.old_password, user.password)
        except ValueError:
            is_valid_password = (user.password == body.old_password)

        if not is_valid_password:
            raise HTTPException(status_code=400, detail=get_msg(lang, "كلمة المرور الحالية غير صحيحة", "Current password is incorrect"))

        if body.old_password == body.new_password:
            raise HTTPException(status_code=400, detail=get_msg(lang, "كلمة المرور الجديدة يجب أن تكون مختلفة", "New password must be different"))

        if body.new_password != body.confirm_password:
            raise HTTPException(status_code=400, detail=get_msg(lang, "كلمة المرور الجديدة غير متطابقة", "Passwords do not match"))

        user.password = pwd_ctx.hash(body.new_password[:72])
        user.last_password_change = datetime.now()
        db.commit()

        return {"message": get_msg(lang, "تم تغيير كلمة المرور بنجاح", "Password changed successfully")}

    except HTTPException:
        raise 
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=get_msg(lang, "حدث خطأ، حاول لاحقاً", "System error, try again later"))

@router.put("/update-display-preferences")
def update_preferences(body: DisplayPreferencesSchema, db: Session = Depends(get_db)):
    student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
        
    user = db.query(User).filter(User.user_id == student.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    user.language_code = body.language_code
    user.is_dark_mode = body.is_dark_mode
    
    db.commit()
    db.refresh(user)
    return {"message": "Preferences updated successfully"}

@router.get("/display-preferences/{student_id}")
def get_display_preferences(student_id: int, db: Session = Depends(get_db)):
    student = db.query(Student).filter((Student.student_id == student_id) | (Student.user_id == student_id)).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    user = db.query(User).filter(User.user_id == student.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    return {
        "language_code": user.language_code or "ar",
        "is_dark_mode": user.is_dark_mode or False
    }

# 🌟 تحديث هنا لترسل الإيميل عبر SendGrid API
@router.post("/forgot-password/send-otp")
async def settings_forgot_password_send_otp(body: ForgotPasswordSendOtp, lang: str = "ar", db: Session = Depends(get_db)):
    try:
        student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
        user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

        if not student or not user:
            raise HTTPException(status_code=404, detail="Student/User not found" if lang == "en" else "الطالب غير موجود")
        
        otp = str(random.randint(100000, 999999))
        expiry = datetime.now(timezone.utc) + timedelta(minutes=10)

        db.query(VerificationCode).filter(VerificationCode.user_id == user.user_id).delete()
        
        new_code = VerificationCode(
            user_id=user.user_id,
            otp_code=otp,
            expiry_time=expiry,
            is_used=False
        )
        db.add(new_code)
        
        subject = "Password Reset" if lang == "en" else "استعادة كلمة المرور"
        body_text = f"Your password reset OTP is: {otp}\nValid for 10 minutes." if lang == "en" else f"رمز التحقق الخاص باستعادة كلمة المرور هو: {otp}\nالرمز صالح لمدة 10 دقائق."

        sendgrid_key = os.environ.get("SENDGRID_API_KEY")
        sender_email = os.environ.get("OTP_EMAIL")

        payload = {
            "personalizations": [{"to": [{"email": user.email}]}],
            "from": {"email": sender_email, "name": "Intelligent Grading System"},
            "subject": subject,
            "content": [{"type": "text/plain", "value": body_text}]
        }
        
        headers = {
            "Authorization": f"Bearer {sendgrid_key}",
            "Content-Type": "application/json"
        }

        async with httpx.AsyncClient() as client:
            response = await client.post("https://api.sendgrid.com/v3/mail/send", json=payload, headers=headers)
            if response.status_code not in (200, 202):
                raise Exception(f"فشل الإرسال من السيرفر: {response.text}")
        
        db.commit()
        return {"message": get_msg(lang, "تم إرسال رمز الاستعادة بنجاح", "Password reset OTP sent successfully")}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        print(f"🔴 SendGrid API Error: {e}")
        raise HTTPException(status_code=500, detail=get_msg(lang, "فشل إرسال البريد الإلكتروني", "Failed to send email"))

@router.post("/forgot-password/verify-otp")
def settings_forgot_password_verify_otp(body: ForgotPasswordVerifyOtp, lang: str = "ar", db: Session = Depends(get_db)):
    try:
        student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
        user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        record = db.query(VerificationCode).filter(
            VerificationCode.user_id == user.user_id,
            VerificationCode.otp_code == body.otp_code,
            VerificationCode.is_used == False
        ).first()

        if record is None:
            raise HTTPException(status_code=400, detail=get_msg(lang, "الرمز غير صحيح أو منتهي الصلاحية", "Invalid or expired OTP code"))
            
        return {"message": get_msg(lang, "الرمز صحيح", "OTP is valid")}
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail="System error, please try again later" if lang == "en" else "خطأ في النظام، يرجى المحاولة لاحقاً")

@router.post("/forgot-password/reset")
def settings_forgot_password_reset(body: ForgotPasswordReset, lang: str = "ar", db: Session = Depends(get_db)):
    try:
        student = db.query(Student).filter((Student.student_id == body.user_id) | (Student.user_id == body.user_id)).first()
        user = db.query(User).filter(User.user_id == student.user_id).first() if student else None

        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        record = db.query(VerificationCode).filter(
            VerificationCode.user_id == user.user_id,
            VerificationCode.otp_code == body.otp_code,
            VerificationCode.is_used == False
        ).first()

        if record is None:
            raise HTTPException(status_code=400, detail=get_msg(lang, "الرمز غير صالح أو منتهي الصلاحية", "Invalid or expired OTP code"))

        user.password = pwd_ctx.hash(body.new_password[:72])
        user.last_password_change = datetime.now()
        
        record.is_used = True
        db.commit()

        return {"message": get_msg(lang, "تم تحديث كلمة المرور بنجاح", "Password updated successfully")}

    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=get_msg(lang, "حدث خطأ أثناء تحديث كلمة المرور", "Error updating password"))