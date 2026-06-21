# # from fastapi import FastAPI
# # from fastapi.middleware.cors import CORSMiddleware
# # from routers.settings_router import router as settings_router
# # from fastapi import APIRouter, Depends, Query, HTTPException
# # from sqlalchemy.orm import Session
# # from routers import exam_creation
# # from routers import exam

# # from routers import teacher_matearial  # تأكدي إن اسم المجلد والملف مطابق للي عندك

# # # استدعاء كل الأبواب (الروابط) اللي سويناها في مجلد routers
# # from routers import exams, grading, auth, academic, views, users
# # from crud import pdf# (عدلي مسار واسم الملف حسب اللي عندك)
# # # from db import get_db
# # from fastapi.staticfiles import StaticFiles

# # app = FastAPI(
# #     title="Smart Grader API",
# #     description="Backend for Intelligent Exam Grading System",
# #     version="1.0.0"
# # )
# # # هذا السطر يفتح مجلد static ويسمح للفلاتر يسحب الصور منه
# # app.mount("/static", StaticFiles(directory="static"), name="static")
# # # إعدادات الـ CORS (عشان تطبيق الفلاتر يقدر يكلم السيرفر براحته)
# # app.add_middleware(
# #     CORSMiddleware,
# #     allow_origins=["*"],
# #     allow_credentials=True,
# #     allow_methods=["*"],
# #     allow_headers=["*"],
# # )

# # # تركيب الأبواب في العمارة
# # app.include_router(auth.router)
# # app.include_router(users.router) # هذا اللي كان ناقص!
# # app.include_router(academic.router)
# # app.include_router(exams.router)
# # app.include_router(grading.router)
# # app.include_router(views.router)
# # app.include_router(settings_router)
# # app.include_router(pdf.router)
# # app.include_router(exam_creation.router)
# # app.include_router(teacher_matearial.router)
# # app.include_router(exam.router)


# # # الرابط الرئيسي للتأكد من عمل السيرفر
# # @app.get("/")
# # def home():
# #     return {"message": "Welcome to Smart Grader Backend! 🚀"}


# # # ── تأكدي إن هذي الاستدعاءات موجودة فوق في بداية ملف main.py ──
# # import smtplib
# # from email.mime.text import MIMEText
# # from email.mime.multipart import MIMEMultipart
# # from pydantic import BaseModel
# # from fastapi import BackgroundTasks, Depends
# # from sqlalchemy.orm import Session
# # from sqlalchemy import text
# # # تأكدي إن استدعاء get_db صحيح حسب مساره عندك
# # from db.database import get_db 

# # # ══════════════════════════════════════════════════════════════════════════════
# # # 🔴 إعدادات الـ Webhooks وإرسال الإشعارات
# # # ══════════════════════════════════════════════════════════════════════════════

# # # ── 1. نموذج استلام البيانات من سوبابيس ──
# # class SupabaseWebhookPayload(BaseModel):
# #     type: str
# #     table: str
# #     record: dict
# #     old_record: dict = None

# # # ── 2. دالة إرسال الإيميل الحقيقية (تدعم اللغتين 🌍) ──
# # # 🔴 التعديل: أضفنا متغير lang
# # def send_email_task(student_email: str, student_name: str, exam_title: str, lang: str):
# #     SMTP_SERVER = "smtp.gmail.com"
# #     SMTP_PORT = 587
# #     SENDER_EMAIL = "GradeAi@gmail.com"  
# #     SENDER_PASSWORD = "qmor nlvq lhre appp"          

# #     try:
# #         msg = MIMEMultipart("alternative")
# #         msg["From"] = SENDER_EMAIL
# #         msg["To"] = student_email

# #         # 🔴 التعديل: تجهيز المحتوى بناءً على لغة الطالب
# #         if lang == "en":
# #             msg["Subject"] = f"Exam Grade Approved: {exam_title}"
# #             html_content = f"""
# #             <div dir="ltr" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e5e7eb; border-radius: 8px;">
# #                 <h2 style="color: #4FB7B5; text-align: center;">Intelligent Grading System</h2>
# #                 <p>Hello <strong>{student_name}</strong>,</p>
# #                 <p>Your exam grade for <strong style="color: #4FB7B5;">{exam_title}</strong> has been approved.</p>
# #                 <p>You can now log in to the platform to view your detailed report.</p>
# #             </div>
# #             """
# #         else:
# #             # افتراضياً عربي
# #             msg["Subject"] = f"اعتماد نتيجة اختبار: {exam_title}"
# #             html_content = f"""
# #             <div dir="rtl" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e5e7eb; border-radius: 8px;">
# #                 <h2 style="color: #4FB7B5; text-align: center;">نظام التصحيح الذكي</h2>
# #                 <p>مرحباً يا <strong>{student_name}</strong>،</p>
# #                 <p>تم اعتماد نتيجة اختبارك في مادة: <strong style="color: #4FB7B5;">{exam_title}</strong></p>
# #                 <p>بإمكانك الآن تسجيل الدخول للمنصة لمعاينة التقرير التفصيلي.</p>
# #             </div>
# #             """

