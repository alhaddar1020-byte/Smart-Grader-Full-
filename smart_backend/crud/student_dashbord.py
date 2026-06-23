

from sqlalchemy.orm import Session
from sqlalchemy import text
from fastapi.encoders import jsonable_encoder
from datetime import date
from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks
from db.database import get_db 
from models.users import User 
from pydantic import BaseModel, EmailStr
from deep_translator import GoogleTranslator

router = APIRouter(prefix="/views", tags=["Student Views Features"])

# ── الدوال المساعدة السحرية ──────────────────────────────────────────

def get_text(lang: str, ar: str, en: str) -> str:
    """🌟 دالة ذكية لإرجاع النص باللغة المناسبة"""
    return en if lang == 'en' else ar

def translate_live(text_data: str, lang: str) -> str:
    """🌟 دالة الترجمة الحية للنصوص المتغيرة"""
    if not text_data:
        return ""
    if lang == 'en':
        try:
            return GoogleTranslator(source='ar', target='en').translate(text_data)
        except Exception:
            return text_data
    return text_data

def resolve_student_id(db: Session, student_id: int) -> int:
    """🌟 الدالة المنقذة: تترجم الـ user_id إلى student_id تلقائياً"""
    real = db.execute(
        text("SELECT student_id FROM student WHERE user_id = :id OR student_id = :id LIMIT 1"),
        {"id": student_id}
    ).scalar()
    return real if real else student_id




