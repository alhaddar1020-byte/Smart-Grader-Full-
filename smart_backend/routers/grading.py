# from fastapi import Depends
# from core.security import get_current_user_id
# from fastapi import APIRouter, Depends, HTTPException
# from sqlalchemy.orm import Session
# from db.database import get_db
# from pydantic import BaseModel
# from crud.grading import save_ai_grading

# router = APIRouter(prefix="/grading", tags=["AI Grading (التصحيح الذكي)"], dependencies=[Depends(get_current_user_id)])

# # Schema خاص بهذا الرابط لاستلام بيانات تقرير الذكاء الاصطناعي
# class AIGradingRequest(BaseModel):
#     sheet_id: int
#     total_score: float
#     description: str
#     strengths: str = None
#     weaknesses: str = None

# @router.post("/submit_ai_report")
# def submit_ai_grading(request: AIGradingRequest, db: Session = Depends(get_db)):
#     """
#     هذا الرابط يستلم نتيجة التصحيح من الذكاء الاصطناعي ويحفظ الدرجة والتقرير معاً.
#     """
#     # استدعاء الدالة القوية اللي كتبناها في الـ CRUD
#     success = save_ai_grading(
#         db=db,
#         sheet_id=request.sheet_id,
#         total_score=request.total_score,
#         description=request.description,
#         strengths=request.strengths,
#         weaknesses=request.weaknesses
#     )
    
#     if success:
#         return {"message": "تم حفظ التصحيح الذكي والتقرير بنجاح! 🚀"}
#     else:
#         raise HTTPException(status_code=404, detail="خطأ: ورقة الإجابة غير موجودة في النظام!")

import os  
import shutil
import json
import asyncio     
import random
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, BackgroundTasks
from sqlalchemy.orm import Session
from typing import List
from db.database import get_db
import fitz  # مكتبة PyMuPDF للتعامل مع الـ PDF
from PIL import Image
from google import genai
from openai import OpenAI
from google.genai import types
from datetime import datetime
from dotenv import load_dotenv
import time
from sqlalchemy.orm import Session
from models.grading import StudentAnswer, AnswerSheet
from models.exams import Exam
from models.academic import StudentCourse
from models.exams import Exam, Folder, TeacherCourse
# تفعيل قراءة الـ env داخل هذا الملف لضمان سحب المفتاح حياً
load_dotenv()
# استيراد الموديلات الخاصة بكِ للتصحيح
from models.grading import AnswerSheet, StudentAnswer, SheetImage, ExpectedAnswer, Question
from models.exams import Exam
# 🎯 استيراد موديلات الهوية والملفات الشخصية للربط بالأسماء الحقيقية
from models.profiles import Student
from models.users import User
from difflib import SequenceMatcher
import re
from supabase import create_client
# استبدلي القيم بما يقابلها في إعدادات مشروعك في Supabase (تجدينها في Project Settings -> API)
supabase = create_client(os.getenv("SUPABASE_URL"), os.getenv("SUPABASE_KEY"))
from PIL import Image
def crop_header(image_path):
    """دالة مساعدة لقص الترويسة العلوية للورقة"""
    with Image.open(image_path) as img:
        width, height = img.size
        # قص الجزء العلوي (أول 20% من الورقة)
        header_area = (0, 0, width, int(height * 0.20)) 
        cropped_img = img.crop(header_area)
        # حفظها مؤقتاً
        temp_path = image_path.replace(".png", "_header.png")
        cropped_img.save(temp_path)
        return temp_path

import logging
logger = logging.getLogger("GradingEngine")
router = APIRouter(prefix="/grading", tags=["Grading Engine (محرك التصحيح)"])

# 🎯 إعداد عميل Gemini بسحب المفتاح ديناميكياً من الـ env
# ==========================================
api_key = os.getenv("GEMINI_API_KEY")
client = genai.Client(api_key=api_key)
openai_api_key = os.getenv("OPENAI_API_KEY")
openai_client = OpenAI(api_key=openai_api_key)

async def analyze_and_update_student_progress(db: Session, student_id: int, course_id: int,openai_client):
    try:
        print(f"DEBUG: بداية التحليل للطالب {student_id} في المادة {course_id}")

        # 1. سحب التعليقات (الربط الصحيح عبر Exam -> Folder -> TeacherCourse)
        # ملاحظة: تأكدي من عمل import لـ AnswerSheet, Exam, Folder, TeacherCourse في أعلى الملف
        answers = db.query(StudentAnswer).join(AnswerSheet).join(Exam).join(Folder).join(TeacherCourse).filter(
            AnswerSheet.student_id == student_id,
            TeacherCourse.course_id == course_id 
        ).all()
        
        # تجميع التعليقات
        comments_list = [a.ai_feedback for a in answers if a.ai_feedback]
        if not comments_list:
            print(f"⚠️ لا توجد تعليقات سابقة للطالب {student_id} في مادة {course_id} للتحليل.")
            return

        student_history_variable = "\n".join(comments_list)

        # 2. إعداد الـ Prompt الصارم (تم اختصاره لضمان الاستقرار)
        ai_prompt = f"""
        أنت مستشار أكاديمي، حلل أداء الطالب بناءً على هذه التعليقات:
        {student_history_variable}
        استخرج نقاط القوة ومجالات التحسين.
        شروط: أجب بـ JSON فقط بمفتاحين: "strengths" و "weaknesses".
        اجعل الرد مختصراً جداً.
        """

        # بدلاً من client.models.generate_content_async
        # جربي هذا المسار الذي توفره مكتبة google-genai الحديثة:
        # response = await client.aio.models.generate_content(
        #     # model="gemini-2.5-flash",
        #     model="gpt-4o-mini",
        #     contents=ai_prompt
        # )
        
        # التعديل هنا: نستخدم openai_client الذي تم تمريره
        response = openai_client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": ai_prompt}],
            response_format={ "type": "json_object" }
        )
        
        # استخراج البيانات
        result_data = json.loads(response.choices[0].message.content)

        # 4. تحديث جدول student_courses
        student_course = db.query(StudentCourse).filter(
            StudentCourse.student_id == student_id,
            StudentCourse.course_id == course_id
        ).first()
        # print(f"DEBUG: هل وجدنا السجل في StudentCourse؟ {'نعم' if student_course else 'لا'}")
        # print(f"DEBUG: قيم البحث المستخدمة: student_id={student_id}, course_id={course_id}")
        if student_course:
            student_course.subject_strengths = result_data['strengths']
            student_course.subject_weaknesses = result_data['weaknesses']
            student_course.last_ai_update = datetime.utcnow()
            db.flush() # دفع التغييرات إلى مستوى الـ SQL
            print(f"DEBUG: تم تحديث الكائن في الذاكرة: {student_course.subject_strengths}")
            db.commit()

            db.refresh(student_course) 
            print(f"✅ تم تنفيذ الـ commit بنجاح للطالب {student_id} في الصف رقم (sc_id): {student_course.sc_id}")
            # print(f"🔍 القيمة التي تم حفظها في الداتابيس للطالب 9 هي: {student_course.subject_strengths}")
            print(f"✅ تم تحديث التقرير الأكاديمي للطالب {student_id} بنجاح!")
        else:
            print(f"❌ خطأ: لا يوجد سجل في StudentCourse لـ student_id={student_id} و course_id={course_id}")
        
    except Exception as e:
        print(f"❌ خطأ جسيم أثناء تحليل أداء الطالب: {e}")
        db.rollback()
# async def ai_grading_pipeline(exam_id: int, sheet_id: int, pdf_path: str, db: Session):
#     try:
#         print(f"🎬 بدء معالجة الملف واستخراج الهوية: {pdf_path}")
        
#         # 1. تقطيع الـ PDF وتحويله لصور وحفظه
#         doc = fitz.open(pdf_path)
#         image_paths = []
#         img_dir = f"static/extracted_pages/sheet_{sheet_id}"
#         os.makedirs(img_dir, exist_ok=True)
        
#         for page_num in range(len(doc)):
#             page = doc[page_num]
#             mat = fitz.Matrix(2, 2)
#             pix = page.get_pixmap(matrix=mat)
#             img_path = f"{img_dir}/page_{page_num + 1}.png"
#             pix.save(img_path)
#             db_image = SheetImage(sheet_id=sheet_id, image_path=img_path, page_number=page_num + 1)
#             db.add(db_image)
#             image_paths.append(img_path)
        