# #         msg.attach(MIMEText(html_content, "html", "utf-8"))

# #         server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
# #         server.starttls()
# #         server.login(SENDER_EMAIL, SENDER_PASSWORD)
# #         server.sendmail(SENDER_EMAIL, student_email, msg.as_string())
# #         server.quit()
# #         print(f"✅ تم إرسال الإيميل بنجاح إلى {student_email} باللغة {lang}")
# #     except Exception as e:
# #         print(f"❌ فشل إرسال الإيميل: {e}")

# # # ── 3. الرابط اللي سوبابيس بيتصل عليه ──
# # @app.post("/api/webhook/grade-notification")
# # def handle_grade_webhook(
# #     payload: SupabaseWebhookPayload, 
# #     background_tasks: BackgroundTasks,
# #     db: Session = Depends(get_db)
# # ):
# #     new_data = payload.record
# #     old_data = payload.old_record or {}

# #     new_status = new_data.get("status", "").lower()
# #     old_status = old_data.get("status", "").lower()

# #     if new_status == "graded" and old_status != "graded":
# #         student_id = new_data.get("student_id")
# #         exam_id = new_data.get("exam_id")

# #         if student_id and exam_id:
# #             # 🔴 التعديل: سحبنا u.language_code من الداتا بيس
# #             query = text("""
# #                 SELECT u.email, u.full_name, u.language_code, e.exam_title
# #                 FROM student s
# #                 JOIN users u ON s.user_id = u.user_id
# #                 JOIN exam e ON e.exam_id = :eid
# #                 WHERE s.student_id = :sid
# #             """)
# #             result = db.execute(query, {"sid": student_id, "eid": exam_id}).mappings().first()

# #             if result and result["email"]:
# #                 # 🔴 التعديل: مررنا لغة الطالب لدالة الإيميل (وإذا كانت فارغة نخليها عربي كاحتياط)
# #                 user_lang = result["language_code"] if result["language_code"] else "ar"
                
# #                 background_tasks.add_task(
# #                     send_email_task, 
# #                     student_email=result["email"], 
# #                     student_name=result["full_name"], 
# #                     exam_title=result["exam_title"],
# #                     lang=user_lang
# #                 )

# #     return {"message": "Webhook processed successfully"}



# import smtplib
# from email.mime.text import MIMEText
# from email.mime.multipart import MIMEMultipart

# from fastapi import FastAPI, BackgroundTasks, Depends, APIRouter, Query, HTTPException
# from fastapi.middleware.cors import CORSMiddleware
# from fastapi.staticfiles import StaticFiles
# from pydantic import BaseModel
# from sqlalchemy.orm import Session
# from sqlalchemy import text

# # ── استدعاء قاعدة البيانات ──
# from db.database import get_db 

# # ── استدعاءات الملفات من crud ──
# from crud import pdf

# # ── استدعاء كل الأبواب (الروابط) من مجلد routers ──
# from routers import (
#     exams, grading, auth, academic, views, users,
#     admin_dashboard, exams_router, users_management,
#     add_users, reports, system_log, backup, ai_exam,
#     quiz_details, exam_creation, exam, teacher_matearial
# )
# from routers.users_router import user_router, admin_router
# from routers.settings_router import router as settings_router

# # ==========================================
# # 🚀 إعدادات تطبيق FastAPI
# # ==========================================
# app = FastAPI(
#     title="Smart Grader API",
#     description="Backend for Intelligent Exam Grading System",
#     version="1.0.0"
# )

# # هذا السطر يفتح مجلد static ويسمح للفلاتر بسحب الصور منه
# app.mount("/static", StaticFiles(directory="static"), name="static")