@router.get("/student-dashboard/{student_id}")
def get_student_dashboard_data(student_id: int, lang: str = 'ar', db: Session = Depends(get_db)):
    user_lang = lang
    student_id = resolve_student_id(db, student_id)
    
    # 1. تحديد السنة الأكاديمية النشطة بدقة
    current_year_query = text("SELECT academic_year FROM semesters WHERE is_current = true LIMIT 1")
    active_year = db.execute(current_year_query).scalar()
    if not active_year:
        active_year = db.execute(text("SELECT academic_year FROM semesters ORDER BY semester_id DESC LIMIT 1")).scalar()

    # 2. بيانات الطالبة
    profile_query = text("""
        SELECT u.full_name, l.level_name, d.department_name, u.language_code
        FROM student s
        JOIN users u ON s.user_id = u.user_id
        JOIN level l ON s.level_id = l.level_id
        JOIN department d ON s.department_id = d.department_id
        WHERE s.student_id = :sid
    """)
    profile = db.execute(profile_query, {"sid": student_id}).mappings().first()
    # removed user_lang DB override

    # 3. الإحصائيات (المعدل التراكمي الصحيح + سحب درجات أعلى نتيجة)
    stats_query = text("""
        WITH LatestSheets AS (
            SELECT ans.exam_id, ans.total_earned_mark, e.total_marks, e.passing_mark,
                   ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
            FROM answer_sheet ans
            JOIN exam e ON ans.exam_id = e.exam_id
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id
            JOIN semesters s ON tc.semester_id = s.semester_id
            WHERE ans.student_id = :sid 
              AND ans.status IN ('Graded', 'graded')
              AND ans.is_published = true 
              AND s.academic_year = :year
        ),
        ValidSheets AS (
            SELECT * FROM LatestSheets WHERE rn = 1
        )
        SELECT 
            (SELECT COUNT(*) FROM ValidSheets) AS exams_taken,
            (SELECT COALESCE((SUM(CAST(total_earned_mark AS FLOAT)) / NULLIF(SUM(total_marks), 0)) * 100, 0) FROM ValidSheets) AS gpa,
            (SELECT COALESCE(SUM(CASE WHEN total_earned_mark >= passing_mark THEN 1 ELSE 0 END), 0) FROM ValidSheets) AS passed_exams,
            (SELECT total_earned_mark FROM ValidSheets ORDER BY (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) DESC LIMIT 1) AS top_earned,
            (SELECT total_marks FROM ValidSheets ORDER BY (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) DESC LIMIT 1) AS top_total
    """)
    stats = db.execute(stats_query, {"sid": student_id, "year": active_year}).mappings().first()

    # 4. عدد المواد للسنة النشطة
    subjects_query = text("""
        SELECT COUNT(DISTINCT sc.course_id)
        FROM student_courses sc
        JOIN semesters s ON sc.semester_id = s.semester_id
        WHERE sc.student_id = :sid AND s.academic_year = :year
    """)
    subjects_count = db.execute(subjects_query, {"sid": student_id, "year": active_year}).scalar() or 0

    # 5. عدد الأسئلة الصحيحة
    questions_query = text("""
        WITH LatestSheets AS (
            SELECT ans.sheet_id, ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
            FROM answer_sheet ans
            JOIN exam e ON ans.exam_id = e.exam_id
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id
            JOIN semesters s ON tc.semester_id = s.semester_id
            WHERE ans.student_id = :sid 
              AND ans.status IN ('Graded', 'graded')
              AND ans.is_published = true
              AND s.academic_year = :year
        )
        SELECT COUNT(sa.answer_id)
        FROM student_answers sa
        JOIN questions q ON sa.question_id = q.question_id  
        JOIN LatestSheets ls ON sa.sheet_id = ls.sheet_id AND ls.rn = 1
        WHERE COALESCE(sa.teacher_mark, sa.ai_mark) >= q.question_mark - 0.1
    """)
    correct_questions_count = db.execute(questions_query, {"sid": student_id, "year": active_year}).scalar() or 0
    
    g_ex = get_text(user_lang, "امتياز", "Excellent")
    g_vg = get_text(user_lang, "جيد جداً", "Very Good")
    g_gd = get_text(user_lang, "جيد", "Good")
    g_pa = get_text(user_lang, "مقبول", "Pass")
    g_fa = get_text(user_lang, "ضعيف", "Fail")

    # 6. آخر النتائج 
    recent_query = text("""
        WITH LatestSheets AS (
            SELECT ans.total_earned_mark, e.total_marks, e.exam_id, e.exam_title, ans.uploaded_at, e.number_of_questions,ans.is_read, c.course_name,
                   ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
            FROM answer_sheet ans
            JOIN exam e ON ans.exam_id = e.exam_id
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id
            JOIN courses c ON tc.course_id = c.course_id
            JOIN semesters s ON tc.semester_id = s.semester_id
            WHERE ans.student_id = :sid 
              AND ans.status IN ('Graded', 'graded')
              AND ans.is_published = true
              AND s.academic_year = :year
        )
        SELECT course_name, exam_title, total_earned_mark, total_marks, uploaded_at, number_of_questions, exam_id,is_read,
               CASE 
                   WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 90 THEN :g_ex
                   WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 80 THEN :g_vg
                   WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 70 THEN :g_gd
                   WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 50 THEN :g_pa
                   ELSE :g_fa
               END as grade_text
        FROM LatestSheets WHERE rn = 1
        ORDER BY uploaded_at DESC LIMIT 3
    """)
    recent_results = db.execute(recent_query, {"sid": student_id, "year": active_year, "g_ex": g_ex, "g_vg": g_vg, "g_gd": g_gd, "g_pa": g_pa, "g_fa": g_fa}).mappings().fetchall()
    
    # 7. معالجة الإحصائيات والأرقام للعرض
    exams_taken = int(stats["exams_taken"]) if stats and stats["exams_taken"] is not None else 0
    passed_exams = int(stats["passed_exams"]) if stats and stats["passed_exams"] is not None else 0
    gpa = float(stats["gpa"]) if stats and stats["gpa"] is not None else 0
    
    # تجهيز كسر "أعلى نتيجة"
    top_earned = float(stats["top_earned"]) if stats and stats["top_earned"] is not None else 0
    top_total = float(stats["top_total"]) if stats and stats["top_total"] is not None else 0
    highest_score_display = f"{round(top_earned)} / {round(top_total)}" if top_total > 0 else "0 / 0"
    
    success_rate = (passed_exams / exams_taken * 100) if exams_taken > 0 else 0
    
    if success_rate >= 85:
        level = get_text(user_lang, "مستوى ممتاز", "Excellent")
    elif success_rate >= 70:
        level = get_text(user_lang, "مستوى جيد", "Good")
    else:
        level = get_text(user_lang, "يحتاج تحسين", "Needs Improvement")
        
    formatted_recent = []
    for row in recent_results:
        total_m = float(row["total_marks"]) if row["total_marks"] else 0
        earned_m = float(row["total_earned_mark"]) if row["total_earned_mark"] else 0
        percentage = (earned_m / total_m) * 100 if total_m > 0 else 0
        
        formatted_recent.append({
            "id": str(row["exam_id"]),
            "score": f"{round(percentage)}%", 
            "total_earned_mark": str(round(earned_m)), 
            "label": row["grade_text"],
            "title": row["exam_title"],
            "subject": row["course_name"] or get_text(user_lang, "غير معروف", "Unknown"),
            "date": str(row["uploaded_at"])[:10] if row["uploaded_at"] else "",
            "total_questions": str(row["number_of_questions"] or 0),
            "answered_questions": "0", 
            "is_read": row["is_read"] 
        })
    
    level_val = translate_live(profile['level_name'], user_lang) if profile else ""
    dept_val = translate_live(profile['department_name'], user_lang) if profile else ""

    if profile:
        level_display = f"{level_val} - {dept_val}" if dept_val else level_val
    else:
        level_display = ""

    return {
        "name": profile["full_name"] if profile else get_text(user_lang, "غير معروف", "Unknown"),
        "level": level_display, # 👈 استخدمنا المتغير الذكي هنا
        "badge": f"{round(gpa)}", 
        "stats": {
            "highest_score": highest_score_display, # 👈 ستعرض الآن مثل: "35 / 40"
            "gpa": f"{round(gpa, 1)}%",
            "exams_count": str(exams_taken), 
            "subjects_count": str(subjects_count),
        },
        "recent_results": formatted_recent,
        "performance": {
            "graded_exams": str(passed_exams),              
            "total_exams": str(exams_taken),               
            "success_rate": f"{round(success_rate, 1)}%",   
            "average_ai_score": f"{round(gpa, 1)}%",        
            "performance_level": level,
            "questions_mastered": str(correct_questions_count),      
        }
    }