#         db.commit()
#         pil_images = [Image.open(p) for p in image_paths]

#         # 🚀 [خطوة الهوية مع إعادة المحاولة]
#         print("🔍 استدعاء Gemini للتعرف على هوية الطالب...")
#         identity_prompt = """
#         اقرأ الترويسة العلوية لصفحة الاختبار المرفقة بعناية، واستخرج 'الرقم الجامعي' المكتوب بخط يد الطالب.
#         النتيجة يجب أن تكون JSON: {"university_id": "الرقم هنا"}
#         """
        
#         extracted_uid = ""
#         success_id = False
#         for attempt in range(3):
#             try:
#                 id_response = client.models.generate_content(
#                     # model="gemini-2.5-flash",
#                     model="gemini-3-flash-preview",
#                     contents=[pil_images[0], identity_prompt],
#                     # config=types.GenerateContentConfig(response_mime_type="application/json",)
#                     config=types.GenerateContentConfig(
#                     response_mime_type="application/json",
#                     temperature=0.0  # 👈 إضافة هذا السطر تجعل إجابات الذكاء الاصطناعي ثابتة ومستقرة
#                     ),
#                 )
#                 id_result = json.loads(id_response.text)
#                 extracted_uid = str(id_result.get("university_id", "")).strip()
#                 success_id = True
#                 break
#             except Exception as e:
#                 if "503" in str(e) and attempt < 2:
#                     time.sleep(3)
#                 else:
#                     print(f"❌ فشل استخراج الهوية: {str(e)}")
#                     break

#         if not success_id:
#             return

#         student_record = db.query(Student).filter(Student.university_id == extracted_uid).first()
#         sheet_to_update = db.query(AnswerSheet).filter(AnswerSheet.sheet_id == sheet_id).first()
        
#         if student_record and sheet_to_update:
#             sheet_to_update.student_id = student_record.student_id 
#             db.commit()
#             user_record = db.query(User).filter(User.user_id == student_record.user_id).first()
#             print(f"✅ تم ربط الورقة بنجاح بالطالب: {user_record.full_name if user_record else 'غير معروف'}")

#         # 3. التصحيح الأكاديمي (تصحيح جماعي بطلب واحد لتوفير الكوتا)
#         questions = db.query(Question).filter(Question.exam_id == exam_id).all()
#         total_final_score = 0.0

        
#         questions_data = []
#         for q in questions:
#             expected = db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id == q.question_id).first()
#             questions_data.append({
#                 "id": q.question_id,
#                 "text": q.question_text,
#                 "mark": float(q.question_mark), # 👈 التعديل هنا: تحويل الدرجة لـ float
#                 "expected": expected.answer_text if expected else ""
#             })
#         # combined_prompt = f"""
#         # أنت مصحح اختبارات خبير. صحح الاختبار التالي بناءً على صور إجابات الطالب المرفقة.
#         # الأسئلة هي: {json.dumps(questions_data)}
#         # أجب بصيغة JSON تحتوي على مفتاح رئيسي يسمى 'answers' وهو قائمة (list) لكل سؤال، 
#         # بحيث يكون لكل عنصر: "question_id", "extracted_text", "ai_mark", "ai_feedback".
#         # """
#         combined_prompt = f"""
#             أنت مصحح اختبارات خبير. صحح الاختبار التالي بناءً على صور إجابات الطالب المرفقة.
#             الأسئلة هي: {json.dumps(questions_data)}
#             شروط صارمة للإجابة:
#             1. أجب بصيغة JSON فقط (بدون أي نصوص إضافية قبل أو بعد الـ JSON).
#             2. المفتاح الرئيسي يجب أن يكون 'answers' وهو قائمة لكل سؤال.
#             3. لكل عنصر في القائمة: "question_id", "extracted_text", "ai_mark", "ai_feedback".
#             4. حقل "ai_feedback" يجب أن يكون مختصراً جداً (بحد أقصى 20 كلمة) ومباشراً، حيث أنني أعاني من قيود في حجم البيانات.
#             """
#         # 3. التصحيح الأكاديمي (تصحيح جماعي مع إعادة محاولة ذكية)
#         success = False
#         for attempt in range(3): # سيحاول النظام حتى 3 مرات
#             try:
#                 response = client.models.generate_content(
#                     # model="gemini-2.5-flash",
#                     model="gemini-3-flash-preview",
#                     contents=pil_images + [combined_prompt],
#                     config=types.GenerateContentConfig(response_mime_type="application/json"),
#                 )
                
#                 ai_data = json.loads(response.text)
                
#                 # معالجة النتائج المحملة من الـ AI
#                 for res in ai_data.get("answers", []):
#                     mark_val = float(res.get("ai_mark", 0.0))
#                     student_answer = StudentAnswer(
#                         sheet_id=sheet_id,
#                         question_id=res["question_id"],
#                         extracted_text=res.get("extracted_text", ""),
#                         ai_mark=mark_val,
#                         ai_feedback=res.get("ai_feedback", "")
#                     )
#                     db.add(student_answer)
                    
#                     # 🎯 التعديل: db.flush() تفرغ سجل الإجابة الحالي للداتابيس فوراً 
#                     # وتمنع تراكم البيانات الضخمة في الذاكرة وتخفف الحمل عن الاتصال
#                     db.flush() 
                    
#                     total_final_score += mark_val
                
#                 # الحفظ النهائي بعد التأكد من أن كل إجابة قد تم دفعها بنجاح
#                 db.commit()
#                 print(f"🎉 تم تصحيح الورقة {sheet_id} بنجاح في المحاولة {attempt + 1}!")
#                 success = True
#                 break # خروج من حلقة المحاولات عند النجاح

#             except Exception as e:
#                 # في حالة حدوث أي خطأ (سواء كان 503 أو انقطاع اتصال)
#                 db.rollback() # نتراجع عن أي إدخالات غير مكتملة لهذه الورقة
                
#                 if "503" in str(e) and attempt < 2:
#                     print(f"⚠️ ضغط عالٍ على السيرفر، إعادة محاولة التصحيح ({attempt + 1}/3)...")
#                     time.sleep(5) 
#                 else:
#                     # إذا كان الخطأ انقطاع اتصال أو غيره، نخرج ونرفع الخطأ
#                     print(f"❌ فشل التصحيح الجماعي في المحاولة {attempt + 1}: {str(e)}")
#                     raise e

        
#         if success and sheet_to_update:
#             sheet_to_update.status = "Graded"
#             sheet_to_update.total_earned_mark = float(total_final_score)
#             db.commit()
#             print(f"🎉 تم الانتهاء من تحديث مجموع الورقة {sheet_id}!")

#             try:
                
#                 # ربط الاختبار -> المجلد -> تكليف المعلم (حيث توجد المادة)
#                 exam_record = db.query(Exam).filter(Exam.exam_id == exam_id).first()
#                 if exam_record:
#                     folder = db.query(Folder).filter(Folder.folder_id == exam_record.folder_id).first()
#                     if folder:
#                         tc = db.query(TeacherCourse).filter(TeacherCourse.tc_id == folder.tc_id).first()
#                         if tc:
#                             # الآن حصلنا على الـ course_id الصحيح!
#                             await analyze_and_update_student_progress(db, sheet_to_update.student_id, tc.course_id,openai_client)
#                             print(f"📈 تم تحديث التقرير الأكاديمي للطالب {sheet_to_update.student_id}")
#             except Exception as e:
#                 print(f"⚠️ فشل تحليل الأداء الأكاديمي: {e}")
    

#     except Exception as e:
#         db.rollback() # تراجع عن أي عملية إدخال إذا فشل كل شيء
#         print(f"❌ فشل ذريع في معالجة الورقة {sheet_id}: {str(e)}")