# # إعدادات الـ CORS (عشان تطبيق الفلاتر يقدر يكلم السيرفر براحته)
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# # ==========================================
# # 🚪 تركيب الأبواب (Routers) في العمارة
# # ==========================================
# # الروابط الأساسية والمشتركة
# app.include_router(auth.router)
# app.include_router(academic.router)
# app.include_router(exams.router)
# app.include_router(grading.router)
# app.include_router(views.router)

# # روابط المستخدمين
# app.include_router(users.router)
# app.include_router(user_router)
# app.include_router(admin_router)

# # روابط الإدارة (Admin)
# app.include_router(admin_dashboard.router)
# app.include_router(users_management.router)
# app.include_router(add_users.router)
# app.include_router(reports.router)
# app.include_router(system_log.router)
# app.include_router(backup.router)

# # روابط الاختبارات والمواد (Teacher & Exams)
# app.include_router(exams_router.router)
# app.include_router(ai_exam.router)
# app.include_router(quiz_details.router)
# app.include_router(exam_creation.router)
# app.include_router(exam.router)
# app.include_router(teacher_matearial.router)

# # روابط الإعدادات وملفات الـ PDF
# app.include_router(settings_router)
# app.include_router(pdf.router)


# # ==========================================
# # 🏠 الرابط الرئيسي للتأكد من عمل السيرفر
# # ==========================================
# @app.get("/")
# def home():
#     return {"message": "Welcome to Smart Grader Backend! 🚀"}


# # ==========================================
# # 🔴 إعدادات الـ Webhooks وإرسال الإشعارات
# # ==========================================

# # ── 1. نموذج استلام البيانات من سوبابيس ──
# class SupabaseWebhookPayload(BaseModel):
#     type: str
#     table: str
#     record: dict
#     old_record: dict = None

# # ── 2. دالة إرسال الإيميل الحقيقية (تدعم اللغتين 🌍) ──
# def send_email_task(student_email: str, student_name: str, exam_title: str, lang: str):
#     import os
#     from dotenv import load_dotenv
#     load_dotenv()
    
#     SMTP_SERVER = "smtp.gmail.com"
#     SMTP_PORT = 587
#     SENDER_EMAIL = os.environ.get("SENDER_EMAIL", "")  
#     SENDER_PASSWORD = os.environ.get("SENDER_PASSWORD", "")          

#     try:
#         msg = MIMEMultipart("alternative")
#         msg["From"] = SENDER_EMAIL
#         msg["To"] = student_email

#         # تجهيز المحتوى بناءً على لغة الطالب
#         if lang == "en":
#             msg["Subject"] = f"Exam Grade Approved: {exam_title}"
#             html_content = f"""
#             <div dir="ltr" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e5e7eb; border-radius: 8px;">
#                 <h2 style="color: #4FB7B5; text-align: center;">Intelligent Grading System</h2>
#                 <p>Hello <strong>{student_name}</strong>,</p>
#                 <p>Your exam grade for <strong style="color: #4FB7B5;">{exam_title}</strong> has been approved.</p>
#                 <p>You can now log in to the platform to view your detailed report.</p>
#             </div>
#             """
#         else:
#             # افتراضياً عربي
#             msg["Subject"] = f"اعتماد نتيجة اختبار: {exam_title}"
#             html_content = f"""
#             <div dir="rtl" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e5e7eb; border-radius: 8px;">
#                 <h2 style="color: #4FB7B5; text-align: center;">نظام التصحيح الذكي</h2>
#                 <p>مرحباً يا <strong>{student_name}</strong>،</p>
#                 <p>تم اعتماد نتيجة اختبارك في مادة: <strong style="color: #4FB7B5;">{exam_title}</strong></p>
#                 <p>بإمكانك الآن تسجيل الدخول للمنصة لمعاينة التقرير التفصيلي.</p>
#             </div>
#             """

#         msg.attach(MIMEText(html_content, "html", "utf-8"))

#         server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
#         server.starttls()
#         server.login(SENDER_EMAIL, SENDER_PASSWORD)
#         server.sendmail(SENDER_EMAIL, student_email, msg.as_string())
#         server.quit()
#         print(f"✅ تم إرسال الإيميل بنجاح إلى {student_email} باللغة {lang}")
#     except Exception as e:
#         print(f"❌ فشل إرسال الإيميل: {e}")