@router.get("/student-subjects/{student_id}")
def get_student_subjects_data(student_id: int, lang: str = 'ar', db: Session = Depends(get_db)):
    user_lang = lang
    student_id = resolve_student_id(db, student_id)
    # removed lang_query
    # removed user_lang DB override

    # 1. تحديد السنة الأكاديمية النشطة حالياً (حجر الأساس)
    current_year_query = text("SELECT academic_year FROM semesters WHERE is_current = true LIMIT 1")
    active_year = db.execute(current_year_query).scalar()
    if not active_year:
        # لو مافي ترم نشط، نجيب أحدث سنة في النظام
        active_year = db.execute(text("SELECT academic_year FROM semesters ORDER BY semester_id DESC LIMIT 1")).scalar()

    # 2. جلب الأطرام الخاصة بهذه السنة الأكاديمية فقط
    semesters_query = text("""
        SELECT DISTINCT sem.semester_id, sem.semester_name 
        FROM student_courses sc
        JOIN semesters sem ON sc.semester_id = sem.semester_id 
        WHERE sc.student_id = :sid AND sem.academic_year = :year
        ORDER BY sem.semester_id
    """)
    semesters_records = db.execute(semesters_query, {"sid": student_id, "year": active_year}).fetchall()
    semesters_list = [{"id": sem.semester_id, "name": translate_live(sem.semester_name, user_lang)} for sem in semesters_records]

    # 3. حساب الإحصائيات العلوية معزولة لكل ترم (بطريقة آمنة بدون تكرار)
    stats_query = text("""
        WITH LatestSheets AS (
            SELECT ans.exam_id, ans.total_earned_mark, tc.semester_id, e.total_marks,
                   ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
            FROM answer_sheet ans
            JOIN exam e ON ans.exam_id = e.exam_id
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id
            JOIN semesters sem ON tc.semester_id = sem.semester_id
            WHERE ans.student_id = :sid 
              AND ans.status IN ('Graded', 'graded')
              AND ans.is_published = true
              AND sem.academic_year = :year
        ),
        ValidSheets AS (
            -- تصفية أحدث الأوراق لكل اختبار، وتحديد أفضل اختبار في الترم كنسبة
            SELECT semester_id, exam_id, total_earned_mark, total_marks,
                   ROW_NUMBER() OVER(PARTITION BY semester_id ORDER BY (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) DESC) as rank_in_sem
            FROM LatestSheets WHERE rn = 1
        ),
        SemesterExamStats AS (
            -- حساب المعدل والمجاميع للترم
            SELECT semester_id,
                   COUNT(exam_id) as exams_count,
                   SUM(total_earned_mark) as sum_earned,
                   SUM(total_marks) as sum_total
            FROM ValidSheets
            GROUP BY semester_id
        ),
        SemesterTopExam AS (
            -- سحب أعلى نتيجة لكل ترم
            SELECT semester_id, total_earned_mark as top_earned, total_marks as top_total
            FROM ValidSheets
            WHERE rank_in_sem = 1
        ),
        SemesterCourseStats AS (
            -- حساب عدد المواد للترم
            SELECT sc.semester_id, COUNT(DISTINCT sc.course_id) as subjects_count
            FROM student_courses sc
            JOIN semesters sem ON sc.semester_id = sem.semester_id
            WHERE sc.student_id = :sid AND sem.academic_year = :year
            GROUP BY sc.semester_id
        )
        SELECT 
            cs.semester_id,
            cs.subjects_count,
            COALESCE(es.exams_count, 0) AS exams_count,
            COALESCE((CAST(es.sum_earned AS FLOAT) / NULLIF(es.sum_total, 0)) * 100, 0) AS avg_percentage,
            COALESCE(te.top_earned, 0) AS top_earned,
            COALESCE(te.top_total, 0) AS top_total
        FROM SemesterCourseStats cs
        LEFT JOIN SemesterExamStats es ON cs.semester_id = es.semester_id
        LEFT JOIN SemesterTopExam te ON cs.semester_id = te.semester_id
    """)
    stats_records = db.execute(stats_query, {"sid": student_id, "year": active_year}).fetchall()
    
    stats_by_semester = {
        row.semester_id: {
            "highest_score": f"{round(row.top_earned)} / {round(row.top_total)}" if row.top_total > 0 else "0 / 0", 
            "average_score": f"{round(row.avg_percentage or 0, 1)}%", 
            "total_exams": str(row.exams_count or 0),
            "total_subjects": str(row.subjects_count or 0)
        } for row in stats_records
    }

    # 4. جلب تفاصيل المواد معزولة بالترم ومجموع الدرجات الفعلي
    subjects_query = text("""
        WITH LatestSheets AS (
            SELECT ans.exam_id, e.exam_date, ans.total_earned_mark, tc.course_id, tc.semester_id,
                   ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
            FROM answer_sheet ans
            JOIN exam e ON ans.exam_id = e.exam_id
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id
            JOIN semesters sem ON tc.semester_id = sem.semester_id
            WHERE ans.student_id = :sid 
              AND ans.status IN ('Graded', 'graded')
              AND ans.is_published = true
              AND sem.academic_year = :year
        )
        SELECT c.course_id, c.course_name, sc.semester_id,
            (SELECT u.full_name FROM teacher_courses tc_t JOIN teacher t ON tc_t.teacher_id = t.teacher_id
             JOIN users u ON t.user_id = u.user_id WHERE tc_t.course_id = c.course_id AND tc_t.semester_id = sc.semester_id LIMIT 1) AS teacher_name,
            COUNT(DISTINCT ls.exam_id) AS exams_taken, 
            COALESCE(SUM(ls.total_earned_mark), 0) AS subject_total_score,
            MAX(ls.exam_date) AS last_exam_date
        FROM student_courses sc 
        JOIN courses c ON sc.course_id = c.course_id
        JOIN semesters sem ON sc.semester_id = sem.semester_id
        LEFT JOIN LatestSheets ls ON c.course_id = ls.course_id AND ls.semester_id = sc.semester_id AND ls.rn = 1
        WHERE sc.student_id = :sid AND sem.academic_year = :year
        GROUP BY c.course_id, c.course_name, sc.semester_id
    """)
    subjects_records = db.execute(subjects_query, {"sid": student_id, "year": active_year}).fetchall()

    semester_data = {}
    for sem in semesters_list:
        sem_id_str = str(sem["id"])
        semester_data[sem_id_str] = {
            "top_stats": stats_by_semester.get(sem["id"], {"highest_score": "0 / 0", "average_score": "0%", "total_exams": "0", "total_subjects": "0"}),
            "subjects": []
        }

    for row in subjects_records:
        sem_id_str = str(row.semester_id)
        if sem_id_str in semester_data:
            teacher_prefix = get_text(user_lang, 'أ. ', 'Mr./Ms. ')
            teacher_val = f"{teacher_prefix}{row.teacher_name}" if row.teacher_name else get_text(user_lang, "غير محدد", "Not specified")
            
            semester_data[sem_id_str]["subjects"].append({
                "name": row.course_name or get_text(user_lang, "غير معروف", "Unknown"),
                "teacher": teacher_val,
                "total_earned_mark": str(round(row.subject_total_score or 0)),
                "exams": str(row.exams_taken or 0),
                "lastExam": row.last_exam_date.strftime("%Y-%m-%d") if row.last_exam_date else get_text(user_lang, "لا يوجد", "None")
            })

    return {"semesters": semesters_list, "semester_data": semester_data}