async def ai_grading_pipeline(exam_id: int, sheet_id: int, pdf_path: str, db: Session):
    try:
        print(f"🎬 بدء المعالجة الاحترافية للملف: {pdf_path}")
        image_paths = []
        # 1. إعداد المجلدات (تنظيم هيكلي للملفات)
        sheet_dir = f"static/extracted_pages/sheet_{sheet_id}"
        os.makedirs(sheet_dir, exist_ok=True)
        doc = fitz.open(pdf_path)
        for page_num in range(len(doc)):
            # أ. إنشاء ملف PDF للصفحة
            new_doc = fitz.open()
            new_doc.insert_pdf(doc, from_page=page_num, to_page=page_num)
            page_pdf_path = f"{sheet_dir}/page_{page_num + 1}.pdf"
            new_doc.save(page_pdf_path)
            new_doc.close()
            
            # ب. تحويل الصفحة لصورة
            page = doc[page_num]
            mat = fitz.Matrix(2, 2)
            pix = page.get_pixmap(matrix=mat)
            img_path = f"{sheet_dir}/page_{page_num + 1}.png"
            pix.save(img_path)
            
            # --- الرفع للسحابة ---
            print(f"☁️ جاري الرفع للسحابة: صفحة {page_num + 1}...")
            try:
                public_url = upload_image_to_supabase(img_path, sheet_id, page_num + 1)
                
                # ج. حفظ الرابط (وليس المسار المحلي) في الداتابيس
                db_image = SheetImage(sheet_id=sheet_id, image_path=public_url, page_number=page_num + 1)
                db.add(db_image)
                
                # إضافة المسار المحلي للقائمة ليستخدمه الـ AI في الاستخراج
                image_paths.append(img_path) 
            except Exception as e:
                print(f"❌ خطأ في رفع الصفحة {page_num + 1}: {e}")
                # هنا يمكنكِ أن تقرري: هل تتوقفين أم تستمرين؟ (يفضل الاستمرار)

        db.commit()
        doc.close()
        
        # --- إضافة مهمة جداً (تنظيف الملفات المحلية بعد انتهاء الـ AI) ---
        # بعد أن ينتهي الـ AI من extract_student_data_from_images،
        # تأكدي أنكِ تضعين حلقة تكرارية لحذف الصور المحلية من مجلد static:
        # for p in image_paths:
        #     if os.path.exists(p): os.remove(p)
        print(f"✅ المرحلة الأولى: تم تقطيع الملف بنجاح وتجهيز الصور للـ OCR.")
        # --- [المرحلة الثانية: الاستخراج والربط] ---
       
        # 1. جلب الأسئلة من الداتابيس (نضعها هنا قبل الاستخراج)
        questions_db = db.query(Question).filter(Question.exam_id == exam_id).all()
        # تحويلها لقائمة بسيطة يفهمها الـ AI
        exam_questions = [{"id": q.question_id, "text": q.question_text} for q in questions_db]
        
        #  استدعاء دالة الاستخراج الذكي (مع تمرير قائمة الأسئلة)
        # ملاحظة: تأكدي أن تعريف الدالة extract_student_data_from_images يستقبل هذا المتغير الجديد
        extracted_data = await extract_student_data_from_images(image_paths, exam_questions)
        # 2. استخراج الرقم الجامعي من الـ JSON الناتج
        
        university_id = str(extracted_data.get("university_id", "")).strip()
        print(f"✅ تم استخراج الرقم الجامعي: {university_id}")
        
        
        # 3. الربط بالداتابيس (تحديث الورقة بالطالب)
        student_record = db.query(Student).filter(Student.university_id == university_id).first()
        sheet_to_update = db.query(AnswerSheet).filter(AnswerSheet.sheet_id == sheet_id).first()
        
        if student_record and sheet_to_update:
            sheet_to_update.student_id = student_record.student_id 
            db.commit()
            print(f"✅ تم الربط بنجاح مع الطالب: {student_record.student_id}")
        else:
            print(f"⚠️ تحذير: لم يتم العثور على طالب بالرقم: {university_id}")
            return # توقف إذا لم نجد الطالب
        # --- [المرحلة الثالثة: التصحيح الهجين] ---
        # total_final_score = 0.0
        
        # for ans in extracted_data.get("answers", []):
        #     q_num = ans.get('q_number')
        #     student_text = ans.get('extracted_text')
            
        #     # التأكد من أن رقم السؤال رقم صحيح
        #     try:
        #         target_q_id = int(q_num)
        #     except:
        #         continue

        #     # البحث عن السؤال
        #     question = db.query(Question).filter(Question.question_id == target_q_id).first()
        #     if not question:
        #         continue 
            
        #     # التصحيح
        #     mark, feedback = await grade_student_answer(db, question, student_text)
            
        #     # حفظ النتيجة (تأكدي من إضافة extracted_text هنا)
        #     new_answer = StudentAnswer(
        #         sheet_id=sheet_id,
        #         question_id=question.question_id,
        #         extracted_text=student_text, 
        #         ai_mark=float(mark),
        #         ai_feedback=feedback
        #     )
        #     db.add(new_answer)
        #     total_final_score += float(mark)
        
        # # تحديث المجموع النهائي في الورقة
        # if sheet_to_update:
        #     sheet_to_update.total_earned_mark = total_final_score
        #     sheet_to_update.status = "Graded"
        #     db.commit()
        #     print(f"🎉 تم التصحيح بنجاح! الدرجة النهائية: {total_final_score}")
        # --- [المرحلة الثالثة: التصحيح الهجين - النسخة الاحترافية] ---
        # try:
        #     # نستدعي الدالة الجديدة التي تحرس جودة العمليات
        #     # total_final_score = await grade_entire_sheet(db, sheet_id, extracted_data)
            
        #     # التعديل في استدعاء الدالة داخل pipeline
        #     total_final_score = await grade_entire_sheet(db, sheet_id, extracted_data, openai_client)
            
        #     # تحديث الورقة فقط إذا نجحت العملية بالكامل
        #     if sheet_to_update:
        #         sheet_to_update.total_earned_mark = total_final_score
        #         sheet_to_update.status = "Graded"
        #         db.commit()
        #         print(f"🎉 تم التصحيح بنجاح! الدرجة النهائية: {total_final_score}")
                
        # except Exception as e:
        #     # هنا يقع النظام إذا حدث أي خطأ تقني، ونقوم بعمل rollback لحماية الداتابيس
        #     print(f"❌ فشلت عملية التصحيح للورقة {sheet_id}: {e}")
        #     db.rollback() 
        #     # اختياري: تحديث الحالة في الداتابيس إلى 'Failed'
        #     if sheet_to_update:
        #         sheet_to_update.status = "Failed"
        #         db.commit()
        # داخل ai_grading_pipeline:
            try:
                # نقوم بالتصحيح والحفظ (حيث أننا قمنا بـ commit داخل grade_entire_sheet)
                total_final_score = await grade_entire_sheet(db, sheet_id, extracted_data, openai_client)
                
                # تحديث الورقة بحالتها النهائية
                sheet_to_update.total_earned_mark = total_final_score
                sheet_to_update.status = "Graded"
                db.commit() # تحديث نهائي لحالة الورقة
                
            except Exception as e:
                print(f"❌ خطأ: {e}")
                # لا تقومي بعمل rollback هنا إلا إذا أردتِ مسح الإجابات عند حدوث خطأ!
                # بما أننا حفظنا الإجابات بالفعل في الدالة السابقة، فهذا الـ rollback 
                # سيؤثر فقط على تغيير حالة الورقة (status) ولن يمسح الإجابات المحفوظة.
                db.rollback()
            except Exception as e:
                print(f"❌ خطأ في المرحلة الأولى (التقطيع): {str(e)}")
                db.rollback()
    finally:
        print("🧹 جاري التنظيف النهائي للملفات المؤقتة...")
        for p in image_paths:
            if os.path.exists(p):
                os.remove(p)
            pdf_p = p.replace(".png", ".pdf")
            if os.path.exists(pdf_p):
                os.remove(pdf_p)
        print("✅ تم تنظيف الجهاز بنجاح.")


# async def extract_student_data_from_images(image_paths: List[str],exam_questions: List[dict]):
#     print("🔍 بدء عملية الاستخراج مع القص الذكي...")
    
#     if not image_paths:
#         return {"university_id": "000000", "answers": []}
    
#     # 1. قص الترويسة (التي سنعاملها كـ "عدسة مكبرة" للرقم الجامعي)
#     try:
#         header_img_path = crop_header(image_paths[0]) 
#         header_img = Image.open(header_img_path)
#     except Exception as e:
#         header_img = Image.open(image_paths[0])
    
#     # 2. تجهيز باقي الصفحات (كاملة)
#     all_pages = [Image.open(p) for p in image_paths]
#     # نحول أسئلة الاختبار لنص بسيط ليفهم الـ AI سياق الأسئلة
#     questions_context = "\n".join([f"السؤال {q['id']}: {q['text']}" for q in exam_questions])
    
