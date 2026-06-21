import os
import json
import re
import io
import time
from openai import OpenAI
from dotenv import load_dotenv
from sqlalchemy.orm import Session
from models.exams import Exam, Folder, TeacherCourse
from models.grading import Question, ExpectedAnswer
from models.profiles import Course, Teacher
from models.users import User
from models.academic import Department, Level
from schemas.ai_exam import SaveExamRequest
from datetime import datetime

load_dotenv()

# ==========================================
# Gemini API - via OpenAI Proxy
# ==========================================
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")
GEMINI_BASE_URL = os.getenv("GEMINI_BASE_URL", "")

def _call_gemini(prompt: str) -> str:
    """استدعاء Gemini لإنشاء الاختبار عبر مكتبة OpenAI"""
    if not GEMINI_API_KEY or not GEMINI_BASE_URL:
        raise Exception("GEMINI_API_KEY أو GEMINI_BASE_URL غير موجود في ملف .env")

    try:
        print("🔄 جاري استدعاء Gemini...")
        client = OpenAI(api_key=GEMINI_API_KEY, base_url=GEMINI_BASE_URL)
        
        response = client.chat.completions.create(
            model="gemini-1.5-flash",
            messages=[
                {
                    "role": "system",
                    "content": "أنت أستاذ جامعي خبير في إنشاء الاختبارات. أرجع البيانات بصيغة JSON مطابقة للهيكلة المطلوبة."
                },
                {
                    "role": "user",
                    "content": prompt
                }
            ],
            response_format={"type": "json_object"},
            temperature=0.7,
        )
        
        text = response.choices[0].message.content
        print("✅ نجح توليد الاختبار عبر Gemini")
        return text
    except Exception as e:
        raise Exception(f"فشل الاتصال بـ Gemini: {e}")


def _parse_json_response(raw: str) -> dict:
    raw = re.sub(r"```json\s*", "", raw)
    raw = re.sub(r"```\s*", "", raw).strip()
    match = re.search(r'\{.*\}', raw, re.DOTALL)
    if match:
        raw = match.group(0)
    return json.loads(raw)


def _translate_key(key: str) -> str:
    mapping = {
        "MATH": "رياضيات", "PHYSICS": "فيزياء", "CHEMISTRY": "كيمياء",
        "BIOLOGY": "أحياء", "ARABIC": "لغة عربية",
        "L1": "المستوى الأول", "L2": "المستوى الثاني", "L3": "المستوى الثالث",
        "EASY": "سهل", "MEDIUM": "متوسط", "HARD": "صعب",
    }
    return mapping.get(key, key)


# ==========================================
# 1. سياق المجلد
# ==========================================
def get_folder_context(db: Session, folder_id: int) -> dict:
    if folder_id == 0:
        return {
            "folder_id": 0,
            "folder_name": "مجلد تجريبي",
            "course_name": "مادة تجريبية",
            "specialization": "عام",
            "level": "عام",
            "teacher_name": "المعلم",
        }

    folder = db.query(Folder).filter(Folder.folder_id == folder_id).first()
    if not folder:
        return {}

    tc = db.query(TeacherCourse).filter(TeacherCourse.tc_id == folder.tc_id).first()
    if not tc:
        return {}

    course = db.query(Course).filter(Course.course_id == tc.course_id).first()
    dept = db.query(Department).filter(Department.department_id == tc.department_id).first()
    level = db.query(Level).filter(Level.level_id == course.level_id).first() if course else None
    teacher_user = (
        db.query(User)
        .join(Teacher, User.user_id == Teacher.user_id)
        .filter(Teacher.teacher_id == tc.teacher_id)
        .first()
    )

    return {
        "folder_id": folder_id,
        "folder_name": folder.folder_name,
        "course_name": course.course_name if course else "غير محدد",
        "specialization": dept.department_name if dept else "غير محدد",
        "level": level.level_name if level else "غير محدد",
        "teacher_name": teacher_user.full_name if teacher_user else "غير محدد",
    }


# ==========================================
# 2. استخراج نص من الملفات
# ==========================================
async def extract_text_from_files(files: list) -> str:
    extracted = ""
    for file in files:
        if not file or not file.filename:
            continue
        try:
            content = await file.read()
            if file.filename.endswith(".txt"):
                extracted += content.decode("utf-8", errors="ignore") + "\n"
            elif file.filename.endswith(".pdf"):
                try:
                    try:
                        import fitz  # PyMuPDF
                        doc = fitz.open(stream=content, filetype="pdf")
                        for page in doc:
                            extracted += (page.get_text() or "") + "\n"
                    except ImportError:
                        import PyPDF2
                        reader = PyPDF2.PdfReader(io.BytesIO(content))
                        for page in reader.pages:
                            extracted += (page.extract_text() or "") + "\n"
                except Exception as e:
                    print(f"PDF error: {e}")
            elif file.filename.endswith(".docx"):
                try:
                    from docx import Document
                    doc = Document(io.BytesIO(content))
                    extracted += "\n".join([p.text for p in doc.paragraphs]) + "\n"
                except Exception as e:
                    print(f"DOCX error: {e}")
        except Exception as e:
            print(f"File error: {e}")
    return extracted[:40000]