@router.get("/subject-details/{student_id}/{course_name}")
def get_subject_details_data(student_id: int, course_name: str, lang: str = 'ar', db: Session = Depends(get_db)):
    user_lang = lang
    student_id = resolve_student_id(db, student_id)
    # removed lang_query
    # removed user_lang DB override

    # 1. سحب السنة النشطة لضمان تطابق البيانات مع الداشبورد
    current_year_query = text("SELECT academic_year FROM semesters WHERE is_current = true LIMIT 1")
    active_year = db.execute(current_year_query).scalar()
    if not active_year:
        active_year = db.execute(text("SELECT academic_year FROM semesters ORDER BY semester_id DESC LIMIT 1")).scalar()

    # 2. إحصائيات المادة (محسوبة بالكسور لعرض الدرجات الفعلية للمين والماكس)
    stats_query = text("""
        WITH LatestSheets AS (
            SELECT ans.exam_id, ans.total_earned_mark, e.total_marks, tc.course_id,
                   ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
            FROM answer_sheet ans
            JOIN exam e ON ans.exam_id = e.exam_id
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id
            JOIN courses c ON tc.course_id = c.course_id
            JOIN semesters sem ON tc.semester_id = sem.semester_id
            WHERE ans.student_id = :sid 
              AND c.course_name = :cname 
              AND ans.status IN ('Graded', 'graded')
              AND ans.is_published = true
              AND sem.academic_year = :year
        ),
        ValidSheets AS (
            SELECT * FROM LatestSheets WHERE rn = 1
        )
        SELECT 
            (SELECT COUNT(*) FROM ValidSheets) AS exams_count,
            (SELECT COALESCE((SUM(CAST(total_earned_mark AS FLOAT)) / NULLIF(SUM(total_marks), 0)) * 100, 0) FROM ValidSheets) AS avg_grade_pct,
            (SELECT total_earned_mark FROM ValidSheets ORDER BY (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) DESC LIMIT 1) AS max_earned,
            (SELECT total_marks FROM ValidSheets ORDER BY (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) DESC LIMIT 1) AS max_total,
            (SELECT total_earned_mark FROM ValidSheets ORDER BY (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) ASC LIMIT 1) AS min_earned,
            (SELECT total_marks FROM ValidSheets ORDER BY (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) ASC LIMIT 1) AS min_total
    """)
    stats = db.execute(stats_query, {"sid": student_id, "cname": course_name, "year": active_year}).mappings().first()

    g_ex = get_text(user_lang, "امتياز", "Excellent")
    g_vg = get_text(user_lang, "جيد جداً", "Very Good")
    g_gd = get_text(user_lang, "جيد", "Good")
    g_pa = get_text(user_lang, "مقبول", "Pass")
    g_fa = get_text(user_lang, "ضعيف", "Fail")

    # 3. قائمة الاختبارات (مرتبة حسب التسليم، ومضاف إليها exam_id للربط)
    # 3. قائمة الاختبارات (مرتبة حسب التسليم، ومضاف إليها exam_id للربط)
    exams_query = text("""
        WITH LatestSheets AS (
            -- 🌟 التعديل هنا: سحبنا e.exam_date (تاريخ الاختبار) واحتفظنا بـ uploaded_at بس للترتيب
            SELECT ans.sheet_id, ans.total_earned_mark, e.total_marks, e.exam_title, e.exam_id, e.exam_date, ans.uploaded_at, e.number_of_questions,
                   ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
            FROM answer_sheet ans 
            JOIN exam e ON ans.exam_id = e.exam_id 
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id 
            JOIN courses c ON tc.course_id = c.course_id
            JOIN semesters sem ON tc.semester_id = sem.semester_id
            WHERE ans.student_id = :sid 
              AND c.course_name = :cname 
              AND ans.status IN ('Graded', 'graded')
              AND ans.is_published = true
              AND sem.academic_year = :year
        )
        -- 🌟 التعديل هنا: نطلب exam_date عشان نرسله لفلاتر
        SELECT exam_id, exam_title, exam_date, uploaded_at, total_earned_mark, total_marks, number_of_questions,
            (SELECT COUNT(*) FROM student_answers sa WHERE sa.sheet_id = ls.sheet_id) AS answered_count,
            CASE 
                WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 90 THEN :g_ex
                WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 80 THEN :g_vg
                WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 70 THEN :g_gd
                WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 50 THEN :g_pa
                ELSE :g_fa
            END as rating
        FROM LatestSheets ls WHERE rn = 1 ORDER BY uploaded_at DESC
    """)
    exams_records = db.execute(exams_query, {
        "sid": student_id, "cname": course_name, "year": active_year, 
        "g_ex": g_ex, "g_vg": g_vg, "g_gd": g_gd, "g_pa": g_pa, "g_fa": g_fa
    }).mappings().fetchall()

    formatted_exams = []
    for row in exams_records:
        formatted_exams.append({
            "exam_id": str(row["exam_id"]), 
            "title": row["exam_title"],
            # 🌟 التعديل هنا: صرنا نرسل تاريخ الاختبار الفعلي. إذا مافي تاريخ، نرسل فراغ وفلاتر بيتكفل بالباقي ويكتب "غير محدد"
            "date": row["exam_date"].strftime("%Y-%m-%d") if row["exam_date"] else "",
            "total_earned_mark": str(round(row["total_earned_mark"] or 0)), 
            "total_marks": str(round(row["total_marks"] or 0)),
            "total": str(row["number_of_questions"] or 0),            
            "answers": str(row["answered_count"] or 0),                
            "rating": row["rating"]
        })

    # معالجة المتغيرات وتنسيق الكسور
    avg = float(stats["avg_grade_pct"]) if stats and stats["avg_grade_pct"] is not None else 0.0
    exams_count = int(stats["exams_count"]) if stats and stats["exams_count"] is not None else 0

    max_e = float(stats["max_earned"]) if stats and stats["max_earned"] is not None else 0
    max_t = float(stats["max_total"]) if stats and stats["max_total"] is not None else 0
    min_e = float(stats["min_earned"]) if stats and stats["min_earned"] is not None else 0
    min_t = float(stats["min_total"]) if stats and stats["min_total"] is not None else 0

    max_display = f"{round(max_e)} / {round(max_t)}" if max_t > 0 else "0 / 0"
    min_display = f"{round(min_e)} / {round(min_t)}" if min_t > 0 else "0 / 0"

    # 4. تقييم الذكاء الاصطناعي
    ai_summary_query = text("""
        SELECT sc.subject_strengths, sc.subject_weaknesses
        FROM student_courses sc
        JOIN courses c ON sc.course_id = c.course_id
        JOIN semesters sem ON sc.semester_id = sem.semester_id
        WHERE sc.student_id = :sid AND c.course_name = :cname AND sem.academic_year = :year
    """)
    ai_summary = db.execute(ai_summary_query, {"sid": student_id, "cname": course_name, "year": active_year}).mappings().first()

    if ai_summary:
        if ai_summary["subject_strengths"]:
            translated_strengths = translate_live(ai_summary["subject_strengths"], user_lang)
            strengths = translated_strengths.split('\n')
        else:
            strengths = [get_text(user_lang, "في انتظار تقييم الذكاء الاصطناعي...", "Waiting for AI evaluation...")]

        if ai_summary["subject_weaknesses"]:
            translated_weaknesses = translate_live(ai_summary["subject_weaknesses"], user_lang)
            improvements = translated_weaknesses.split('\n')
        else:
            improvements = [get_text(user_lang, "في انتظار تقييم الذكاء الاصطناعي...", "Waiting for AI evaluation...")]
    else:
        strengths = [get_text(user_lang, "لا توجد بيانات حالياً", "No data available")]
        improvements = [get_text(user_lang, "لا توجد بيانات حالياً", "No data available")]

    return {
        "stats": {
            "min": min_display, # 👈 ستعرض بصيغة: "15 / 30"
            "max": max_display, # 👈 ستعرض بصيغة: "45 / 50"
            "avg": f"{round(avg, 1)}%",                  
            "count": str(exams_count)                    
        },
        "exams": formatted_exams,
        "strengths": strengths,
        "improvements": improvements
    }