#     # extraction_prompt = f"""
#     # أنت خبير تصحيح. لديك سياق الاختبار التالي:
#     # {questions_context}
    
#     # استخرج إجابات الطالب بناءً على هذا السياق:
#     # - ابحث عن الإجابة التي تخص كل سؤال من الأسئلة أعلاه.
#     # - التزم بمعرفات الأسئلة (IDs) الموجودة في السياق أعلاه.
#     # -ادا كان فيه هناك نص مشطوب وبجانب هدا النص المشطوب او فوقه او جنبه من اليمين او اليسار اجابه للسوال استخرجة وادا ماشي اكتب نص مشطوب.
#     # - أجب بـ JSON فقط بالتنسيق التالي (لاحظي مضاعفة الأقواس):
#     # {{"university_id": "...", "answers": [{{"q_number": 1, "extracted_text": "..."}}, ...]}}
#     # """
#     extraction_prompt = f"""
#         أنت خبير في تحليل أوراق الاختبارات الممسوحة ضوئياً. مهمتك استخراج إجابات الطالب بدقة متناهية بناءً على سياق الأسئلة التالي:
#         {questions_context}

#         ---
#         التعليمات:
#         1. استخراج النصوص (للمقالي وفراغات): استخرج إجابة الطالب كما هي تماماً.
#         2. التعامل مع الشطب: إذا كان النص مشطوباً، ابحث في محيطه (فوق، تحت، يمين، يسار) عن أي نص بديل أو إجابة مكتوبة، فإذا وجدت إجابة استخرجها، وإذا لم تجد اكتب "[مشطوب]".
#         3. التعامل مع أسئلة التوصيل (المطابقة): 
#         - تتبع الخطوط المرسومة يدوياً من الكلمة في العمود (أ) إلى الكلمة في العمود (ب).
#         - استخرج النتيجة على شكل أزواج مرتبة بتنسيق: "الكلمة1:الكلمة2".
#         - إذا كان الخط غير واضح أو لا توجد إجابة، اكتب "لا_يوجد".
#         4. تنسيق المخرجات:
#         - يجب أن يكون الرد بصيغة JSON صالح فقط.
#         - لا تضف أي نص خارج JSON.
#         1. تحديد نوع الورقة: 
#         - إذا كانت الورقة تحتوي على نص السؤال + الاختيارات (محددة بدائرة أو خط)، استخرج النص المختار فقط.
#         - إذا كانت الورقة تحتوي على "رقم السؤال + النص المختار" فقط، استخرج النص المختار مباشرة.

#         2. قواعد الاستخراج (هام جداً):
#         - إذا كان الطالب وضع دائرة أو خط حول نص الإجابة في ورقة الاختبار، استخرج ذلك النص.
#         - إذا كان الطالب كتب الإجابة نصاً بجانب رقم السؤال في ورقة الإجابة، استخرج هذا النص.
#         - إذا كانت الإجابة المكتوبة في ورقة الطالب غير موجودة ضمن اختيارات السؤال في السياق المرفق، استخرجها كما هي واعتبرها "إجابة حرة".
#         - التنسيق: 
#         {{"university_id": "...", "answers": [{{"q_number": معرف_السؤال, "extracted_text": "..."}}, ...]}}
#         ---
#         """
#     # 4. الاستخراج (دمج الصورة المقصوصة مع كل الصفحات)
#     response = client.models.generate_content(
#         model="gemini-3-flash-preview",
#         contents=[header_img] + all_pages + [extraction_prompt],
#         config=types.GenerateContentConfig(
#             response_mime_type="application/json",
#             temperature=0.0
#         )
#     )
    
#     return json.loads(response.text)
async def extract_student_data_from_images(image_paths: List[str], exam_questions: List[dict]):
    print("🔍 بدء عملية الاستخراج مع القص الذكي...")
    
    if not image_paths:
        return {"university_id": "000000", "answers": []}
    
    # 1. قص الترويسة
    try:
        header_img_path = crop_header(image_paths[0]) 
        header_img = Image.open(header_img_path)
    except Exception as e:
        header_img = Image.open(image_paths[0])
    
    # 2. تجهيز باقي الصفحات
    all_pages = [Image.open(p) for p in image_paths]
    questions_context = "\n".join([f"السؤال {q['id']}: {q['text']}" for q in exam_questions])
    
    extraction_prompt = f"""
        أنت خبير في تحليل أوراق الاختبارات الممسوحة ضوئياً. مهمتك استخراج إجابات الطالب بدقة متناهية بناءً على سياق الأسئلة التالي:
        {questions_context}
        ---
       التعليمات:

        1. استخراج النصوص (للمقالي وفراغات): استخرج إجابة الطالب كما هي تماماً.
        2. التعامل مع الشطب: إذا كان النص مشطوباً، ابحث في محيطه (فوق، تحت، يمين، يسار) عن أي نص بديل أو إجابة مكتوبة، فإذا وجدت إجابة استخرجها، وإذا لم تجد اكتب "[مشطوب]".
        3. التعامل مع أسئلة التوصيل (المطابقة): 
            - تتبع الخطوط المرسومة يدوياً من الكلمة في العمود (أ) إلى الكلمة في العمود (ب).
            - استخرج النتيجة على شكل أزواج مرتبة بتنسيق: "الكلمة1:الكلمة2".
            - إذا كان الخط غير واضح أو لا توجد إجابة، اكتب "لا_يوجد".
        4. تنسيق المخرجات:
            - يجب أن يكون الرد بصيغة JSON صالح فقط.
            - لا تضف أي نص خارج JSON.

        5. التعامل مع أسئلة (صح أو خطأ):
            - إذا رسم الطالب رمزاً (مثل: ✓, v, x, ✖, ❌, ✅, ✔)، قم بتحويله فوراً إلى كلمة "صح" أو "خطأ" وفقاً لدلالة الرمز في السياق.
            - إذا كتب الطالب نصاً (مثل: صح، خطأ، true, false)، استخرجه كما هو.
            - الهدف هو توحيد المخرجات لتكون دائماً "صح" أو "خطأ" فقط لهذه النوعية من الأسئلة.

        6. قواعد الاستخراج (هام جداً):
            - إذا كان الطالب وضع دائرة أو خط حول نص الإجابة في ورقة الاختبار، استخرج ذلك النص.
            - إذا كان الطالب كتب الإجابة نصاً بجانب رقم السؤال في ورقة الإجابة، استخرج هذا النص.
            - إذا كانت الإجابة المكتوبة في ورقة الطالب غير موجودة ضمن اختيارات السؤال في السياق المرفق، استخرجها كما هي واعتبرها "إجابة حرة".

        التنسيق النهائي:
        {{"university_id": "...", "answers": [{{"q_number": معرف_السؤال, "extracted_text": "..."}}, ...]}}
                """


        # ---
        # التعليمات:
        
        # 1. استخراج النصوص (للمقالي وفراغات): استخرج إجابة الطالب كما هي تماماً.
        # 2. التعامل مع الشطب: إذا كان النص مشطوباً، ابحث في محيطه (فوق، تحت، يمين، يسار) عن أي نص بديل أو إجابة مكتوبة، فإذا وجدت إجابة استخرجها، وإذا لم تجد اكتب "[مشطوب]".
        # 3. التعامل مع أسئلة التوصيل (المطابقة): 
        # - تتبع الخطوط المرسومة يدوياً من الكلمة في العمود (أ) إلى الكلمة في العمود (ب).
        # - استخرج النتيجة على شكل أزواج مرتبة بتنسيق: "الكلمة1:الكلمة2".
        # - إذا كان الخط غير واضح أو لا توجد إجابة، اكتب "لا_يوجد".
        # 4. تنسيق المخرجات:
        # - يجب أن يكون الرد بصيغة JSON صالح فقط.
        # - لا تضف أي نص خارج JSON.
        # 1. تحديد نوع الورقة: 
        # - إذا كانت الورقة تحتوي على نص السؤال + الاختيارات (محددة بدائرة أو خط)، استخرج النص المختار فقط.
        # - إذا كانت الورقة تحتوي على "رقم السؤال + النص المختار" فقط، استخرج النص المختار مباشرة.

        # 2. قواعد الاستخراج (هام جداً):
        # - إذا كان الطالب وضع دائرة أو خط حول نص الإجابة في ورقة الاختبار، استخرج ذلك النص.
        # - إذا كان الطالب كتب الإجابة نصاً بجانب رقم السؤال في ورقة الإجابة، استخرج هذا النص.
        # - إذا كانت الإجابة المكتوبة في ورقة الطالب غير موجودة ضمن اختيارات السؤال في السياق المرفق، استخرجها كما هي واعتبرها "إجابة حرة".
        # - التنسيق: 
        # {{"university_id": "...", "answers": [{{"q_number": معرف_السؤال, "extracted_text": "..."}}, ...]}}
        # ---
        # """

        
    # 4. الاستخراج مع نظام إعادة المحاولة الذكي
    max_retries = 3
    for attempt in range(max_retries):
        try:
            response = client.models.generate_content(
                model="gemini-3-flash-preview",
                contents=[header_img] + all_pages + [extraction_prompt],
                config=types.GenerateContentConfig(
                    response_mime_type="application/json",
                    temperature=0.0
                )
            )
            
            # تنظيف الرد
            raw_text = response.text.strip()
            clean_text = raw_text.replace("```json", "").replace("```", "").strip()
            return json.loads(clean_text)

        except Exception as e:
            error_msg = str(e)
            
            # إذا نفدت الكوتا، توقف فوراً ولا تعِد المحاولة
            if "Quota exceeded" in error_msg or "429" in error_msg:
                print("❌ خطأ: لقد نفدت الكوتا اليومية. لن تتم محاولة التصحيح.")
                raise e 
            
            # إذا كان الخطأ ضغط مؤقت (503)، أعد المحاولة
            elif "503" in error_msg or "Temporary" in error_msg or "500" in error_msg:
                wait_time = (attempt + 1) * 10 + random.uniform(1, 3)
                print(f"⚠️ المودل مشغول (محاولة {attempt + 1}/{max_retries}). ننتظر {wait_time:.1f} ثانية...")
                await asyncio.sleep(wait_time)
            else:
                # خطأ غير معروف
                print(f"❌ خطأ غير متوقع: {error_msg}")
                raise e

    return {"university_id": "000000", "answers": []}