# # ── 3. الرابط اللي سوبابيس بيتصل عليه ──
# @app.post("/api/webhook/grade-notification")
# def handle_grade_webhook(
#     payload: SupabaseWebhookPayload, 
#     background_tasks: BackgroundTasks,
#     db: Session = Depends(get_db)
# ):
#     new_data = payload.record
#     old_data = payload.old_record or {}

#     new_status = new_data.get("status", "").lower()
#     old_status = old_data.get("status", "").lower()

#     if new_status == "graded" and old_status != "graded":
#         student_id = new_data.get("student_id")
#         exam_id = new_data.get("exam_id")

#         if student_id and exam_id:
#             # سحبنا u.language_code من الداتا بيس
#             query = text("""
#                 SELECT u.email, u.full_name, u.language_code, e.exam_title
#                 FROM student s
#                 JOIN users u ON s.user_id = u.user_id
#                 JOIN exam e ON e.exam_id = :eid
#                 WHERE s.student_id = :sid
#             """)
#             result = db.execute(query, {"sid": student_id, "eid": exam_id}).mappings().first()

#             if result and result["email"]:
#                 # مررنا لغة الطالب لدالة الإيميل (وإذا كانت فارغة نخليها عربي كاحتياط)
#                 user_lang = result["language_code"] if result["language_code"] else "ar"
                
#                 background_tasks.add_task(
#                     send_email_task, 
#                     student_email=result["email"], 
#                     student_name=result["full_name"], 
#                     exam_title=result["exam_title"],
#                     lang=user_lang
#                 )

#     return {"message": "Webhook processed successfully"}





import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

from fastapi import FastAPI, BackgroundTasks, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from sqlalchemy.orm import Session
from sqlalchemy import text

# ── استدعاء قاعدة البيانات ──
from db.database import get_db 

# ── استدعاءات الملفات من crud ──
from crud import pdf

# ── استدعاء كل الأبواب (الروابط) من مجلد routers ──
from routers import (
    exams, grading, auth, academic, views, users,
    admin_dashboard, exams_router, users_management,
    add_users, reports, system_log, backup, ai_exam,
    quiz_details, exam_creation, exam, teacher_matearial
)
from routers.users_router import user_router, admin_router
from routers.settings_router import router as settings_router

# ==========================================
# 🚀 إعدادات تطبيق FastAPI
# ==========================================
app = FastAPI(
    title="Smart Grader API",
    description="Backend for Intelligent Exam Grading System",
    version="1.0.0"
)

# فتح مجلد static للسماح للفلاتر بسحب الصور
app.mount("/static", StaticFiles(directory="static"), name="static")

# إعدادات الـ CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ==========================================
# 🚪 تركيب الأبواب (Routers) في العمارة
# ==========================================


app.include_router(auth.router)
app.include_router(users.router) # هذا اللي كان ناقص!
app.include_router(academic.router)
app.include_router(exams.router)
app.include_router(grading.router)
app.include_router(views.router)
app.include_router(settings_router)
app.include_router(pdf.router)
app.include_router(exam_creation.router)
app.include_router(teacher_matearial.router)
app.include_router(exam.router)
# الروابط الأساسية والمشتركة
app.include_router(auth.router)
app.include_router(academic.router)
app.include_router(exams.router)
app.include_router(grading.router)
app.include_router(views.router) # 👈 مسارات الطالب اللي رتبناها فوق

# روابط المستخدمين
app.include_router(users.router)
app.include_router(user_router)
app.include_router(admin_router)

# روابط الإدارة (Admin)
app.include_router(admin_dashboard.router)
app.include_router(users_management.router)
app.include_router(add_users.router)
app.include_router(reports.router)
app.include_router(system_log.router)
app.include_router(backup.router)

# روابط الاختبارات والمواد (Teacher & Exams)
app.include_router(exams_router.router)
app.include_router(ai_exam.router)
app.include_router(quiz_details.router)
app.include_router(exam_creation.router)
app.include_router(exam.router)
app.include_router(teacher_matearial.router)

# روابط الإعدادات وملفات الـ PDF
app.include_router(settings_router)
app.include_router(pdf.router)

# ==========================================
# 🏠 الرابط الرئيسي للتأكد من عمل السيرفر
# ==========================================
@app.get("/")
def home():
    return {"message": "Welcome to Smart Grader Backend! 🚀"}

# ==========================================
# 🔴 إعدادات الـ Webhooks وإرسال الإشعارات (شغل صاحبتك)
# ==========================================
class SupabaseWebhookPayload(BaseModel):
    type: str
    table: str
    record: dict
    old_record: dict = None