@router.get("/exam-details/{student_id}/{exam_id}")
def get_exam_details_data(student_id: int, exam_id: int, db: Session = Depends(get_db)):
    student_id = resolve_student_id(db, student_id)
    # removed lang_query
    # removed user_lang DB override

    # 1. سحب بيانات الاختبار المحمية والمؤكدة
    stats_query = text("""
        SELECT 
            ans.sheet_id, ans.total_earned_mark, e.exam_id, e.total_marks
        FROM answer_sheet ans
        JOIN exam e ON ans.exam_id = e.exam_id
        WHERE ans.student_id = :sid 
          AND e.exam_id = :eid
          AND ans.status IN ('Graded', 'graded')
          AND ans.is_published = true
        ORDER BY ans.uploaded_at DESC
        LIMIT 1
    """)
    stats_record = db.execute(stats_query, {"sid": student_id, "eid": exam_id}).mappings().first()

    # حماية من الانهيار في حال لا توجد بيانات
    if not stats_record:
        return {
            "stats": {
                "exam_id": str(exam_id), 
                "total_earned_mark": "0", 
                "total_marks": "0", 
                "score_display": "0 / 0", # 👈 إضافة التنسيق الجديد
                "total_questions": "0", 
                "correct": "0", 
                "wrong": "0", 
                "partial": "0"
            },
            "questions": [],
            "paper_images": []
        }

    sheet_id = stats_record["sheet_id"]
    total_earned_mark = stats_record["total_earned_mark"] or 0
    total_marks = stats_record["total_marks"] or 100

    # 2. سحب الأسئلة والتقييمات
    questions_query = text("""
        SELECT 
            q.question_id, q.question_order, q.question_text, q.question_mark AS total,
            sa.extracted_text AS student_answer, sa.teacher_mark, sa.ai_mark, sa.ai_feedback AS evaluation,
            ea.answer_text AS model_answer
        FROM questions q
        LEFT JOIN student_answers sa ON q.question_id = sa.question_id AND sa.sheet_id = :sheet_id
        LEFT JOIN expected_answers ea ON q.question_id = ea.question_id
        WHERE q.exam_id = :exam_id
        ORDER BY q.question_order ASC
    """)
    questions_records = db.execute(questions_query, {"sheet_id": sheet_id, "exam_id": exam_id}).mappings().fetchall()

    correct_count = 0
    wrong_count = 0
    partial_count = 0
    formatted_questions = []

    for row in questions_records:
        total_q_mark = float(row["total"] or 0.0)
        t_mark = row["teacher_mark"]
        a_mark = row["ai_mark"]
        earned_score = float(t_mark) if t_mark is not None else float(a_mark) if a_mark is not None else 0.0

        # شرط دقيق للكسور (هامش خطأ 0.1)
        if earned_score >= (total_q_mark - 0.1) and total_q_mark > 0:
            correct_count += 1
        elif earned_score <= 0.1 or (t_mark is None and a_mark is None):
            wrong_count += 1
        else:
            partial_count += 1

        eval_text = row["evaluation"]
        final_evaluation = translate_live(eval_text, user_lang) if eval_text else get_text(user_lang, "في انتظار التقييم الذكي", "Waiting for AI evaluation")

        formatted_questions.append({
            "id": str(row["question_order"] or 1),
            "text": row["question_text"] or get_text(user_lang, "بدون نص", "No text"),
            "score": round(earned_score, 2),
            "total": round(total_q_mark, 2),
            "score_display": f"{round(earned_score, 1)} / {round(total_q_mark, 1)}", # 👈 إضافة التنسيق الموحد لكل سؤال
            "modelAnswer": row["model_answer"] or get_text(user_lang, "الإجابة النموذجية قيد المراجعة", "Model answer under review"),
            "studentAnswer": row["student_answer"] or get_text(user_lang, "لم يتم استخراج الإجابة", "Answer not extracted"),
            "evaluation": final_evaluation 
        })

    # 3. سحب ومعالجة روابط الصور (Supabase / Local)
    images_query = text("SELECT image_path FROM sheet_images WHERE sheet_id = :sheet_id ORDER BY page_number ASC")
    images_records = db.execute(images_query, {"sheet_id": sheet_id}).mappings().fetchall()
    
    RENDER_BASE_URL = "https://smart-grader-full.onrender.com/" 
    paper_images = []
    
    for row in images_records:
        path = row["image_path"]
        if path:
            # إذا كان الرابط يبدأ بـ http، فهو رابط سوبابيس كامل، نستخدمه كما هو
            if path.startswith("http"):
                paper_images.append(path)
            else:
                # مسار محلي
                paper_images.append(f"{RENDER_BASE_URL}{path.lstrip('/')}")

    return {
        "stats": {
            "exam_id": str(exam_id),
            "total_earned_mark": str(round(total_earned_mark)),
            "total_marks": str(round(total_marks)),
            "score_display": f"{round(total_earned_mark)} / {round(total_marks)}", # 👈 عرض نتيجة الاختبار كاملة بصيغة الكسر
            "total_questions": str(len(formatted_questions)),
            "correct": str(correct_count),
            "wrong": str(wrong_count),
            "partial": str(partial_count),
        },
        "questions": formatted_questions,
        "paper_images": paper_images
    }