def upload_image_to_supabase(local_file_path, sheet_id, page_number):
    file_name = f"sheet_{sheet_id}/page_{page_number}.png"
    max_retries = 3
    
    for attempt in range(max_retries):
        try:
            with open(local_file_path, "rb") as f:
                supabase.storage.from_("sheets-images").upload(
                    path=file_name,
                    file=f,
                    file_options={"content-type": "image/png", "upsert": "true"}
                )
            return supabase.storage.from_("sheets-images").get_public_url(file_name)
        except Exception as e:
            if attempt < max_retries - 1:
                print(f"⚠️ فشل الرفع، جاري المحاولة مرة أخرى ({attempt+1})...")
                time.sleep(2) # انتظار ثانيتين قبل المحاولة
            else:
                raise e # إذا فشل 3 مرات، ارمي الخطأ الحقيقي
async def grade_matching_question(db: Session, question: Question, student_text: str):
    """
    دالة متخصصة لتصحيح أسئلة المطابقة (التوصيل).
    """
    expected_answers = db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id == question.question_id).all()
    if not expected_answers:
        return 0.0, "لا توجد إجابة نموذجية للمطابقة"

    score = 0.0
    total_pairs = len(expected_answers)
    s_text = student_text.lower()
    
    for expected in expected_answers:
        ans = expected.answer_text.strip().lower()
        match = expected.match_text.strip().lower()
        
        # البحث عن النمط باستخدام Regex (يدعم فواصل متعددة: : ، - ، أو مسافة)
        # هذا يغطي: "الخيار1:الخيار2" أو "الخيار1-الخيار2"
        pattern = re.compile(rf"{re.escape(ans)}[\s:\-]*{re.escape(match)}", re.IGNORECASE)
        reverse_pattern = re.compile(rf"{re.escape(match)}[\s:\-]*{re.escape(ans)}", re.IGNORECASE)
        
        if pattern.search(s_text) or reverse_pattern.search(s_text):
            score += (float(question.question_mark) / total_pairs)
            
    # return round(score, 2), f"تم تصحيح المطابقة (تم العثور على {int(score / (float(question.question_mark)/total_pairs) if total_pairs > 0 else 1)} أزواج)"
    # بدلاً من المعادلة المعقدة، احسبي عدد الأزواج أولاً
    # هذا يجعل الكود أسهل في القراءة وأكثر استقراراً
    pair_value = float(question.question_mark) / total_pairs if total_pairs > 0 else 1
    correct_count = int(score / pair_value) if pair_value > 0 else 0

    return round(score, 2), f"تم تصحيح المطابقة (تم العثور على {correct_count} أزواج)"


# def is_answer_correct(student_text: str, expected_text: str, is_boolean_question: bool = False,threshold: float = 0.8) -> bool:
#     if not student_text or not expected_text:
#         return False
        
#     s_text = student_text.strip().lower()
#     e_text = expected_text.strip().lower()

#     # دالة التشابه الإملائي (مستقلة وذكية)
#     def is_similar(word1, word2):
#         return SequenceMatcher(None, word1, word2).ratio() > threshold

#     # 1. إذا كان السؤال من نوع صح/خطأ
#     if is_boolean_question:
#         true_synonyms = ['صح', 'صحيح','نعم' 'true', 't', 'yes', '✓','v', 'correct', '✅', '✔']
#         false_synonyms = ['خطأ', 'غلط',  'لا','false', 'f', 'no', 'n', 'x', 'X','X', 'wrong', 'غير صحيح', 'خطا', '✖']
        
#         # نتحقق من نية الطالب مقارنة بالمترادفات
#         if e_text in ['صح', 'صحيح', 'true','✔','نعم']:
#             return any(is_similar(s_text, syn) for syn in true_synonyms)
#         elif e_text in ['خطأ', 'غلط','لا', 'false','خطا','x','X','✖']:
#             return any(is_similar(s_text, syn) for syn in false_synonyms)

#     # 2. إذا كان السؤال MCQ أو أي نص آخر (مقارنة مباشرة)
#     # لا نحتاج هنا للمترادفات، بل نقارن إجابة الطالب بالنص الصحيح مباشرة
#     return is_similar(s_text, e_text)

def is_answer_correct(student_text: str, expected_text: str, is_boolean_question: bool = False, threshold: float = 0.8) -> bool:
    if not student_text or not expected_text:
        return False
        
    # 1. قائمة الرموز التي نعتبرها إجابات (لا تحذفيها)
    # سنقوم بتبديل الرموز بكلمات واضحة قبل التنظيف
    def prepare_text(text):
        text = text.lower().strip()
        # تبديل الرموز بكلمات واضحة ليفهمها النظام
        text = text.replace('✓', 'صح').replace('✔', 'صح').replace('✅', 'صح').replace('v', 'صح')
        text = text.replace('✖', 'خطا').replace('x', 'خطا').replace('❌', 'خطا')
        
        # تنظيف الهمزات والتاء المربوطة
        text = re.sub(r'[أإآ]', 'ا', text)
        text = text.replace('ة', 'ه')
        return text

    s_text = prepare_text(student_text)
    e_text = prepare_text(expected_text)

    # 2. الآن المقارنة أصبحت أسهل بكثير لأننا وحدنا كل شيء
    if is_boolean_question:
        true_syns = ['صح', 'صحيح', 'نعم', 'true', 'yes', 'correct']
        false_syns = ['خطا', 'غلط', 'لا', 'false', 'no', 'wrong']
        
        # مقارنة ذكية
        if e_text in ['صح', 'صحيح', 'نعم', 'true']:
            return s_text in true_syns
        elif e_text in ['خطا', 'غلط', 'لا', 'false']:
            return s_text in false_syns

    # 3. للنصوص العادية
    return SequenceMatcher(None, s_text, e_text).ratio() > threshold