# ==========================================
# 3. توليد الاختبار
# ==========================================
def generate_exam_with_gemini(
    exam_title: str,
    total_grade: float,
    course_name: str,
    specialization: str,
    level: str,
    difficulty: str,
    mcq_count: int,
    tf_count: int,
    essay_count: int,
    match_count: int,
    fill_count: int,
    extracted_text: str = "",
) -> dict:

    total_q = mcq_count + tf_count + essay_count + match_count + fill_count
    if total_q == 0:
        return {"success": False, "message": "عدد الأسئلة يجب أن يكون أكبر من صفر"}

    grade_per_q = round(total_grade / total_q, 2)

    types_list = []
    if mcq_count > 0: types_list.append(f"{mcq_count} سؤال اختيار من متعدد (mcq) بـ 4 خيارات")
    if tf_count > 0: types_list.append(f"{tf_count} سؤال صح أو خطأ (tf)")
    if essay_count > 0: types_list.append(f"{essay_count} سؤال مقالي (essay)")
    if match_count > 0: types_list.append(f"{match_count} سؤال مطابقة (match)")
    if fill_count > 0: types_list.append(f"{fill_count} سؤال أكمل الفراغ (fill) استخدم ___ للفراغ")

    curriculum = (
        f"المنهج المرفق:\n{extracted_text}"
        if extracted_text.strip()
        else "لا يوجد منهج - استخدم معلوماتك الأكاديمية العامة."
    )

    prompt = f"""أنشئ اختباراً أكاديمياً باللغة العربية.

معلومات الاختبار:
- العنوان: {exam_title or 'اختبار أكاديمي'}
- المادة: {course_name}
- التخصص: {specialization}
- المستوى: {level}
- الصعوبة: {_translate_key(difficulty)}
- الدرجة الكلية: {total_grade} ({grade_per_q} لكل سؤال)

{curriculum}

المطلوب توليده:
{chr(10).join(f'- {t}' for t in types_list)}

قواعد مهمة:
- أرجع JSON فقط
- جميع الأسئلة والإجابات بالعربية
- للـ mcq: 4 خيارات واضحة ومختلفة
- للـ tf: options=["صح","خطأ"]
- للـ essay: options=null

JSON المطلوب:
{{
  "keywords": ["كلمة1", "كلمة2", "كلمة3"],
  "questions": [
    {{
      "question_id": 1,
      "question_type": "mcq",
      "question_text": "السؤال هنا؟",
      "options": ["أ", "ب", "ج", "د"],
      "correct_option_index": 0,
      "model_answer": "شرح الإجابة",
      "grade": {grade_per_q},
      "keywords": []
    }}
  ]
}}"""

    try:
        raw = _call_gemini(prompt)
        data = _parse_json_response(raw)
        return {"success": True, "data": data}
    except json.JSONDecodeError as e:
        return {"success": False, "message": f"خطأ في JSON: {e}"}
    except Exception as e:
        return {"success": False, "message": str(e)}


# ==========================================
# 4. حفظ الاختبار
# ==========================================
def save_generated_exam(db: Session, req: SaveExamRequest) -> dict:
    try:
        total_marks = sum(q.grade for q in req.questions)
        exam_date = datetime.utcnow().date()
        if req.exam_date:
            try:
                exam_date = datetime.strptime(req.exam_date, "%Y-%m-%d").date()
            except ValueError:
                pass

        new_exam = Exam(
            folder_id=req.folder_id,
            exam_title=req.exam_title,
            number_of_questions=len(req.questions),
            total_marks=total_marks,
            passing_mark=total_marks * 0.6,
            allowed_time=req.allowed_time or "ساعة واحدة",
            status="Draft",
            exam_date=exam_date,
        )
        db.add(new_exam)
        db.flush()

        for order, q in enumerate(req.questions, start=1):
            new_q = Question(
                exam_id=new_exam.exam_id,
                question_text=q.question_text,
                question_mark=q.grade,
                question_order=order,
                question_type=q.question_type,
            )
            db.add(new_q)
            db.flush()

            db.add(ExpectedAnswer(
                question_id=new_q.question_id,
                answer_text=q.model_answer,
                is_correct=True,
                keywords=", ".join(q.keywords) if q.keywords else None,
            ))

            if q.question_type == "mcq" and q.options:
                for i, opt in enumerate(q.options):
                    if opt and i != q.correct_option_index:
                        db.add(ExpectedAnswer(
                            question_id=new_q.question_id,
                            answer_text=str(opt),
                            is_correct=False,
                        ))

        db.commit()
        return {"success": True, "message": "تم الحفظ بنجاح", "exam_id": new_exam.exam_id}

    except Exception as e:
        db.rollback()
        return {"success": False, "message": f"فشل الحفظ: {e}", "exam_id": None}