# أضيفي هذا المسار في ملف views.py
# أضيفي هذا المسار في ملف views.py
# @router.put("/mark-result-read/{student_id}/{exam_id}")
# def mark_result_as_read(student_id: int, exam_id: int, db: Session = Depends(get_db)):
#     try:
#         # 🌟 التعديل السحري: ترجمة الـ ID من فلاتر إلى الـ ID الحقيقي في قاعدة البيانات
#         real_student_id = resolve_student_id(db, student_id)
        
#         # التحديث الآن يتم باستخدام الـ ID الصحيح (real_student_id)
#         query = text("""
#             UPDATE answer_sheet 
#             SET is_read = TRUE 
#             WHERE student_id = :sid AND exam_id = :eid
#         """)
        
#         result = db.execute(query, {"sid": real_student_id, "eid": exam_id})
#         db.commit()

#         if result.rowcount == 0:
#             raise HTTPException(status_code=404, detail="النتيجة غير موجودة")

#         return {"status": "success", "message": "تم تحديد النتيجة كمقروءة"}
    
#     except Exception as e:
#         db.rollback()
#         raise HTTPException(status_code=500, detail="خطأ في تحديث حالة النتيجة")

# @router.put("/mark-result-read/{student_id}/{exam_id}")
# def mark_result_as_read(student_id: int, exam_id: int, db: Session = Depends(get_db)):
#     try:
#         # 1. طباعة رادار تتبع المشكلة (عشان نشوف الأرقام في شاشة ريندر)
#         print(f"\n--- 🎯 رادار التحديث | الطالب القادم من فلاتر: {student_id} | الاختبار: {exam_id} ---")
        