async def grade_mcq_question(db: Session, question: Question, student_text: str):
    """
    دالة تصحيح أسئلة الاختيار من متعدد (MCQ) بالاعتماد على النصوص.
    """
    
    # 1. جلب الإجابة الصحيحة من الداتابيس
    correct_answer = db.query(ExpectedAnswer).filter(
        ExpectedAnswer.question_id == question.question_id,
        ExpectedAnswer.is_correct == True
    ).first()

    if not correct_answer:
        return 0.0, "خطأ تقني: لم يتم تعريف إجابة صحيحة لهذا السؤال."

    # 2. تنظيف نص الطالب والنص الصحيح
    s_text = student_text.strip().lower()
    c_text = correct_answer.answer_text.strip().lower()

    # 3. المقارنة باستخدام دالة التشابه الذكي (is_answer_correct)
    # هذه الدالة تغطي: التطابق المباشر، الأخطاء الإملائية، والتشابه اللغوي
    # if is_answer_correct(s_text, c_text):
    #     return float(question.question_mark), "إجابة صحيحة (تصحيح آلي)"
    # else:
    #     return 0.0, "إجابة خاطئة (تصحيح آلي)"
    if is_answer_correct(s_text, c_text, is_boolean_question=False,threshold=0.9):
        return float(question.question_mark), "إجابة صحيحة (تصحيح آلي)"
    else:
        return 0.0, "إجابة خاطئة (تصحيح آلي)"
    
async def grade_fill_blank_with_ai(student_text: str, expected_text: str, max_mark: float) -> tuple[float, str]:
    prompt = f"""
    أنت مصحح اختبارات. مهمتك تقييم إجابة الطالب في سؤال "أكمل الفراغ".
    - إجابة الطالب: "{student_text}"
    - الإجابة النموذجية: "{expected_text}"
    - الدرجة القصوى: {max_mark}

    تعليمات:
    - لا يشترط التطابق الحرفي. إذا كان الطالب استخدم مرادفاً صحيحاً أو عبر عن نفس المعنى، اعتبرها إجابة صحيحة.
    - إذا كانت الإجابة خاطئة تماماً، أعطِ 0.
    - أجب بـ JSON فقط: {{"mark": الدرجة, "feedback": "سبب التقييم"}}
    """

    # نفس كود استدعاء Gemini الذي استخدمناه في المقالي
    response = client.models.generate_content(
        model="gemini-3-flash-preview",
        contents=[prompt],
        config=types.GenerateContentConfig(response_mime_type="application/json")
    )
    
    result = json.loads(response.text.replace("```json", "").replace("```", "").strip())
    return float(result.get("mark", 0.0)), result.get("feedback", "")
async def grade_student_answer(db: Session, question: Question, student_text: str):
    # 1. جلب كل الإجابات النموذجية لهذا السؤال (لأنه قد يكون هناك أكثر من زوج في المطابقة)
    expected_answers = db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id == question.question_id).all()
    
    if not expected_answers:
        return 0.0, "لا توجد إجابة نموذجية"

    q_type = question.question_type.strip().lower()
    
    # 2. التصحيح للمطابقة (Matching)
    if 'matching' in q_type or 'مطابقة' in q_type:
        return await grade_matching_question(db, question, student_text)
    # 3. التصحيح المنطقي (للاختياري، الصح والخطأ)
    
    # elif any(term in q_type for term in ['true_false', 'صح وخطا']):
    #     expected = expected_answers[0]
    #     # استخدام الدالة الذكية هنا
    #     if is_answer_correct(student_text, expected.answer_text):
    #         return float(question.question_mark), "إجابة صحيحة (تصحيح آلي)"
    #     else:
    #         return 0.0, "إجابة خاطئة (تصحيح آلي)"
    elif any(term in q_type for term in ['true_false', 'صح وخطا']):
        expected = expected_answers[0]
        # أضيفي المعامل True هنا لكي تعمل دالة التشابه منطقياً مع المترادفات (صح/خطأ)
        if is_answer_correct(student_text, expected.answer_text, is_boolean_question=True):
            return float(question.question_mark), "إجابة صحيحة (تصحيح آلي)"
        else:
            return 0.0, "إجابة خاطئة (تصحيح آلي)"
    elif 'mcq' in q_type or 'اختيار' in q_type:
        return await grade_mcq_question(db, question, student_text)
    elif 'fill_blank' in q_type or 'فراغ' in q_type:
        # هنا نستدعي دالة المقالي ولكن ببرومبت متخصص للفراغات
        mark, feedback = await grade_fill_blank_with_ai(student_text, expected_answers[0].answer_text, float(question.question_mark))
        return mark, feedback
    
    # 4. التصحيح الذكي (للمقالي)
    # else:
    #     return await grade_essay_with_ai(student_text, expected_answers[0].answer_text, float(question.question_mark))
    # 4. التصحيح الذكي (للمقالي)
    else:
        # استدعاء الدالة
        mark, feedback = await grade_essay_with_ai(student_text, expected_answers[0].answer_text, float(question.question_mark))
        
        # 🎯 هذه هي "العصة" التي كنتِ تسألين عنها:
        # إذا كانت الدرجة 0.0 والرسالة تحتوي على "تعذر"، أرسلي -1.0 للنظام
        if mark == 0.0 and "تعذر" in feedback:
            return -1.0, feedback
            
        return mark, feedback
    
# async def grade_entire_sheet(db: Session, sheet_id: int, extracted_data: dict):
#     """
#     تقوم بتصحيح كافة الأسئلة في الورقة، وإذا فشل أي سؤال، ترفع استثناءً لإيقاف العملية.
#     """
#     total_final_score = 0.0
    
#     # التأكد من وجود إجابات
#     answers_list = extracted_data.get("answers", [])
#     if not answers_list:
#         raise Exception("لا توجد إجابات مستخرجة لتصحيحها.")

#     for ans in answers_list:
#         q_num = ans.get('q_number')
#         student_text = ans.get('extracted_text')
        
#         # التأكد من معرف السؤال
#         if q_num is None: continue
        
#         question = db.query(Question).filter(Question.question_id == int(q_num)).first()
#         if not question: continue
        
#         # استدعاء دالة التصحيح (التي قمنا بتطويرها)
#         mark, feedback = await grade_student_answer(db, question, student_text)
        
#         # 🎯 إدارة الأخطاء التقنية (إذا عاد التصحيح بـ -1.0)
#         if mark < 0:
#             raise Exception(f"خطأ تقني في تصحيح السؤال {q_num}: {feedback}")
            
#         # إنشاء سجل الإجابة
#         new_answer = StudentAnswer(
#             sheet_id=sheet_id, 
#             question_id=question.question_id,
#             extracted_text=student_text, 
#             ai_mark=float(mark), 
#             ai_feedback=feedback
#         )
#         db.add(new_answer)
#         total_final_score += float(mark)
    
#     # 🎯 commit هنا يضمن أن كل شيء تم حفظه معاً (Atomic Transaction)
#     # ملاحظة: إذا استدعيتِ هذه الدالة من داخل pipeline، يمكنكِ عمل الـ commit هناك 
#     # ولكن يفضل عمله هنا لضمان سلامة الإجابات.
#     return total_final_score
# async def grade_entire_sheet(db: Session, sheet_id: int, extracted_data: dict, openai_client):
#     """
#     تقوم بتصحيح كافة الأسئلة في الورقة، وتحديث التقدم الأكاديمي للطالب في النهاية.
#     """
#     total_final_score = 0.0
    
#     # 1. جلب بيانات الورقة (ضروري للحصول على معرف الطالب والمادة)
#     sheet = db.query(AnswerSheet).filter(AnswerSheet.sheet_id == sheet_id).first()
#     if not sheet:
#         raise Exception(f"لا توجد ورقة إجابة بالمعرف: {sheet_id}")

#     # 2. التأكد من وجود إجابات
#     answers_list = extracted_data.get("answers", [])
#     if not answers_list:
#         raise Exception("لا توجد إجابات مستخرجة لتصحيحها.")

#     for ans in answers_list:
#         q_num = ans.get('q_number')
#         student_text = ans.get('extracted_text')
        
#         if q_num is None: continue
        
#         question = db.query(Question).filter(Question.question_id == int(q_num)).first()
#         if not question: continue
        
#         # استدعاء دالة التصحيح
#         mark, feedback = await grade_student_answer(db, question, student_text)
        
#         if mark < 0:
#             raise Exception(f"خطأ تقني في تصحيح السؤال {q_num}: {feedback}")
            
#         new_answer = StudentAnswer(
#             sheet_id=sheet_id, 
#             question_id=question.question_id,
#             extracted_text=student_text, 
#             ai_mark=float(mark), 
#             ai_feedback=feedback
#         )
#         db.add(new_answer)
#         total_final_score += float(mark)
    