def send_email_task(student_email: str, student_name: str, exam_title: str, lang: str):
    import os
    from dotenv import load_dotenv
    load_dotenv()
    
    SMTP_SERVER = "smtp.gmail.com"
    SMTP_PORT = 587
    SENDER_EMAIL = os.environ.get("SENDER_EMAIL", "sosytane@gmail.com")  
    SENDER_PASSWORD = os.environ.get("SENDER_PASSWORD", "owxobwtkncijrxzr")          

    try:
        msg = MIMEMultipart("alternative")
        msg["From"] = SENDER_EMAIL
        msg["To"] = student_email

        if lang == "en":
            msg["Subject"] = f"Exam Grade Approved: {exam_title}"
            html_content = f"""
            <div dir="ltr" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e5e7eb; border-radius: 8px;">
                <h2 style="color: #4FB7B5; text-align: center;">Intelligent Grading System</h2>
                <p>Hello <strong>{student_name}</strong>,</p>
                <p>Your exam grade for <strong style="color: #4FB7B5;">{exam_title}</strong> has been approved.</p>
                <p>You can now log in to the platform to view your detailed report.</p>
            </div>
            """
        else:
            msg["Subject"] = f"اعتماد نتيجة اختبار: {exam_title}"
            html_content = f"""
            <div dir="rtl" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e5e7eb; border-radius: 8px;">
                <h2 style="color: #4FB7B5; text-align: center;">نظام التصحيح الذكي</h2>
                <p>مرحباً يا <strong>{student_name}</strong>،</p>
                <p>تم اعتماد نتيجة اختبارك في مادة: <strong style="color: #4FB7B5;">{exam_title}</strong></p>
                <p>بإمكانك الآن تسجيل الدخول للمنصة لمعاينة التقرير التفصيلي.</p>
            </div>
            """

        msg.attach(MIMEText(html_content, "html", "utf-8"))

        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(SENDER_EMAIL, SENDER_PASSWORD)
        server.sendmail(SENDER_EMAIL, student_email, msg.as_string())
        server.quit()
        print(f"✅ تم إرسال الإيميل بنجاح إلى {student_email} باللغة {lang}")
    except Exception as e:
        print(f"❌ فشل إرسال الإيميل: {e}")

@app.post("/api/webhook/grade-notification")
def handle_grade_webhook(
    payload: SupabaseWebhookPayload, 
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db)
):
    print("--- 1. وصل طلب جديد للويب هوك (Webhook Received) ---")
    
    new_data = payload.record
    old_data = payload.old_record or {}
    
    print(f"--- 2. البيانات التي وصلت هي: {new_data} ---")

    # نتحقق من حالة النشر (is_published)
    new_published = new_data.get("is_published")
    old_published = old_data.get("is_published")

    print(f"--- 3. حالة النشر الحالية: {new_published} ---")

    # الشرط: إذا تغيرت من False إلى True
    if new_published is True and (old_published is False or old_published is None):
        print("--- 4. الشرط تحقق! (is_published تحولت لـ True) جاري تجهيز الإيميل ---")
        
        student_id = new_data.get("student_id")
        exam_id = new_data.get("exam_id")

        if student_id and exam_id:
            query = text("""
                SELECT u.email, u.full_name, u.language_code, e.exam_title
                FROM student s
                JOIN users u ON s.user_id = u.user_id
                JOIN exam e ON e.exam_id = :eid
                WHERE s.student_id = :sid
            """)
            result = db.execute(query, {"sid": student_id, "eid": exam_id}).mappings().first()

            if result and result["email"]:
                print(f"--- 5. تم العثور على بيانات الطالب: {result['full_name']} ---")
                user_lang = result["language_code"] if result["language_code"] else "ar"
                
                background_tasks.add_task(
                    send_email_task, 
                    student_email=result["email"], 
                    student_name=result["full_name"], 
                    exam_title=result["exam_title"],
                    lang=user_lang
                )
                print("--- 6. تم إضافة مهمة إرسال الإيميل بنجاح! ---")
            else:
                print("--- ❌ خطأ: لم أجد إيميل الطالب في قاعدة البيانات ---")
        else:
            print("--- ❌ خطأ: الـ student_id أو exam_id مفقودين من البيانات ---")
    else:
        print("--- ⚠️ الشرط لم يتحقق (is_published لم تتحول لـ True) ---")

    return {"message": "Webhook processed successfully"}