#         # 2. الاستعلام النووي: يخلي قاعدة البيانات هي اللي تدور على الطالب سواء كان بـ user_id أو student_id وتحدثه فوراً
#         query = text("""
#             UPDATE answer_sheet 
#             SET is_read = TRUE 
#             WHERE exam_id = :eid 
#             AND student_id IN (
#                 SELECT student_id FROM student WHERE student_id = :sid OR user_id = :sid
#             )
#         """)
        
#         result = db.execute(query, {"sid": student_id, "eid": exam_id})
#         db.commit()

#         # 3. طباعة نتيجة المعركة
#         print(f"--- 🏁 عدد الصفوف التي تم تحديثها في الداتا بيس: {result.rowcount} ---\n")

#         # حتى لو ما لقى النتيجة، بنقول لفلاتر "تم" عشان ما يعلق الواجهة
#         if result.rowcount == 0:
#             print("⚠️ تحذير: لم يتم العثور على النتيجة في الداتا بيس! (تأكدي من الأرقام)")
#             return {"status": "warning", "message": "لم يتم العثور على النتيجة، لكن التطبيق سيستمر."}

#         return {"status": "success", "message": "تم تحديد النتيجة كمقروءة بنجاح"}
    
#     except Exception as e:
#         db.rollback()
#         print(f"--- ❌ خطأ قاتل أثناء التحديث: {e} ---")
#         return {"status": "error", "message": str(e)}