#     # 3. الربط مع دالة التحليل الأكاديمي
#     # ملاحظة: تأكدي أن مسار العلاقات sheet -> exam -> folder -> course صحيح في الـ Models
#     try:
#         # جلب الـ course_id من علاقات الورقة
#         course_id = sheet.exam.folder.course_id 
        
#         # استدعاء دالة التحليل
#         await analyze_and_update_student_progress(db, sheet.student_id, course_id, openai_client)
#         print(f"✅ تم تحديث التحليل الأكاديمي للطالب {sheet.student_id}")
#     except Exception as e:
#         print(f"⚠️ تحذير: فشل تحديث التحليل الأكاديمي: {e}")

#     # 4. حفظ الكل دفعة واحدة
#     db.commit()
    
#     return total_final_score
async def grade_entire_sheet(db: Session, sheet_id: int, extracted_data: dict, openai_client):
    total_final_score = 0.0
    
    # 1. جلب بيانات الورقة
    sheet = db.query(AnswerSheet).filter(AnswerSheet.sheet_id == sheet_id).first()
    if not sheet:
        raise Exception(f"لا توجد ورقة بالمعرف: {sheet_id}")

    answers_list = extracted_data.get("answers", [])
    
    # 2. حلقة التصحيح (إضافة للذاكرة فقط)
    for ans in answers_list:
        q_num = ans.get('q_number')
        student_text = ans.get('extracted_text')
        if q_num is None: continue
        
        question = db.query(Question).filter(Question.question_id == int(q_num)).first()
        if not question: continue
        
        mark, feedback = await grade_student_answer(db, question, student_text)
        
        # حفظ كائن الإجابة
        new_answer = StudentAnswer(
            sheet_id=sheet_id, 
            question_id=question.question_id,
            extracted_text=student_text, 
            ai_mark=float(mark), 
            ai_feedback=feedback
        )
        db.add(new_answer)
        total_final_score += float(mark)
    
    # 3. 🛑 الحفظ الفوري (Commit): هنا يتم تثبيت الإجابات في جدول student_answers
    # أي خطأ يحدث لاحقاً في التحليل لن يؤثر على هذه الإجابات المحفوظة
    db.commit() 
    print(f"✅ تم حفظ الإجابات في الداتابيس بنجاح.")

    # 4. محاولة التحليل (مستقلة تماماً عن الحفظ)
    try:
        # جلب الامتحان مباشرة لتجنب خطأ الـ relationship
        exam = db.query(Exam).filter(Exam.exam_id == sheet.exam_id).first()
        if exam and exam.folder:
            await analyze_and_update_student_progress(db, sheet.student_id, exam.folder.course_id, openai_client)
    except Exception as e:
        print(f"⚠️ تنبيه: فشل التحليل (لكن الإجابات محفوظة): {e}")

    return total_final_score

async def grade_essay_with_ai(student_text: str, expected_text: str, max_mark: float) -> tuple[float, str]:
    """
    تقوم بتصحيح الأسئلة المقالية باستخدام Gemini مع مراعاة الدرجة القصوى للسؤال.
    """
    try:
        # 1. تمرير الدرجة القصوى (max_mark) للـ Prompt
        prompt = f"""
        أنت مصحح اختبارات أكاديمي خبير. مهمتك تقييم إجابة الطالب مقارنة بالإجابة النموذجية.
        - الدرجة القصوى لهذا السؤال هي: {max_mark}
        - إجابة الطالب: "{student_text}"
        - الإجابة النموذجية: "{expected_text}"
        
        تعليمات هامة:
        - قم بتقييم الإجابة وأعطِ درجة من {max_mark} بناءً على جودتها ومطابقتها للنموذج.
        - يجب أن تكون الدرجة ("mark") رقمًا لا يتجاوز {max_mark}.
        - أجب بصيغة JSON فقط: {{"mark": الدرجة, "feedback": "ملاحظة قصيرة"}}
        """

        response = client.models.generate_content(
            model="gemini-3-flash-preview",
            contents=[prompt],
            config=types.GenerateContentConfig(
                response_mime_type="application/json",
                temperature=0.2
            )
        )

        # 2. تنظيف الرد (التأكد من استخدام النص النظيف)
        raw_text = response.text.strip()
        clean_text = raw_text.replace("```json", "").replace("```", "").strip()
            
        # 3. التحليل باستخدام النص النظيف
        result = json.loads(clean_text)
        
        # التأكد من أن الدرجة لا تتجاوز الدرجة القصوى (حماية إضافية)
        mark = float(result.get("mark", 0.0))
        if mark > max_mark:
            mark = max_mark
            
        feedback = result.get("feedback", "لا توجد ملاحظات.")

        return mark, feedback

    except Exception as e:
        print(f"❌ خطأ في تصحيح المقال عبر Gemini: {str(e)}")
        return 0.0, "تعذر التصحيح الآلي لهذا السؤال."

# ==========================================
# 1. الـ Endpoint الخاص برفع الملفات وبدء التصحيح
# ==========================================
@router.post("/upload-sheets/{exam_id}")
def upload_and_start_grading(
    exam_id: int, 
    background_tasks: BackgroundTasks, 
    files: List[UploadFile] = File(...), 
    db: Session = Depends(get_db)
):
    exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
    if not exam:
        raise HTTPException(status_code=404, detail="الاختبار غير موجود")

    UPLOAD_DIR = "static/answer_sheets"
    os.makedirs(UPLOAD_DIR, exist_ok=True)

    # احتساب ترتيب الأوراق بشكل ديناميكي آمن لمنع تعليق الداتابيس وقفل الجلسات
    from sqlalchemy import func
    max_student_id = db.query(func.max(AnswerSheet.student_id)).filter(AnswerSheet.exam_id == exam_id).scalar()
    current_student_id = (max_student_id + 1) if max_student_id else 1

    for file in files:
        unique_prefix = datetime.now().strftime("%Y%m%d_%H%M%S")
        file_location = f"{UPLOAD_DIR}/{exam_id}_{unique_prefix}_{current_student_id}_{file.filename}"
        with open(file_location, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        # ننشئ السجل المبدئي ونترك الهوية ليحددها كود الـ OCR من الورقة مباشرة في الخلفية
        new_sheet = AnswerSheet(
            exam_id=exam_id,
            # student_id=current_student_id,  # معرّف ترتيب مبدئي فريد لكسر التعارض
            # student_id=0,  # ضعي هنا ID لطالب موجود فعلياً في جدول الـ student
            student_id=9999,
            status="Pending",
            total_earned_mark=0.0
        )
        db.add(new_sheet)
        db.commit()
        db.refresh(new_sheet)

        # استدعاء محرك الذكاء الاصطناعي للتصحيح والربط بالاسم في الخلفية
        background_tasks.add_task(
            ai_grading_pipeline, 
            exam_id=exam_id, 
            sheet_id=new_sheet.sheet_id, 
            pdf_path=file_location, 
            db=db
        )
        
        current_student_id += 1

    return {"message": "تم رفع الملفات بنجاح وبدأ محرك الذكاء الاصطناعي في تحديد الأسماء والتصحيح حياً 🚀"}

# ==========================================
# 2. الـ Endpoint المطور لجلب النتائج والأسماء الحقيقية أو أسماء الملفات حياً 🎯
# ==========================================
@router.get("/exam-results/{exam_id}")
def get_exam_results(exam_id: int, db: Session = Depends(get_db)):
    # نجلب جميع الأوراق (المكتملة وقيد المعالجة) ونستبعد فقط الأوراق التي فشلت تماماً إن أردتِ
    sheets = db.query(AnswerSheet).filter(
        AnswerSheet.exam_id == exam_id,
        AnswerSheet.status != "Failed"  # يعرض المكتمل وقيد المعالجة بأمان
    ).all()
    
    results = []
    for sheet in sheets:
        # الحالة الافتراضية الذكية: إذا كانت الورقة قيد المعالجة، نظهر كلمة "ورقة مرفوعة" مع رقمها الفريد
        student_name = f"⏳ جاري استخراج الهوية... (ورقة رقم {sheet.sheet_id})"
        
        # إذا نجحت الداتابيس في ربط الـ student_id بالطالب الحقيقي (بعد معالجة الـ AI)
        if sheet.student_id:
            student_profile = db.query(Student).filter(Student.student_id == sheet.student_id).first()
            if student_profile:
                user_record = db.query(User).filter(User.user_id == student_profile.user_id).first()
                if user_record:
                    student_name = user_record.full_name  # الاسم الثلاثي النظيف الصريح!
            else:
                # 🎯 اللمسة السحرية: إذا كان الـ ID مؤقتاً والـ AI لم يربطه بعد، نظهر مؤشر ذكي بدلاً من "طالب رقم 1"
                student_name = f"📄 ورقة ممسوحة ضوئياً قيد القراءة... (ID: {sheet.sheet_id})"

        # جلب تفاصيل تصحيح الأسئلة لهذه الورقة
        answers_query = db.query(StudentAnswer, Question).join(
            Question, StudentAnswer.question_id == Question.question_id
        ).filter(StudentAnswer.sheet_id == sheet.sheet_id).all()
        
        questions_details = []
        for answer, question in answers_query:
            expected = db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id == question.question_id).first()
            model_answer_text = expected.answer_text if expected else "لا توجد إجابة نموذجية مسجلة"

            # حساب القيم بشكل آمن
            teacher_mark = float(answer.teacher_mark) if answer.teacher_mark is not None else None
            ai_mark = float(answer.ai_mark) if answer.ai_mark is not None else 0.0
            
            # تحديد الدرجة النهائية: إذا وضع المعلم درجة نعتمدها، وإلا نعتمد درجة الـ AI
            final_mark = teacher_mark if teacher_mark is not None else ai_mark

            questions_details.append({
                "question_id": question.question_id,
                "question_order": question.question_order,
                "question_text": question.question_text,
                "max_mark": float(question.question_mark) if question.question_mark is not None else 0.0,
                "extracted_text": answer.extracted_text or "",
                "model_answer": model_answer_text,
                "ai_mark": ai_mark,
                "teacher_mark": teacher_mark,
                "final_mark": float(final_mark),
                "ai_feedback": answer.ai_feedback or "",
                "confidence": float(answer.confidence_score) if answer.confidence_score is not None else 1.0
            })
            
        results.append({
            "sheet_id": sheet.sheet_id,
            "student_id": sheet.student_id,
            "student_name": student_name,
            "status": sheet.status,
            "total_score": float(sheet.total_earned_mark) if sheet.total_earned_mark is not None else 0.0,
            "is_published": getattr(sheet, 'is_published', False),
            "questions": questions_details
        })
        
    return results