# @router.put("/mark-result-read/{student_id}/{exam_id}")
# def mark_result_as_read(student_id: int, exam_id: int, db: Session = Depends(get_db)):
#     try:
#         # نترجم الـ ID عشان نضمن إنه يطابق الجدول
#         real_student_id = resolve_student_id(db, student_id)
        
#         # استعلام مرن جداً يضمن التحديث بدون انهيار
#         query = text("""
#             UPDATE answer_sheet 
#             SET is_read = TRUE 
#             WHERE exam_id = :eid AND (student_id = :sid OR student_id = :real_sid)
#         """)
        
#         db.execute(query, {"sid": student_id, "eid": exam_id, "real_sid": real_student_id})
#         db.commit()

#         # 🌟 شلنا شرط الـ 404 المزعج! الحين بيرد بنجاح دائماً وفلاتر بيخفي النقطة فوراً
#         return {"status": "success", "message": "تم تحديث الحالة"}
    
#     except Exception as e:
#         db.rollback()
#         # نرد بـ 200 مع رسالة الخطأ عشان فلاتر ما ينهار
#         return {"status": "error", "message": str(e)}



def mark_result_as_read_data(db, student_id: int, exam_id: int):
    try:
        print(f"\n--- 🎯 رادار التحديث (CRUD) | الطالب: {student_id} | الاختبار: {exam_id} ---")
        
        query = text("""
            UPDATE answer_sheet 
            SET is_read = TRUE 
            WHERE exam_id = :eid 
            AND student_id IN (
                SELECT student_id FROM student WHERE student_id = :sid OR user_id = :sid
            )
        """)
        
        result = db.execute(query, {"sid": student_id, "eid": exam_id})
        db.commit()

        print(f"--- 🏁 عدد الصفوف التي تم تحديثها: {result.rowcount} ---\n")
        return {"status": "success", "message": "تم تحديث النتيجة"}
        
    except Exception as e:
        db.rollback()
        print(f"--- ❌ خطأ في CRUD أثناء التحديث: {e} ---")
        return {"status": "error", "message": str(e)}