# ==========================================
# 3. راوت حفظ تعديل المعلم اليدوي للدرجة وتحديث المجموع
# ==========================================
@router.put("/update-mark/{question_id}")
def update_teacher_mark(
    question_id: int, 
    sheet_id: int, 
    new_mark: float, 
    db: Session = Depends(get_db)
):
    try:
        answer_record = db.query(StudentAnswer).filter(
            StudentAnswer.question_id == question_id,
            StudentAnswer.sheet_id == sheet_id
        ).first()

        if not answer_record:
            raise HTTPException(status_code=404, detail="سجل إجابة الطالب غير موجود")

        answer_record.teacher_mark = new_mark
        db.commit()

        all_answers = db.query(StudentAnswer).filter(StudentAnswer.sheet_id == sheet_id).all()
        
        calculated_total = 0.0
        for ans in all_answers:
            if ans.teacher_mark is not None:
                calculated_total += float(ans.teacher_mark)
            else:
                calculated_total += float(ans.ai_mark) if ans.ai_mark else 0.0

        sheet_record = db.query(AnswerSheet).filter(AnswerSheet.sheet_id == sheet_id).first()
        if sheet_record:
            sheet_record.total_earned_mark = calculated_total
            sheet_record.status = "Graded"
            # 🎯🎯 الإضافة المطلوبة هنا 🎯🎯
            # أي تعديل يدوي يُلغي حالة النشر فوراً
            sheet_record.is_published = False
            db.commit()

        return {
            "status": "success",
            # "message": "تم اعتماد درجة المعلم وإعادة احتساب المجموع النهائي حياً! 🎯",
            "message": "تم اعتماد درجة المعلم، إعادة احتساب المجموع، وإلغاء حالة النشر بنجاح! 🎯",
            "new_total_score": calculated_total
        }

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"حدث خطأ أثناء التحديث في الداتابيس: {str(e)}")

# 🎯 تأكدي أنك تستخدمين router وليس app
@router.put("/publish-result/{sheet_id}") # احذفي /grading من هنا لأنها موجودة في الـ prefix
async def publish_result(sheet_id: int, db: Session = Depends(get_db)):
    sheet = db.query(AnswerSheet).filter(AnswerSheet.sheet_id == sheet_id).first()
    if not sheet:
        return {"error": "الورقة غير موجودة"}
    
    sheet.is_published = True 
    db.commit()
    return {"message": "تم نشر النتيجة للطالب بنجاح!"}
@router.get("/verify-data/{sc_id}")
def verify_data(sc_id: int, db: Session = Depends(get_db)):
    record = db.query(StudentCourse).filter(StudentCourse.sc_id == sc_id).first()
    if record:
        return {
            "sc_id": record.sc_id,
            "strengths": record.subject_strengths,
            "weaknesses": record.subject_weaknesses
        }
    return {"message": "سجل غير موجود"}

@router.get("/course-exams/{teacher_id}/{course_id}")
def get_exams_for_review(teacher_id: int, course_id: int, db: Session = Depends(get_db)):
    tc = db.query(TeacherCourse).filter(TeacherCourse.teacher_id == teacher_id, TeacherCourse.course_id == course_id).first()
    if not tc: 
        print("DEBUG: لم يتم العثور على سجل TeacherCourse")
        return []
    
    folders = db.query(Folder).filter(Folder.tc_id == tc.tc_id).all()
    folder_ids = [f.folder_id for f in folders]
    print(f"DEBUG: تم العثور على {len(folder_ids)} مجلدات بمعرفات: {folder_ids}")
    
    exams = db.query(Exam).filter(Exam.folder_id.in_(folder_ids)).all()
    print(f"DEBUG: تم العثور على {len(exams)} اختبارات")
    
    return [{"exam_id": e.exam_id, "exam_name": e.exam_title} for e in exams] # تأكدي: هل اسم الحقل exam_name أم exam_title؟
from models.profiles import Course  # 👈 هذا هو المسار الصحيح لكلاس Course
@router.get("/teacher-courses/{teacher_id}")
def get_teacher_courses(teacher_id: int, db: Session = Depends(get_db)):
    # 1. جلب الترم النشط
    from models.exams import Semester
    active_semester = db.query(Semester).filter(Semester.is_current == True).first()
    if not active_semester:
        return []
    
    # 2. جلب المواد عبر عمل Join مع جدول Course لجلب اسم المادة
    # نفترض أن TeacherCourse يحتوي على course_id كـ ForeignKey لجدول Course
    courses_data = db.query(TeacherCourse, Course).join(
        Course, TeacherCourse.course_id == Course.course_id
    ).filter(
        TeacherCourse.teacher_id == teacher_id,
        TeacherCourse.semester_id == active_semester.semester_id
    ).all()
    
    # 3. إرجاع النتيجة مع الاسم الحقيقي للمادة
    results = []
    for tc, course in courses_data:
        results.append({
            "course_id": course.course_id, 
            "course_name": course.course_name  # هنا سيتم جلب الاسم الفعلي
        })
        
    return results



@router.put("/publish-all-results/{exam_id}")
def publish_all_results(exam_id: int, db: Session = Depends(get_db)):
    # جلب جميع أوراق الإجابة المرتبطة بهذا الاختبار
    # نفترض أن جدول أوراق الإجابة اسمه AnswerSheet وأن لديه exam_id
    # في ملف routers/grading.py
    from models.grading import AnswerSheet  # 👈 المسار الصحيح للكلاس    
    sheets = db.query(AnswerSheet).filter(AnswerSheet.exam_id == exam_id).all()
    
    if not sheets:
        return {"message": "لا توجد أوراق للنشر"}
    
    for sheet in sheets:
        sheet.is_published = True
    
    db.commit()
    return {"message": "تم نشر جميع النتائج بنجاح"}





#  cd smart_backend
#  .\venv\Scripts\activate
#  python -m uvicorn main:app --reload
#  cd grade
#  flutter run -d chrome