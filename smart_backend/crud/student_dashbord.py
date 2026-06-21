# # from sqlalchemy.orm import Session
# # from sqlalchemy import text
# # from fastapi.encoders import jsonable_encoder
# # from datetime import date
# # from fastapi import APIRouter, Depends, HTTPException,BackgroundTasks
# # from db.database import get_db 
# # from models import User 
# # from pydantic import BaseModel, EmailStr

# # # ── استيراد حزمة الترجمة التلقائية السحرية بأمان ──────────────────────────────────────────
# # from deep_translator import GoogleTranslator

# # router = APIRouter(prefix="/views", tags=["Student Views Features"])

# # # ══════════════════════════════════════════════════════════════════════════════
# # # 🌍 محرك الترجمة الذكي والمصفّح (يعزل المواد والاختبارات ويترجم الثوابت والتقديرات)
# # # ══════════════════════════════════════════════════════════════════════════════

# # # def auto_translate_payload_direct(data, target_lang: str, exclude_keys=None):

# # #     if exclude_keys is None:
# # #         exclude_keys = {
# # #             "name",
# # #             "subject",
# # #             "title",
# # #             "course_name",
# # #             "exam_title",
# # #             "semesters",
# # #             "id"
# # #         }

# # #     LOCAL_MAP = {
# # #         "امتياز": "Excellent",
# # #         "جيد جداً": "Very Good",
# # #         "جيد": "Good",
# # #         "مقبول": "Pass",
# # #         "ضعيف": "Fail",
# # #         "لا يوجد": "None",
# # #         "غير معروف": "Unknown",
# # #         "غير محدد": "Not Specified",
# # #         "في انتظار التقييم الذكي": "Awaiting Smart Evaluation",
# # #         "Excellent": "Excellent",
# # #         "Good": "Good",
# # #         "Needs Improvement": "Needs Improvement",
# # #     }

# # #     if isinstance(data, list):
# # #         return [
# # #             auto_translate_payload_direct(item, target_lang, exclude_keys)
# # #             for item in data
# # #         ]

# # #     if isinstance(data, dict):

# # #         new_dict = dict(data)

# # #         for key, value in data.items():

# # #             # حماية البيانات البشرية
# # #             if key in exclude_keys:
# # #                 continue

# # #             # ترجمة النصوص النظامية فقط
# # #             if isinstance(value, str):

# # #                 # نخزن العربي الأصلي
# # #                 new_dict[key] = value

# # #                 if target_lang == "en":

# # #                     if value in LOCAL_MAP:
# # #                         new_dict[f"{key}_en"] = LOCAL_MAP[value]

# # #                     else:
# # #                         try:
# # #                             translated = GoogleTranslator(
# # #                                 source='ar',
# # #                                 target='en'
# # #                             ).translate(value)

# # #                             new_dict[f"{key}_en"] = translated

# # #                         except Exception:
# # #                             new_dict[f"{key}_en"] = value

# # #             elif isinstance(value, dict):
# # #                 new_dict[key] = auto_translate_payload_direct(
# # #                     value,
# # #                     target_lang,
# # #                     exclude_keys
# # #                 )

# # #             elif isinstance(value, list):
# # #                 new_dict[key] = auto_translate_payload_direct(
# # #                     value,
# # #                     target_lang,
# # #                     exclude_keys
# # #                 )

# # #         return new_dict

# # #     return data
# # # ══════════════════════════════════════════════════════════════════════════════
# # # 1. دالة صفحة الداش بورد (الرئيسية للسنة الحالية كاملة)
# # # ══════════════════════════════════════════════════════════════════════════════

# # # def get_text(lang: str, ar: str, en: str) -> str:
# # #     return en if lang == 'en' else ar

# # # @router.get("/student-dashboard/{student_id}")
# # # def get_student_dashboard_data(student_id: int, db: Session = Depends(get_db)):
# # #     current_year_query = text("SELECT academic_year FROM semesters WHERE is_current = true LIMIT 1")
# # #     current_year = db.execute(current_year_query).scalar()
    
# # #     if not current_year:
# # #         current_year = db.execute(text("SELECT academic_year FROM semesters ORDER BY semester_id DESC LIMIT 1")).scalar()
    
# # #     year_pattern = f"{current_year}%" if current_year else "%"
# # #     if current_year and "/" in current_year:
# # #         year_base = current_year.split("/")[0]
# # #         year_pattern = f"{year_base}%"

# # #     profile_query = text("""
# # #         SELECT u.full_name, l.level_name, d.department_name, u.language_code
# # #         FROM student s
# # #         JOIN users u ON s.user_id = u.user_id
# # #         JOIN level l ON s.level_id = l.level_id
# # #         JOIN department d ON s.department_id = d.department_id
# # #         WHERE s.student_id = :sid
# # #     """)
# # #     profile = db.execute(profile_query, {"sid": student_id}).mappings().first()
# # #     user_lang = profile["language_code"] if profile and profile["language_code"] else "ar"

# # #     stats_query = text("""
# # #         SELECT 
# # #             COUNT(DISTINCT ans.exam_id) AS exams_count,
# # #             COALESCE(MAX(ans.total_earned_mark), 0) AS highest_score,
# # #             COALESCE(AVG((CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100), 0) AS gpa,
# # #             COALESCE(SUM(CASE WHEN ans.total_earned_mark >= e.passing_mark THEN 1 ELSE 0 END), 0) AS passed_exams
# # #         FROM answer_sheet ans
# # #         JOIN exam e ON ans.exam_id = e.exam_id
# # #         JOIN folder f ON e.folder_id = f.folder_id
# # #         JOIN teacher_courses tc ON f.tc_id = tc.tc_id
# # #         JOIN semesters s ON tc.semester_id = s.semester_id
# # #         WHERE ans.student_id = :sid 
# # #           AND (ans.status = 'Graded' OR ans.status = 'graded')
# # #           AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
# # #     """)
# # #     stats = db.execute(stats_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year}).mappings().first()

# # #     subjects_query = text("""
# # #         SELECT COUNT(DISTINCT sc.course_id)
# # #         FROM student_courses sc
# # #         JOIN semesters s ON sc.semester_id = s.semester_id
# # #         WHERE sc.student_id = :sid AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
# # #     """)
# # #     subjects_count = db.execute(subjects_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year}).scalar() or 0

# # #     questions_query = text("""
# # #         SELECT COUNT(sa.answer_id)
# # #         FROM student_answers sa
# # #         JOIN questions q ON sa.question_id = q.question_id  
# # #         JOIN answer_sheet ans ON sa.sheet_id = ans.sheet_id
# # #         JOIN exam e ON ans.exam_id = e.exam_id
# # #         JOIN folder f ON e.folder_id = f.folder_id
# # #         JOIN teacher_courses tc ON f.tc_id = tc.tc_id
# # #         JOIN semesters s ON tc.semester_id = s.semester_id
# # #         WHERE ans.student_id = :sid 
# # #           AND (ans.status = 'Graded' OR ans.status = 'graded')
# # #           AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
# # #           AND COALESCE(sa.teacher_mark, sa.ai_mark) = q.question_mark 
# # #     """)
# # #     correct_questions_count = db.execute(questions_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year}).scalar() or 0
    
# # #     g_ex = "امتياز" if user_lang == 'ar' else "Excellent"
# # #     g_vg = "جيد جداً" if user_lang == 'ar' else "Very Good"
# # #     g_gd = "جيد" if user_lang == 'ar' else "Good"
# # #     g_pa = "مقبول" if user_lang == 'ar' else "Pass"
# # #     g_fa = "ضعيف" if user_lang == 'ar' else "Fail"

# # #     recent_query = text(f"""
# # #     SELECT c.course_name, e.exam_title, ans.total_earned_mark, e.total_marks,
# # #            e.exam_date, e.number_of_questions, e.exam_id,
# # #            CASE 
# # #                WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 90 THEN '{g_ex}'
# # #                WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 80 THEN '{g_vg}'
# # #                WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 70 THEN '{g_gd}'
# # #                WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 50 THEN '{g_pa}'
# # #                ELSE '{g_fa}'
# # #            END as grade_text
# # #         FROM answer_sheet ans
# # #         JOIN exam e ON ans.exam_id = e.exam_id
# # #         JOIN folder f ON e.folder_id = f.folder_id
# # #         JOIN teacher_courses tc ON f.tc_id = tc.tc_id
# # #         JOIN courses c ON tc.course_id = c.course_id
# # #         JOIN semesters s ON tc.semester_id = s.semester_id
# # #         WHERE ans.student_id = :sid 
# # #           AND (ans.status = 'Graded' OR ans.status = 'graded')
# # #           AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
# # #         ORDER BY e.exam_date DESC 
# # #         LIMIT 3
# # #     """)
# # #     recent_results = db.execute(recent_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year}).mappings().fetchall()
    
# # #     exams_count = int(stats["exams_count"]) if stats else 0
# # #     passed_exams = int(stats["passed_exams"]) if stats else 0
# # #     gpa = float(stats["gpa"]) if stats else 0
# # #     highest = float(stats["highest_score"]) if stats else 0
    
# # #     success_rate = (passed_exams / exams_count * 100) if exams_count > 0 else 0
# # #     level =get_text( user_lang, "مستوى ممتاز", "Excellent" )if success_rate >= 85 else get_text( user_lang, "مستوى جيد", "Good") if success_rate >= 70 else get_text( user_lang, "يحتاج تحسين", "Needs Improvement")
        
# # #     formatted_recent = []
# # #     for row in recent_results:
# # #         total_m = float(row["total_marks"]) if row["total_marks"] else 0
# # #         earned_m = float(row["total_earned_mark"]) if row["total_earned_mark"] else 0
# # #         percentage = (earned_m / total_m) * 100 if total_m > 0 else 0
        
# # #         formatted_recent.append({"id": str(row["exam_id"]), # 🔴 التعديل هنا: ضفنا المعرف
# # #             "score": f"{round(percentage)}%", 
# # #             "total_earned_mark": str(round(earned_m)), 
# # #             "label": row["grade_text"],
# # #             "title": row["exam_title"],
# # #             "subject": row["course_name"] or get_text(user_lang, "غير معروف", "Unknown"),
# # #             "date": str(row["exam_date"]) if row["exam_date"] else "",
# # #             "total_questions": str(row["number_of_questions"] or 0),
# # #             "answered_questions": "0"
# # #         })
        
# # #     raw_payload = {
# # #         "name": profile["full_name"] if profile else get_text(user_lang, "غير معروف", "Unknown"),
# # #         "level": f"{profile['level_name']} - {profile['department_name']}" if profile else "",
# # #         "badge": f"{round(gpa)}", 
# # #         "stats": {
# # #             "highest_score": f"{round(highest)}",
# # #             "gpa": f"{round(gpa, 1)}%",
# # #             "exams_count": str(exams_count),
# # #             "subjects_count": str(subjects_count),
# # #         },
# # #         "recent_results": formatted_recent,
# # #         "performance": {
# # #             "graded_exams": str(passed_exams),             
# # #             "total_exams": str(exams_count),                
# # #             "success_rate": f"{round(success_rate, 1)}%",   
# # #             "average_ai_score": f"{round(gpa, 1)}%",        
# # #             "performance_level": level,
# # #             "questions_mastered": str(correct_questions_count),      
# # #         }
# # #     }
# # #     return raw_payload

# # # # ══════════════════════════════════════════════════════════════════════════════
# # # # 2. دالة صفحة المواد الدراسية (مقسمة بالترم ومطابقة للفلاتر)
# # # # ══════════════════════════════════════════════════════════════════════════════

# # # @router.get("/student-subjects/{student_id}")
# # # def get_student_subjects_data(student_id: int, db: Session = Depends(get_db)):
# # #     lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")
# # #     user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"

# # #     semesters_query = text("""
# # #         SELECT DISTINCT sem.semester_id, sem.semester_name FROM student_courses sc
# # #         JOIN semesters sem ON sc.semester_id = sem.semester_id WHERE sc.student_id = :sid ORDER BY sem.semester_id
# # #     """)
# # #     semesters_records = db.execute(semesters_query, {"sid": student_id}).fetchall()
    
# # #     semesters_list = []
# # #     for sem in semesters_records:
# # #         semesters_list.append({"id": sem.semester_id, "name": sem.semester_name})

# # #     stats_query = text("""
# # #         SELECT sc.semester_id, COUNT(DISTINCT ans.exam_id) AS exams_count, MAX(ans.total_earned_mark) AS highest_score,
# # #             AVG((CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100) AS avg_percentage, COUNT(DISTINCT sc.course_id) AS subjects_count
# # #         FROM student_courses sc
# # #         LEFT JOIN teacher_courses tc ON sc.course_id = tc.course_id AND tc.semester_id = sc.semester_id
# # #         LEFT JOIN folder f ON f.tc_id = tc.tc_id LEFT JOIN exam e ON e.folder_id = f.folder_id
# # #         LEFT JOIN answer_sheet ans ON e.exam_id = ans.exam_id AND ans.student_id = sc.student_id AND ans.status = 'Graded'
# # #         WHERE sc.student_id = :sid GROUP BY sc.semester_id
# # #     """)
# # #     stats_records = db.execute(stats_query, {"sid": student_id}).fetchall()
    
# # #     stats_by_semester = {}
# # #     for row in stats_records:
# # #         stats_by_semester[row.semester_id] = {
# # #             "highest_score": str(round(row.highest_score or 0)),        
# # #             "average_score": f"{round(row.avg_percentage or 0, 1)}%",   
# # #             "total_exams": str(row.exams_count or 0),
# # #             "total_subjects": str(row.subjects_count or 0)
# # #         }

# # #     subjects_query = text("""
# # #     SELECT c.course_id, c.course_name, sc.semester_id,
# # #         (SELECT u.full_name FROM teacher_courses tc_t JOIN teacher t ON tc_t.teacher_id = t.teacher_id
# # #          JOIN users u ON t.user_id = u.user_id WHERE tc_t.course_id = c.course_id AND tc_t.semester_id = sc.semester_id LIMIT 1) AS teacher_name,
# # #         COUNT(DISTINCT ans.exam_id) AS exams_taken, 
# # #         SUM(ans.total_earned_mark) AS total_earned_mark, 
# # #         -- 🔴 التعديل السحري هنا: جيب أحدث تاريخ اختبار بشرط إن الطالب له ورقة إجابة مصححة!
# # #         MAX(CASE WHEN ans.exam_id IS NOT NULL THEN e.exam_date ELSE NULL END) AS last_exam_date
# # #     FROM student_courses sc 
# # #     JOIN courses c ON sc.course_id = c.course_id
# # #     LEFT JOIN teacher_courses tc ON c.course_id = tc.course_id AND tc.semester_id = sc.semester_id
# # #     LEFT JOIN folder f ON f.tc_id = tc.tc_id 
# # #     LEFT JOIN exam e ON e.folder_id = f.folder_id
# # #     LEFT JOIN answer_sheet ans ON e.exam_id = ans.exam_id AND ans.student_id = sc.student_id AND ans.status = 'Graded'
# # #     WHERE sc.student_id = :sid 
# # #     GROUP BY c.course_id, c.course_name, sc.semester_id
# # #     """)
# # #     subjects_records = db.execute(subjects_query, {"sid": student_id}).fetchall()

# # #     semester_data = {}
# # #     for sem in semesters_list:
# # #         sem_id_str = str(sem["id"])
# # #         semester_data[sem_id_str] = {
# # #             "top_stats": stats_by_semester.get(sem["id"], {"highest_score": "0", "average_score": "0%", "total_exams": "0", "total_subjects": "0"}),
# # #             "subjects": []
# # #         }

# # #     for row in subjects_records:
# # #         sem_id_str = str(row.semester_id)
# # #         if sem_id_str in semester_data:
# # #             semester_data[sem_id_str]["subjects"].append({
# # #                 "name": row.course_name or get_text(user_lang, "غير معروف", "Unknown"),
# # #                 "teacher": f"أ. {row.teacher_name}" if row.teacher_name else get_text(user_lang, "غير محدد", "Not specified"),
# # #                 "total_earned_mark": str(round(row.total_earned_mark or 0)),
# # #                 "exams": str(row.exams_taken or 0),
# # #                 "lastExam": row.last_exam_date.strftime("%Y-%m-%d") if row.last_exam_date else get_text(user_lang, "لا يوجد", "None")
# # #             })

# # #     raw_payload = {"semesters": semesters_list, "semester_data": semester_data}
# # #     return raw_payload

# # # # ══════════════════════════════════════════════════════════════════════════════
# # # # 3. دالة تفاصيل مادة معينة
# # # # ══════════════════════════════════════════════════════════════════════════════

# # # @router.get("/subject-details/{student_id}/{course_name}")
# # # def get_subject_details_data(student_id: int, course_name: str, db: Session = Depends(get_db)):
# # #     lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")
# # #     user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"

# # #     # ==========================================
# # #     # 1. جلب الإحصائيات (نفس كودك السابق)
# # #     # ==========================================
# # #     stats_query = text("""
# # #         SELECT 
# # #             COUNT(DISTINCT ans.exam_id) AS exams_count,
# # #             COALESCE(MAX(ans.total_earned_mark), 0) AS max_grade,
# # #             COALESCE(MIN(ans.total_earned_mark), 0) AS min_grade,
# # #             COALESCE(AVG((CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100), 0) AS avg_grade
# # #         FROM answer_sheet ans
# # #         JOIN exam e ON ans.exam_id = e.exam_id
# # #         JOIN folder f ON e.folder_id = f.folder_id
# # #         JOIN teacher_courses tc ON f.tc_id = tc.tc_id
# # #         JOIN courses c ON tc.course_id = c.course_id
# # #         WHERE ans.student_id = :sid 
# # #           AND c.course_name = :cname 
# # #           AND ans.status = 'Graded'
# # #     """)
# # #     stats = db.execute(stats_query, {"sid": student_id, "cname": course_name}).mappings().first()

# # #     # ==========================================
# # #     # 2. جلب قائمة الاختبارات (نفس كودك السابق)
# # #     # ==========================================

# # #     g_ex = "امتياز" if user_lang == 'ar' else "Excellent"
# # #     g_vg = "جيد جداً" if user_lang == 'ar' else "Very Good"
# # #     g_gd = "جيد" if user_lang == 'ar' else "Good"
# # #     g_pa = "مقبول" if user_lang == 'ar' else "Pass"
# # #     g_fa = "ضعيف" if user_lang == 'ar' else "Fail"

# # #     exams_query = text(f"""
# # #         SELECT e.exam_title, e.exam_date, ans.total_earned_mark, e.total_marks, e.number_of_questions,
# # #             (SELECT COUNT(*) FROM student_answers sa WHERE sa.sheet_id = ans.sheet_id) AS answered_count,
# # #             CASE 
# # #                 WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 90 THEN '{g_ex}'
# # #                WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 80 THEN '{g_vg}'
# # #                WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 70 THEN '{g_gd}'
# # #                WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 50 THEN '{g_pa}'
# # #                ELSE '{g_fa}'
# # #             END as rating
# # #         FROM answer_sheet ans JOIN exam e ON ans.exam_id = e.exam_id LEFT JOIN folder f ON e.folder_id = f.folder_id
# # #         LEFT JOIN teacher_courses tc ON f.tc_id = tc.tc_id LEFT JOIN courses c ON tc.course_id = c.course_id
# # #         WHERE ans.student_id = :sid AND c.course_name = :cname AND ans.status = 'Graded' ORDER BY e.exam_date DESC
# # #     """)
# # #     exams_records = db.execute(exams_query, {"sid": student_id, "cname": course_name}).mappings().fetchall()

# # #     formatted_exams = []
# # #     for row in exams_records:
# # #         formatted_exams.append({
# # #             "title": row["exam_title"],
# # #             "date": row["exam_date"].strftime("%Y-%m-%d") if row["exam_date"] else get_text(user_lang, "غير محدد", "Not specified"),
# # #             "total_earned_mark": str(round(row["total_earned_mark"] or 0)), 
# # #             "total_marks": str(round(row["total_marks"] or 0)),
# # #             "total": str(row["number_of_questions"] or 0),            
# # #             "answers": str(row["answered_count"] or 0),               
# # #             "rating": row["rating"]
# # #         })

# # #     avg = float(stats["avg_grade"]) if stats else 0.0
# # #     min_grade = float(stats["min_grade"]) if stats else 0.0
# # #     max_grade = float(stats["max_grade"]) if stats else 0.0
# # #     exams_count = int(stats["exams_count"]) if stats else 0

# # #     # ==========================================
# # #     # 3. الجزء الجديد 🔥 (سحب بيانات الـ AI بدلاً من الوهمية)
# # #     # ==========================================
# # #     ai_summary_query = text("""
# # #         SELECT sc.subject_strengths, sc.subject_weaknesses
# # #         FROM student_courses sc
# # #         JOIN courses c ON sc.course_id = c.course_id
# # #         WHERE sc.student_id = :sid AND c.course_name = :cname
# # #     """)
# # #     ai_summary = db.execute(ai_summary_query, {"sid": student_id, "cname": course_name}).mappings().first()

# # #     strengths = []
# # #     improvements = []

# # #     if ai_summary:
# # #         if ai_summary["subject_strengths"]:
# # #             strengths = ai_summary["subject_strengths"].split('\n')
# # #         else:
# # #             strengths = [get_text(user_lang, "في انتظار تقييم الذكاء الاصطناعي...", "Waiting for AI evaluation...")]

# # #         if ai_summary["subject_weaknesses"]:
# # #             improvements = ai_summary["subject_weaknesses"].split('\n')
# # #         else:
# # #             improvements = [get_text(user_lang, "في انتظار تقييم الذكاء الاصطناعي...", "Waiting for AI evaluation...")]
# # #     else:
# # #         strengths = [get_text(user_lang, "لاتوجد بيانات حاليا", "there is no data now")]
# # #         improvements = [get_text(user_lang, "لاتوجد بيانات حاليا", "there is no data now")]
# # #     # ==========================================
# # #     # 4. إرجاع النتيجة النهائية
# # #     # ==========================================
# # #     raw_payload = {
# # #         "stats": {
# # #             "min": str(round(min_grade)),                
# # #             "max": str(round(max_grade)),                
# # #             "avg": f"{round(avg, 1)}%",                  
# # #             "count": str(exams_count)                    
# # #         },
# # #         "exams": formatted_exams,
# # #         "strengths": strengths, # 👈 الآن تحتوي على الداتا الحقيقية كـ List
# # #         "improvements": improvements # 👈 الآن تحتوي على الداتا الحقيقية كـ List
# # #     }
    
# # #     return raw_payload

# # # # ══════════════════════════════════════════════════════════════════════════════
# # # # 4. دالة تفاصيل ورقة اختبار معين
# # # # ══════════════════════════════════════════════════════════════════════════════

# # # @router.get("/exam-details/{student_id}/{exam_title}")
# # # def get_exam_details_data(student_id: int, exam_title: str, db: Session = Depends(get_db)):
# # #     lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")
# # #     user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"

# # #     stats_query = text("""
# # #         SELECT 
# # #             ans.sheet_id,
# # #             ans.total_earned_mark,
# # #             e.exam_id,
# # #             e.total_marks
# # #         FROM answer_sheet ans
# # #         JOIN exam e ON ans.exam_id = e.exam_id
# # #         WHERE ans.student_id = :sid AND e.exam_title = :etitle
# # #         LIMIT 1
# # #     """)
# # #     stats_record = db.execute(stats_query, {"sid": student_id, "etitle": exam_title}).mappings().first()

# # #     sheet_id = stats_record["sheet_id"] if stats_record else 0
# # #     exam_id = stats_record["exam_id"] if stats_record else 0
# # #     total_earned_mark = stats_record["total_earned_mark"] if stats_record else 0
# # #     total_marks = stats_record["total_marks"] if stats_record else 100

# # #     questions_query = text("""
# # #         SELECT 
# # #             q.question_id,
# # #             q.question_order,
# # #             q.question_text,
# # #             q.question_mark AS total,
# # #             sa.extracted_text AS student_answer,
# # #             sa.teacher_mark,
# # #             sa.ai_mark,
# # #             sa.ai_feedback AS evaluation,
# # #             ea.answer_text AS model_answer
# # #         FROM questions q
# # #         LEFT JOIN student_answers sa ON q.question_id = sa.question_id AND sa.sheet_id = :sheet_id
# # #         LEFT JOIN expected_answers ea ON q.question_id = ea.question_id
# # #         WHERE q.exam_id = :exam_id
# # #         ORDER BY q.question_order ASC
# # #     """)
# # #     questions_records = db.execute(questions_query, {"sheet_id": sheet_id, "exam_id": exam_id}).mappings().fetchall()

# # #     correct_count = 0
# # #     wrong_count = 0
# # #     partial_count = 0
# # #     formatted_questions = []

# # #     for row in questions_records:
# # #         q_order = row["question_order"]
# # #         total_q_mark = float(row["total"] or 0.0)
        
# # #         t_mark = row["teacher_mark"]
# # #         a_mark = row["ai_mark"]
# # #         earned_score = float(t_mark) if t_mark is not None else float(a_mark) if a_mark is not None else 0.0

# # #         if earned_score >= total_q_mark and total_q_mark > 0:
# # #             correct_count += 1
# # #         elif earned_score == 0.0 or (t_mark is None and a_mark is None):
# # #             wrong_count += 1
# # #         else:
# # #             partial_count += 1

# # #         formatted_questions.append({
# # #             "id": str(q_order or 1),
# # #             "text": row["question_text"] or get_text(user_lang, "لا يوجد", "None"),
# # #             "score": earned_score,
# # #             "total": total_q_mark,
# # #             "modelAnswer": row["model_answer"] or get_text(user_lang, "الإجابة النموذجية قيد المراجعة", "Model answer is under review"),
# # #             "studentAnswer": row["student_answer"] or get_text(user_lang, "لم يتم استخراج الإجابة", "Answer not extracted"),
# # #             "evaluation": row["evaluation"] or get_text(user_lang, "في انتظار التقييم الذكي", "Waiting for AI evaluation")
# # #         })

# # #     # ══════════════════════════════════════════════════════════════════════════════
# # #     # 🔴 الجزء الجديد: جلب صور ورقة الطالب وترتيبها حسب رقم الصفحة
# # #     # ══════════════════════════════════════════════════════════════════════════════
# # #     images_query = text("""
# # #         SELECT image_path 
# # #         FROM sheet_images 
# # #         WHERE sheet_id = :sheet_id 
# # #         ORDER BY page_number ASC
# # #     """)
# # #     images_records = db.execute(images_query, {"sheet_id": sheet_id}).mappings().fetchall()
    
# # #     # ⚠️ ملاحظة: تأكدي إن البورت هنا مطابق للي يشتغل عليه سيرفر البايثون عندك (مثلاً 8000)
# # #     # ولما ترفعين الباك إند على سيرفر حقيقي، استبدلي هذا الرابط برابط الدومين حقك
# # #     base_url = "http://127.0.0.1:8000/" 
# # #     paper_images = []
    
# # #     for row in images_records:
# # #         if row["image_path"]:
# # #             # ندمج رابط السيرفر مع مسار الصورة الجاي من الداتا بيس
# # #             clean_path = row["image_path"].lstrip('/') # عشان نضمن ما يصير فيه دبل سلاش
# # #             paper_images.append(f"{base_url}{clean_path}")

# # #     raw_payload = {
# # #         "stats": {
# # #             "total_earned_mark": str(round(total_earned_mark or 0)),
# # #             "total_marks": str(round(total_marks or 100)),
# # #             "total_questions": str(len(formatted_questions)),
# # #             "correct": str(correct_count),
# # #             "wrong": str(wrong_count),
# # #             "partial": str(partial_count),
# # #         },
# # #         "questions": formatted_questions,
# # #         "paper_images": paper_images # 🔴 أضفنا مصفوفة الصور هنا عشان يقراها الفلاتر
# # #     }
# # #     return raw_payload



# # # ضعي هذه الدالة السحرية في بداية الملف (بعد الاستيرادات)
# # def get_text(lang: str, ar: str, en: str) -> str:
# #     """🌟 دالة ذكية لإرجاع النص باللغة المناسبة بناءً على لغة المستخدم المحفوظة"""
# #     return en if lang == 'en' else ar

# # # ══════════════════════════════════════════════════════════════════════════════
# # # 1. دالة الداشبورد الرئيسية
# # # ══════════════════════════════════════════════════════════════════════════════
# # @router.get("/student-dashboard/{student_id}")
# # def get_student_dashboard_data(student_id: int, db: Session = Depends(get_db)):
# #     current_year_query = text("SELECT academic_year FROM semesters WHERE is_current = true LIMIT 1")
# #     current_year = db.execute(current_year_query).scalar()
    
# #     if not current_year:
# #         current_year = db.execute(text("SELECT academic_year FROM semesters ORDER BY semester_id DESC LIMIT 1")).scalar()
    
# #     year_pattern = f"{current_year}%" if current_year else "%"
# #     if current_year and "/" in current_year:
# #         year_base = current_year.split("/")[0]
# #         year_pattern = f"{year_base}%"

# #     profile_query = text("""
# #         SELECT u.full_name, l.level_name, d.department_name, u.language_code
# #         FROM student s
# #         JOIN users u ON s.user_id = u.user_id
# #         JOIN level l ON s.level_id = l.level_id
# #         JOIN department d ON s.department_id = d.department_id
# #         WHERE s.student_id = :sid
# #     """)
# #     profile = db.execute(profile_query, {"sid": student_id}).mappings().first()
    
# #     # 🌟 استخراج لغة الطالب
# #     user_lang = profile["language_code"] if profile and profile["language_code"] else "ar"

# #     stats_query = text("""
# #         SELECT 
# #             COUNT(DISTINCT ans.exam_id) AS exams_count,
# #             COALESCE(MAX(ans.total_earned_mark), 0) AS highest_score,
# #             COALESCE(AVG((CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100), 0) AS gpa,
# #             COALESCE(SUM(CASE WHEN ans.total_earned_mark >= e.passing_mark THEN 1 ELSE 0 END), 0) AS passed_exams
# #         FROM answer_sheet ans
# #         JOIN exam e ON ans.exam_id = e.exam_id
# #         JOIN folder f ON e.folder_id = f.folder_id
# #         JOIN teacher_courses tc ON f.tc_id = tc.tc_id
# #         JOIN semesters s ON tc.semester_id = s.semester_id
# #         WHERE ans.student_id = :sid 
# #           AND (ans.status = 'Graded' OR ans.status = 'graded')
# #           AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
# #     """)
# #     stats = db.execute(stats_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year}).mappings().first()

# #     subjects_query = text("""
# #         SELECT COUNT(DISTINCT sc.course_id)
# #         FROM student_courses sc
# #         JOIN semesters s ON sc.semester_id = s.semester_id
# #         WHERE sc.student_id = :sid AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
# #     """)
# #     subjects_count = db.execute(subjects_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year}).scalar() or 0

# #     questions_query = text("""
# #         SELECT COUNT(sa.answer_id)
# #         FROM student_answers sa
# #         JOIN questions q ON sa.question_id = q.question_id  
# #         JOIN answer_sheet ans ON sa.sheet_id = ans.sheet_id
# #         JOIN exam e ON ans.exam_id = e.exam_id
# #         JOIN folder f ON e.folder_id = f.folder_id
# #         JOIN teacher_courses tc ON f.tc_id = tc.tc_id
# #         JOIN semesters s ON tc.semester_id = s.semester_id
# #         WHERE ans.student_id = :sid 
# #           AND (ans.status = 'Graded' OR ans.status = 'graded')
# #           AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
# #           AND COALESCE(sa.teacher_mark, sa.ai_mark) = q.question_mark 
# #     """)
# #     correct_questions_count = db.execute(questions_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year}).scalar() or 0
    
# #     # 🌟 تجهيز نصوص التقييم قبل وضعها في SQL
# #     g_ex = get_text(user_lang, "امتياز", "Excellent")
# #     g_vg = get_text(user_lang, "جيد جداً", "Very Good")
# #     g_gd = get_text(user_lang, "جيد", "Good")
# #     g_pa = get_text(user_lang, "مقبول", "Pass")
# #     g_fa = get_text(user_lang, "ضعيف", "Fail")

# #     # 🌟 استخدام f-string لحقن المتغيرات
# #     recent_query = text(f"""
# #         SELECT c.course_name, e.exam_title, ans.total_earned_mark, e.total_marks,
# #                e.exam_date, e.number_of_questions, e.exam_id,
# #                CASE 
# #                    WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 90 THEN '{g_ex}'
# #                    WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 80 THEN '{g_vg}'
# #                    WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 70 THEN '{g_gd}'
# #                    WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 50 THEN '{g_pa}'
# #                    ELSE '{g_fa}'
# #                END as grade_text
# #         FROM answer_sheet ans
# #         JOIN exam e ON ans.exam_id = e.exam_id
# #         JOIN folder f ON e.folder_id = f.folder_id
# #         JOIN teacher_courses tc ON f.tc_id = tc.tc_id
# #         JOIN courses c ON tc.course_id = c.course_id
# #         JOIN semesters s ON tc.semester_id = s.semester_id
# #         WHERE ans.student_id = :sid 
# #           AND (ans.status = 'Graded' OR ans.status = 'graded')
# #           AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
# #         ORDER BY e.exam_date DESC 
# #         LIMIT 3
# #     """)
# #     recent_results = db.execute(recent_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year}).mappings().fetchall()
    
# #     exams_count = int(stats["exams_count"]) if stats else 0
# #     passed_exams = int(stats["passed_exams"]) if stats else 0
# #     gpa = float(stats["gpa"]) if stats else 0
# #     highest = float(stats["highest_score"]) if stats else 0
    
# #     success_rate = (passed_exams / exams_count * 100) if exams_count > 0 else 0
    
# #     # 🌟 تحديد مستوى الأداء ديناميكياً
# #     if success_rate >= 85:
# #         level = get_text(user_lang, "مستوى ممتاز", "Excellent")
# #     elif success_rate >= 70:
# #         level = get_text(user_lang, "مستوى جيد", "Good")
# #     else:
# #         level = get_text(user_lang, "يحتاج تحسين", "Needs Improvement")
        
# #     formatted_recent = []
# #     for row in recent_results:
# #         total_m = float(row["total_marks"]) if row["total_marks"] else 0
# #         earned_m = float(row["total_earned_mark"]) if row["total_earned_mark"] else 0
# #         percentage = (earned_m / total_m) * 100 if total_m > 0 else 0
        
# #         formatted_recent.append({
# #             "id": str(row["exam_id"]),
# #             "score": f"{round(percentage)}%", 
# #             "total_earned_mark": str(round(earned_m)), 
# #             "label": row["grade_text"],
# #             "title": row["exam_title"],
# #             "subject": row["course_name"] or get_text(user_lang, "غير معروف", "Unknown"),
# #             "date": str(row["exam_date"]) if row["exam_date"] else "",
# #             "total_questions": str(row["number_of_questions"] or 0),
# #             "answered_questions": "0"
# #         })
        
# #     raw_payload = {
# #         "name": profile["full_name"] if profile else get_text(user_lang, "غير معروف", "Unknown"),
# #         "level": f"{profile['level_name']} - {profile['department_name']}" if profile else "",
# #         "badge": f"{round(gpa)}", 
# #         "stats": {
# #             "highest_score": f"{round(highest)}",
# #             "gpa": f"{round(gpa, 1)}%",
# #             "exams_count": str(exams_count),
# #             "subjects_count": str(subjects_count),
# #         },
# #         "recent_results": formatted_recent,
# #         "performance": {
# #             "graded_exams": str(passed_exams),             
# #             "total_exams": str(exams_count),                
# #             "success_rate": f"{round(success_rate, 1)}%",   
# #             "average_ai_score": f"{round(gpa, 1)}%",        
# #             "performance_level": level,
# #             "questions_mastered": str(correct_questions_count),      
# #         }
# #     }
# #     return raw_payload

# # # ══════════════════════════════════════════════════════════════════════════════
# # # 2. دالة صفحة المواد الدراسية
# # # ══════════════════════════════════════════════════════════════════════════════
# # @router.get("/student-subjects/{student_id}")
# # def get_student_subjects_data(student_id: int, db: Session = Depends(get_db)):
# #     lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")
# #     user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"

# #     semesters_query = text("""
# #         SELECT DISTINCT sem.semester_id, sem.semester_name FROM student_courses sc
# #         JOIN semesters sem ON sc.semester_id = sem.semester_id WHERE sc.student_id = :sid ORDER BY sem.semester_id
# #     """)
# #     semesters_records = db.execute(semesters_query, {"sid": student_id}).fetchall()
    
# #     semesters_list = [{"id": sem.semester_id, "name": sem.semester_name} for sem in semesters_records]

# #     stats_query = text("""
# #         SELECT sc.semester_id, COUNT(DISTINCT ans.exam_id) AS exams_count, MAX(ans.total_earned_mark) AS highest_score,
# #             AVG((CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100) AS avg_percentage, COUNT(DISTINCT sc.course_id) AS subjects_count
# #         FROM student_courses sc
# #         LEFT JOIN teacher_courses tc ON sc.course_id = tc.course_id AND tc.semester_id = sc.semester_id
# #         LEFT JOIN folder f ON f.tc_id = tc.tc_id LEFT JOIN exam e ON e.folder_id = f.folder_id
# #         LEFT JOIN answer_sheet ans ON e.exam_id = ans.exam_id AND ans.student_id = sc.student_id AND ans.status = 'Graded'
# #         WHERE sc.student_id = :sid GROUP BY sc.semester_id
# #     """)
# #     stats_records = db.execute(stats_query, {"sid": student_id}).fetchall()
    
# #     stats_by_semester = {
# #         row.semester_id: {
# #             "highest_score": str(round(row.highest_score or 0)),        
# #             "average_score": f"{round(row.avg_percentage or 0, 1)}%",   
# #             "total_exams": str(row.exams_count or 0),
# #             "total_subjects": str(row.subjects_count or 0)
# #         } for row in stats_records
# #     }

# #     subjects_query = text("""
# #     SELECT c.course_id, c.course_name, sc.semester_id,
# #         (SELECT u.full_name FROM teacher_courses tc_t JOIN teacher t ON tc_t.teacher_id = t.teacher_id
# #          JOIN users u ON t.user_id = u.user_id WHERE tc_t.course_id = c.course_id AND tc_t.semester_id = sc.semester_id LIMIT 1) AS teacher_name,
# #         COUNT(DISTINCT ans.exam_id) AS exams_taken, 
# #         SUM(ans.total_earned_mark) AS total_earned_mark, 
# #         MAX(CASE WHEN ans.exam_id IS NOT NULL THEN e.exam_date ELSE NULL END) AS last_exam_date
# #     FROM student_courses sc 
# #     JOIN courses c ON sc.course_id = c.course_id
# #     LEFT JOIN teacher_courses tc ON c.course_id = tc.course_id AND tc.semester_id = sc.semester_id
# #     LEFT JOIN folder f ON f.tc_id = tc.tc_id 
# #     LEFT JOIN exam e ON e.folder_id = f.folder_id
# #     LEFT JOIN answer_sheet ans ON e.exam_id = ans.exam_id AND ans.student_id = sc.student_id AND ans.status = 'Graded'
# #     WHERE sc.student_id = :sid 
# #     GROUP BY c.course_id, c.course_name, sc.semester_id
# #     """)
# #     subjects_records = db.execute(subjects_query, {"sid": student_id}).fetchall()

# #     semester_data = {}
# #     for sem in semesters_list:
# #         sem_id_str = str(sem["id"])
# #         semester_data[sem_id_str] = {
# #             "top_stats": stats_by_semester.get(sem["id"], {"highest_score": "0", "average_score": "0%", "total_exams": "0", "total_subjects": "0"}),
# #             "subjects": []
# #         }

# #     for row in subjects_records:
# #         sem_id_str = str(row.semester_id)
# #         if sem_id_str in semester_data:
# #             # 🌟 إضافة الفواصل بشكل صحيح واستخدام get_text
# #             teacher_prefix = get_text(user_lang, 'أ. ', 'Mr./Ms. ')
# #             teacher_val = f"{teacher_prefix}{row.teacher_name}" if row.teacher_name else get_text(user_lang, "غير محدد", "Not specified")
            
# #             semester_data[sem_id_str]["subjects"].append({
# #                 "name": row.course_name or get_text(user_lang, "غير معروف", "Unknown"),
# #                 "teacher": teacher_val,
# #                 "total_earned_mark": str(round(row.total_earned_mark or 0)),
# #                 "exams": str(row.exams_taken or 0),
# #                 "lastExam": row.last_exam_date.strftime("%Y-%m-%d") if row.last_exam_date else get_text(user_lang, "لا يوجد", "None")
# #             })

# #     return {"semesters": semesters_list, "semester_data": semester_data}

# # # ══════════════════════════════════════════════════════════════════════════════
# # # 3. دالة تفاصيل مادة معينة
# # # ══════════════════════════════════════════════════════════════════════════════
# # @router.get("/subject-details/{student_id}/{course_name}")
# # def get_subject_details_data(student_id: int, course_name: str, db: Session = Depends(get_db)):
# #     lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")
# #     user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"

# #     stats_query = text("""
# #         SELECT 
# #             COUNT(DISTINCT ans.exam_id) AS exams_count,
# #             COALESCE(MAX(ans.total_earned_mark), 0) AS max_grade,
# #             COALESCE(MIN(ans.total_earned_mark), 0) AS min_grade,
# #             COALESCE(AVG((CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100), 0) AS avg_grade
# #         FROM answer_sheet ans
# #         JOIN exam e ON ans.exam_id = e.exam_id
# #         JOIN folder f ON e.folder_id = f.folder_id
# #         JOIN teacher_courses tc ON f.tc_id = tc.tc_id
# #         JOIN courses c ON tc.course_id = c.course_id
# #         WHERE ans.student_id = :sid 
# #           AND c.course_name = :cname 
# #           AND ans.status = 'Graded'
# #     """)
# #     stats = db.execute(stats_query, {"sid": student_id, "cname": course_name}).mappings().first()

# #     # 🌟 تجهيز التقييم
# #     g_ex = get_text(user_lang, "امتياز", "Excellent")
# #     g_vg = get_text(user_lang, "جيد جداً", "Very Good")
# #     g_gd = get_text(user_lang, "جيد", "Good")
# #     g_pa = get_text(user_lang, "مقبول", "Pass")
# #     g_fa = get_text(user_lang, "ضعيف", "Fail")

# #     exams_query = text(f"""
# #         SELECT e.exam_title, e.exam_date, ans.total_earned_mark, e.total_marks, e.number_of_questions,
# #             (SELECT COUNT(*) FROM student_answers sa WHERE sa.sheet_id = ans.sheet_id) AS answered_count,
# #             CASE 
# #                 WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 90 THEN '{g_ex}'
# #                 WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 80 THEN '{g_vg}'
# #                 WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 70 THEN '{g_gd}'
# #                 WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 50 THEN '{g_pa}'
# #                 ELSE '{g_fa}'
# #             END as rating
# #         FROM answer_sheet ans JOIN exam e ON ans.exam_id = e.exam_id LEFT JOIN folder f ON e.folder_id = f.folder_id
# #         LEFT JOIN teacher_courses tc ON f.tc_id = tc.tc_id LEFT JOIN courses c ON tc.course_id = c.course_id
# #         WHERE ans.student_id = :sid AND c.course_name = :cname AND ans.status = 'Graded' ORDER BY e.exam_date DESC
# #     """)
# #     exams_records = db.execute(exams_query, {"sid": student_id, "cname": course_name}).mappings().fetchall()

# #     formatted_exams = []
# #     for row in exams_records:
# #         formatted_exams.append({
# #             "title": row["exam_title"],
# #             "date": row["exam_date"].strftime("%Y-%m-%d") if row["exam_date"] else get_text(user_lang, "غير محدد", "Not specified"),
# #             "total_earned_mark": str(round(row["total_earned_mark"] or 0)), 
# #             "total_marks": str(round(row["total_marks"] or 0)),
# #             "total": str(row["number_of_questions"] or 0),            
# #             "answers": str(row["answered_count"] or 0),                
# #             "rating": row["rating"]
# #         })

# #     avg = float(stats["avg_grade"]) if stats else 0.0
# #     min_grade = float(stats["min_grade"]) if stats else 0.0
# #     max_grade = float(stats["max_grade"]) if stats else 0.0
# #     exams_count = int(stats["exams_count"]) if stats else 0

# #     ai_summary_query = text("""
# #         SELECT sc.subject_strengths, sc.subject_weaknesses
# #         FROM student_courses sc
# #         JOIN courses c ON sc.course_id = c.course_id
# #         WHERE sc.student_id = :sid AND c.course_name = :cname
# #     """)
# #     ai_summary = db.execute(ai_summary_query, {"sid": student_id, "cname": course_name}).mappings().first()

# #     # 🌟 تصحيح الأقواس المربعة بدون فواصل في النهاية!
# #     if ai_summary:
# #         if ai_summary["subject_strengths"]:
# #             strengths = ai_summary["subject_strengths"].split('\n')
# #         else:
# #             strengths = [get_text(user_lang, "في انتظار تقييم الذكاء الاصطناعي...", "Waiting for AI evaluation...")]

# #         if ai_summary["subject_weaknesses"]:
# #             improvements = ai_summary["subject_weaknesses"].split('\n')
# #         else:
# #             improvements = [get_text(user_lang, "في انتظار تقييم الذكاء الاصطناعي...", "Waiting for AI evaluation...")]
# #     else:
# #         strengths = [get_text(user_lang, "لا توجد بيانات حالياً", "No data available")]
# #         improvements = [get_text(user_lang, "لا توجد بيانات حالياً", "No data available")]

# #     return {
# #         "stats": {
# #             "min": str(round(min_grade)),                
# #             "max": str(round(max_grade)),                
# #             "avg": f"{round(avg, 1)}%",                  
# #             "count": str(exams_count)                    
# #         },
# #         "exams": formatted_exams,
# #         "strengths": strengths,
# #         "improvements": improvements
# #     }

# # # ══════════════════════════════════════════════════════════════════════════════
# # # 4. دالة تفاصيل ورقة اختبار معين
# # # ══════════════════════════════════════════════════════════════════════════════
# # @router.get("/exam-details/{student_id}/{exam_title}")
# # def get_exam_details_data(student_id: int, exam_title: str, db: Session = Depends(get_db)):
# #     lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")
# #     user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"

# #     stats_query = text("""
# #         SELECT 
# #             ans.sheet_id,
# #             ans.total_earned_mark,
# #             e.exam_id,
# #             e.total_marks
# #         FROM answer_sheet ans
# #         JOIN exam e ON ans.exam_id = e.exam_id
# #         WHERE ans.student_id = :sid AND e.exam_title = :etitle
# #         LIMIT 1
# #     """)
# #     stats_record = db.execute(stats_query, {"sid": student_id, "etitle": exam_title}).mappings().first()

# #     sheet_id = stats_record["sheet_id"] if stats_record else 0
# #     exam_id = stats_record["exam_id"] if stats_record else 0
# #     total_earned_mark = stats_record["total_earned_mark"] if stats_record else 0
# #     total_marks = stats_record["total_marks"] if stats_record else 100

# #     questions_query = text("""
# #         SELECT 
# #             q.question_id,
# #             q.question_order,
# #             q.question_text,
# #             q.question_mark AS total,
# #             sa.extracted_text AS student_answer,
# #             sa.teacher_mark,
# #             sa.ai_mark,
# #             sa.ai_feedback AS evaluation,
# #             ea.answer_text AS model_answer
# #         FROM questions q
# #         LEFT JOIN student_answers sa ON q.question_id = sa.question_id AND sa.sheet_id = :sheet_id
# #         LEFT JOIN expected_answers ea ON q.question_id = ea.question_id
# #         WHERE q.exam_id = :exam_id
# #         ORDER BY q.question_order ASC
# #     """)
# #     questions_records = db.execute(questions_query, {"sheet_id": sheet_id, "exam_id": exam_id}).mappings().fetchall()

# #     correct_count = 0
# #     wrong_count = 0
# #     partial_count = 0
# #     formatted_questions = []

# #     for row in questions_records:
# #         q_order = row["question_order"]
# #         total_q_mark = float(row["total"] or 0.0)
        
# #         t_mark = row["teacher_mark"]
# #         a_mark = row["ai_mark"]
# #         earned_score = float(t_mark) if t_mark is not None else float(a_mark) if a_mark is not None else 0.0

# #         if earned_score >= total_q_mark and total_q_mark > 0:
# #             correct_count += 1
# #         elif earned_score == 0.0 or (t_mark is None and a_mark is None):
# #             wrong_count += 1
# #         else:
# #             partial_count += 1

# #         formatted_questions.append({
# #             "id": str(q_order or 1),
# #             "text": row["question_text"] or get_text(user_lang, "بدون نص", "No text"),
# #             "score": earned_score,
# #             "total": total_q_mark,
# #             "modelAnswer": row["model_answer"] or get_text(user_lang, "الإجابة النموذجية قيد المراجعة", "Model answer under review"),
# #             "studentAnswer": row["student_answer"] or get_text(user_lang, "لم يتم استخراج الإجابة", "Answer not extracted"),
# #             "evaluation": row["evaluation"] or get_text(user_lang, "في انتظار التقييم الذكي", "Waiting for AI evaluation")
# #         })

# #     images_query = text("""
# #         SELECT image_path 
# #         FROM sheet_images 
# #         WHERE sheet_id = :sheet_id 
# #         ORDER BY page_number ASC
# #     """)
# #     images_records = db.execute(images_query, {"sheet_id": sheet_id}).mappings().fetchall()
    
# #     base_url = "http://127.0.0.1:8000/" 
# #     paper_images = []
    
# #     for row in images_records:
# #         if row["image_path"]:
# #             clean_path = row["image_path"].lstrip('/')
# #             paper_images.append(f"{base_url}{clean_path}")

# #     return {
# #         "stats": {
# #             "total_earned_mark": str(round(total_earned_mark or 0)),
# #             "total_marks": str(round(total_marks or 100)),
# #             "total_questions": str(len(formatted_questions)),
# #             "correct": str(correct_count),
# #             "wrong": str(wrong_count),
# #             "partial": str(partial_count),
# #         },
# #         "questions": formatted_questions,
# #         "paper_images": paper_images
# #     }



# from sqlalchemy.orm import Session
# from sqlalchemy import text
# from fastapi.encoders import jsonable_encoder
# from datetime import date
# from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks
# from db.database import get_db 
# from models import User 
# from pydantic import BaseModel, EmailStr

# # ── استيراد حزمة الترجمة التلقائية السحرية بأمان ──────────────────────────────────────────
# from deep_translator import GoogleTranslator

# router = APIRouter(prefix="/views", tags=["Student Views Features"])

# # ضعي هذه الدالة السحرية في بداية الملف (بعد الاستيرادات)
# def get_text(lang: str, ar: str, en: str) -> str:
#     """🌟 دالة ذكية لإرجاع النص باللغة المناسبة بناءً على لغة المستخدم المحفوظة"""
#     return en if lang == 'en' else ar

# def translate_live(text_data: str, lang: str) -> str:
#     """🌟 دالة الترجمة الحية للنصوص المتغيرة القادمة من الداتا بيس"""
#     if not text_data:
#         return ""
#     if lang == 'en':
#         try:
#             return GoogleTranslator(source='ar', target='en').translate(text_data)
#         except Exception:
#             return text_data
#     return text_data


# def resolve_student_id(db, student_id):
#     real = db.execute(
#         text("SELECT student_id FROM student WHERE user_id = :id OR student_id = :id LIMIT 1"),
#         {"id": student_id}
#     ).scalar()
#     return real if real else student_id

# # ══════════════════════════════════════════════════════════════════════════════
# # 1. دالة الداشبورد الرئيسية
# # ══════════════════════════════════════════════════════════════════════════════
# def get_student_dashboard_data(db, student_id):
#     student_id = resolve_student_id(db, student_id) # 👈 هنا التصحيح    
#     student_id = resolve_student_id(db, student_id) # 👈 الحماية هنا
    
#     current_year_query = text("SELECT academic_year FROM semesters WHERE is_current = true LIMIT 1")
#     current_year = db.execute(current_year_query).scalar()
#     if not current_year:
#         current_year = db.execute(text("SELECT academic_year FROM semesters ORDER BY semester_id DESC LIMIT 1")).scalar()
    
#     year_pattern = f"{current_year}%" if current_year else "%"
#     if current_year and "/" in current_year:
#         year_base = current_year.split("/")[0]
#         year_pattern = f"{year_base}%"

#     profile_query = text("""
#         SELECT u.full_name, l.level_name, d.department_name, u.language_code
#         FROM student s
#         JOIN users u ON s.user_id = u.user_id
#         JOIN level l ON s.level_id = l.level_id
#         JOIN department d ON s.department_id = d.department_id
#         WHERE s.student_id = :sid
#     """)
#     profile = db.execute(profile_query, {"sid": student_id}).mappings().first()
#     user_lang = profile["language_code"] if profile and profile["language_code"] else "ar"

#     # 🌟 الحل السحري للحسابات: أخذ أحدث ورقة إجابة فقط لكل اختبار لمنع تكرار الأرقام
#     stats_query = text("""
#         WITH LatestSheets AS (
#             SELECT ans.exam_id, ans.total_earned_mark, e.total_marks, e.passing_mark,
#                    ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
#             FROM answer_sheet ans
#             JOIN exam e ON ans.exam_id = e.exam_id
#             JOIN folder f ON e.folder_id = f.folder_id
#             JOIN teacher_courses tc ON f.tc_id = tc.tc_id
#             JOIN semesters s ON tc.semester_id = s.semester_id
#             WHERE ans.student_id = :sid 
#               AND ans.status IN ('Graded', 'graded')
#               AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
#         )
#         SELECT 
#             COUNT(exam_id) AS exams_count,
#             COALESCE(MAX(total_earned_mark), 0) AS highest_score,
#             COALESCE(AVG((CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100), 0) AS gpa,
#             COALESCE(SUM(CASE WHEN total_earned_mark >= passing_mark THEN 1 ELSE 0 END), 0) AS passed_exams
#         FROM LatestSheets WHERE rn = 1
#     """)
#     stats = db.execute(stats_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year}).mappings().first()

#     subjects_query = text("""
#         SELECT COUNT(DISTINCT sc.course_id)
#         FROM student_courses sc
#         JOIN semesters s ON sc.semester_id = s.semester_id
#         WHERE sc.student_id = :sid AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
#     """)
#     subjects_count = db.execute(subjects_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year}).scalar() or 0

#     questions_query = text("""
#         WITH LatestSheets AS (
#             SELECT sheet_id, ROW_NUMBER() OVER(PARTITION BY exam_id ORDER BY uploaded_at DESC) as rn
#             FROM answer_sheet WHERE student_id = :sid AND status IN ('Graded', 'graded')
#         )
#         SELECT COUNT(sa.answer_id)
#         FROM student_answers sa
#         JOIN questions q ON sa.question_id = q.question_id  
#         JOIN LatestSheets ls ON sa.sheet_id = ls.sheet_id AND ls.rn = 1
#         WHERE COALESCE(sa.teacher_mark, sa.ai_mark) = q.question_mark 
#     """)
#     correct_questions_count = db.execute(questions_query, {"sid": student_id}).scalar() or 0
    
#     g_ex = get_text(user_lang, "امتياز", "Excellent")
#     g_vg = get_text(user_lang, "جيد جداً", "Very Good")
#     g_gd = get_text(user_lang, "جيد", "Good")
#     g_pa = get_text(user_lang, "مقبول", "Pass")
#     g_fa = get_text(user_lang, "ضعيف", "Fail")

#     recent_query = text("""
#         WITH LatestSheets AS (
#             SELECT ans.total_earned_mark, e.total_marks, e.exam_id, e.exam_title, e.exam_date, e.number_of_questions, c.course_name,
#                    ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
#             FROM answer_sheet ans
#             JOIN exam e ON ans.exam_id = e.exam_id
#             JOIN folder f ON e.folder_id = f.folder_id
#             JOIN teacher_courses tc ON f.tc_id = tc.tc_id
#             JOIN courses c ON tc.course_id = c.course_id
#             JOIN semesters s ON tc.semester_id = s.semester_id
#             WHERE ans.student_id = :sid 
#               AND ans.status IN ('Graded', 'graded')
#               AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
#         )
#         SELECT course_name, exam_title, total_earned_mark, total_marks, exam_date, number_of_questions, exam_id,
#                CASE 
#                    WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 90 THEN :g_ex
#                    WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 80 THEN :g_vg
#                    WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 70 THEN :g_gd
#                    WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 50 THEN :g_pa
#                    ELSE :g_fa
#                END as grade_text
#         FROM LatestSheets WHERE rn = 1
#         ORDER BY exam_date DESC LIMIT 3
#     """)
#     recent_results = db.execute(recent_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year, "g_ex": g_ex, "g_vg": g_vg, "g_gd": g_gd, "g_pa": g_pa, "g_fa": g_fa}).mappings().fetchall()
    
#     exams_count = int(stats["exams_count"]) if stats else 0
#     passed_exams = int(stats["passed_exams"]) if stats else 0
#     gpa = float(stats["gpa"]) if stats else 0
#     highest = float(stats["highest_score"]) if stats else 0
    
#     success_rate = (passed_exams / exams_count * 100) if exams_count > 0 else 0
    
#     if success_rate >= 85:
#         level = get_text(user_lang, "مستوى ممتاز", "Excellent")
#     elif success_rate >= 70:
#         level = get_text(user_lang, "مستوى جيد", "Good")
#     else:
#         level = get_text(user_lang, "يحتاج تحسين", "Needs Improvement")
        
#     formatted_recent = []
#     for row in recent_results:
#         total_m = float(row["total_marks"]) if row["total_marks"] else 0
#         earned_m = float(row["total_earned_mark"]) if row["total_earned_mark"] else 0
#         percentage = (earned_m / total_m) * 100 if total_m > 0 else 0
        
#         formatted_recent.append({
#             "id": str(row["exam_id"]),
#             "score": f"{round(percentage)}%", 
#             "total_earned_mark": str(round(earned_m)), 
#             "label": row["grade_text"],
#             "title": row["exam_title"],
#             "subject": row["course_name"] or get_text(user_lang, "غير معروف", "Unknown"),
#             "date": str(row["exam_date"]) if row["exam_date"] else "",
#             "total_questions": str(row["number_of_questions"] or 0),
#             "answered_questions": "0"
#         })
    
#     level_val = translate_live(profile['level_name'], user_lang) if profile else ""
#     dept_val = translate_live(profile['department_name'], user_lang) if profile else ""

#     return {
#         "stats": {
#             "name": profile["full_name"] if profile else get_text(user_lang, "غير معروف", "Unknown"),
#             "level": f"{level_val} - {dept_val}" if profile else "",
#             "badge": f"{round(gpa)}", 
#             "highest_score": f"{round(highest)}",
#             "gpa": f"{round(gpa, 1)}%",
#             "exams_count": str(exams_count),
#             "subjects_count": str(subjects_count),
#         },
#         "recent_results": formatted_recent,
#         "performance": {
#             "graded_exams": str(passed_exams),              
#             "total_exams": str(exams_count),                
#             "success_rate": f"{round(success_rate, 1)}%",   
#             "average_ai_score": f"{round(gpa, 1)}%",        
#             "performance_level": level,
#             "questions_mastered": str(correct_questions_count),      
#         }
#     }
#     return raw_payload

# # ══════════════════════════════════════════════════════════════════════════════
# # 2. دالة صفحة المواد الدراسية
# # ══════════════════════════════════════════════════════════════════════════════
# def get_student_subjects_data(db, student_id):
#     student_id = resolve_student_id(db, student_id) # 👈 هنا التصحيح    
#     lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")
#     user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"

#     semesters_query = text("""
#         SELECT DISTINCT sem.semester_id, sem.semester_name FROM student_courses sc
#         JOIN semesters sem ON sc.semester_id = sem.semester_id WHERE sc.student_id = :sid ORDER BY sem.semester_id
#     """)
#     semesters_records = db.execute(semesters_query, {"sid": student_id}).fetchall()
    
#     # 🌟 الترجمة الحية للسمسترات
#     semesters_list = [{"id": sem.semester_id, "name": translate_live(sem.semester_name, user_lang)} for sem in semesters_records] # 👈 التعديل تم هنا

#     stats_query = text("""
#         SELECT sc.semester_id, COUNT(DISTINCT ans.exam_id) AS exams_count, MAX(ans.total_earned_mark) AS highest_score,
#             AVG((CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100) AS avg_percentage, COUNT(DISTINCT sc.course_id) AS subjects_count
#         FROM student_courses sc
#         LEFT JOIN teacher_courses tc ON sc.course_id = tc.course_id AND tc.semester_id = sc.semester_id
#         LEFT JOIN folder f ON f.tc_id = tc.tc_id LEFT JOIN exam e ON e.folder_id = f.folder_id
#         LEFT JOIN answer_sheet ans ON e.exam_id = ans.exam_id AND ans.student_id = sc.student_id AND ans.status = 'Graded'
#         WHERE sc.student_id = :sid GROUP BY sc.semester_id
#     """)
#     stats_records = db.execute(stats_query, {"sid": student_id}).fetchall()
    
#     stats_by_semester = {
#         row.semester_id: {
#             "highest_score": str(round(row.highest_score or 0)),        
#             "average_score": f"{round(row.avg_percentage or 0, 1)}%",   
#             "total_exams": str(row.exams_count or 0),
#             "total_subjects": str(row.subjects_count or 0)
#         } for row in stats_records
#     }

#     subjects_query = text("""
#     SELECT c.course_id, c.course_name, sc.semester_id,
#         (SELECT u.full_name FROM teacher_courses tc_t JOIN teacher t ON tc_t.teacher_id = t.teacher_id
#          JOIN users u ON t.user_id = u.user_id WHERE tc_t.course_id = c.course_id AND tc_t.semester_id = sc.semester_id LIMIT 1) AS teacher_name,
#         COUNT(DISTINCT ans.exam_id) AS exams_taken, 
#         SUM(ans.total_earned_mark) AS total_earned_mark, 
#         MAX(CASE WHEN ans.exam_id IS NOT NULL THEN e.exam_date ELSE NULL END) AS last_exam_date
#     FROM student_courses sc 
#     JOIN courses c ON sc.course_id = c.course_id
#     LEFT JOIN teacher_courses tc ON c.course_id = tc.course_id AND tc.semester_id = sc.semester_id
#     LEFT JOIN folder f ON f.tc_id = tc.tc_id 
#     LEFT JOIN exam e ON e.folder_id = f.folder_id
#     LEFT JOIN answer_sheet ans ON e.exam_id = ans.exam_id AND ans.student_id = sc.student_id AND ans.status = 'Graded'
#     WHERE sc.student_id = :sid 
#     GROUP BY c.course_id, c.course_name, sc.semester_id
#     """)
#     subjects_records = db.execute(subjects_query, {"sid": student_id}).fetchall()

#     semester_data = {}
#     for sem in semesters_list:
#         sem_id_str = str(sem["id"])
#         semester_data[sem_id_str] = {
#             "top_stats": stats_by_semester.get(sem["id"], {"highest_score": "0", "average_score": "0%", "total_exams": "0", "total_subjects": "0"}),
#             "subjects": []
#         }

#     for row in subjects_records:
#         sem_id_str = str(row.semester_id)
#         if sem_id_str in semester_data:
#             # 🌟 إضافة الفواصل بشكل صحيح واستخدام get_text
#             teacher_prefix = get_text(user_lang, 'أ. ', 'Mr./Ms. ')
#             teacher_val = f"{teacher_prefix}{row.teacher_name}" if row.teacher_name else get_text(user_lang, "غير محدد", "Not specified")
            
#             semester_data[sem_id_str]["subjects"].append({
#                 "name": row.course_name or get_text(user_lang, "غير معروف", "Unknown"),
#                 "teacher": teacher_val,
#                 "total_earned_mark": str(round(row.total_earned_mark or 0)),
#                 "exams": str(row.exams_taken or 0),
#                 "lastExam": row.last_exam_date.strftime("%Y-%m-%d") if row.last_exam_date else get_text(user_lang, "لا يوجد", "None")
#             })

#     return {"semesters": semesters_list, "semester_data": semester_data}

# # ══════════════════════════════════════════════════════════════════════════════
# # 3. دالة تفاصيل مادة معينة
# # ══════════════════════════════════════════════════════════════════════════════
# def get_subject_details_data(db, student_id, course_name):
#     student_id = resolve_student_id(db, student_id) # 👈 هنا التصحيح    
#     lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")
#     user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"

#     stats_query = text("""
#         SELECT 
#             COUNT(DISTINCT ans.exam_id) AS exams_count,
#             COALESCE(MAX(ans.total_earned_mark), 0) AS max_grade,
#             COALESCE(MIN(ans.total_earned_mark), 0) AS min_grade,
#             COALESCE(AVG((CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100), 0) AS avg_grade
#         FROM answer_sheet ans
#         JOIN exam e ON ans.exam_id = e.exam_id
#         JOIN folder f ON e.folder_id = f.folder_id
#         JOIN teacher_courses tc ON f.tc_id = tc.tc_id
#         JOIN courses c ON tc.course_id = c.course_id
#         WHERE ans.student_id = :sid 
#           AND c.course_name = :cname 
#           AND ans.status = 'Graded'
#     """)
#     stats = db.execute(stats_query, {"sid": student_id, "cname": course_name}).mappings().first()

#     # 🌟 تجهيز التقييم
#     g_ex = get_text(user_lang, "امتياز", "Excellent")
#     g_vg = get_text(user_lang, "جيد جداً", "Very Good")
#     g_gd = get_text(user_lang, "جيد", "Good")
#     g_pa = get_text(user_lang, "مقبول", "Pass")
#     g_fa = get_text(user_lang, "ضعيف", "Fail")

#     exams_query = text(f"""
#         SELECT e.exam_title, e.exam_date, ans.total_earned_mark, e.total_marks, e.number_of_questions,
#             (SELECT COUNT(*) FROM student_answers sa WHERE sa.sheet_id = ans.sheet_id) AS answered_count,
#             CASE 
#                 WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 90 THEN '{g_ex}'
#                 WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 80 THEN '{g_vg}'
#                 WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 70 THEN '{g_gd}'
#                 WHEN (CAST(ans.total_earned_mark AS FLOAT) / NULLIF(e.total_marks, 0)) * 100 >= 50 THEN '{g_pa}'
#                 ELSE '{g_fa}'
#             END as rating
#         FROM answer_sheet ans JOIN exam e ON ans.exam_id = e.exam_id LEFT JOIN folder f ON e.folder_id = f.folder_id
#         LEFT JOIN teacher_courses tc ON f.tc_id = tc.tc_id LEFT JOIN courses c ON tc.course_id = c.course_id
#         WHERE ans.student_id = :sid AND c.course_name = :cname AND ans.status = 'Graded' ORDER BY e.exam_date DESC
#     """)
#     exams_records = db.execute(exams_query, {"sid": student_id, "cname": course_name}).mappings().fetchall()

#     formatted_exams = []
#     for row in exams_records:
#         formatted_exams.append({
#             "title": row["exam_title"],
#             "date": row["exam_date"].strftime("%Y-%m-%d") if row["exam_date"] else get_text(user_lang, "غير محدد", "Not specified"),
#             "total_earned_mark": str(round(row["total_earned_mark"] or 0)), 
#             "total_marks": str(round(row["total_marks"] or 0)),
#             "total": str(row["number_of_questions"] or 0),            
#             "answers": str(row["answered_count"] or 0),                
#             "rating": row["rating"]
#         })

#     avg = float(stats["avg_grade"]) if stats else 0.0
#     min_grade = float(stats["min_grade"]) if stats else 0.0
#     max_grade = float(stats["max_grade"]) if stats else 0.0
#     exams_count = int(stats["exams_count"]) if stats else 0

#     ai_summary_query = text("""
#         SELECT sc.subject_strengths, sc.subject_weaknesses
#         FROM student_courses sc
#         JOIN courses c ON sc.course_id = c.course_id
#         WHERE sc.student_id = :sid AND c.course_name = :cname
#     """)
#     ai_summary = db.execute(ai_summary_query, {"sid": student_id, "cname": course_name}).mappings().first()

#     if ai_summary:
#         if ai_summary["subject_strengths"]:
#             translated_strengths = translate_live(ai_summary["subject_strengths"], user_lang) # 👈 الترجمة هنا
#             strengths = translated_strengths.split('\n')
#         else:
#             strengths = [get_text(user_lang, "في انتظار تقييم الذكاء الاصطناعي...", "Waiting for AI evaluation...")]

#         if ai_summary["subject_weaknesses"]:
#             translated_weaknesses = translate_live(ai_summary["subject_weaknesses"], user_lang) # 👈 الترجمة هنا
#             improvements = translated_weaknesses.split('\n')
#         else:
#             improvements = [get_text(user_lang, "في انتظار تقييم الذكاء الاصطناعي...", "Waiting for AI evaluation...")]
#     else:
#         strengths = [get_text(user_lang, "لا توجد بيانات حالياً", "No data available")]
#         improvements = [get_text(user_lang, "لا توجد بيانات حالياً", "No data available")]

#     return {
#         "stats": {
#             "min": str(round(min_grade)),                
#             "max": str(round(max_grade)),                
#             "avg": f"{round(avg, 1)}%",                  
#             "count": str(exams_count)                    
#         },
#         "exams": formatted_exams,
#         "strengths": strengths,
#         "improvements": improvements
#     }

# # ══════════════════════════════════════════════════════════════════════════════
# # 4. دالة تفاصيل ورقة اختبار معين
# # ══════════════════════════════════════════════════════════════════════════════
# def get_exam_details_data(db, student_id, exam_title):
#     student_id = resolve_student_id(db, student_id) # 👈 هنا التصحيح    
#     lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")
#     user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"

#     stats_query = text("""
#         SELECT 
#             ans.sheet_id,
#             ans.total_earned_mark,
#             e.exam_id,
#             e.total_marks
#         FROM answer_sheet ans
#         JOIN exam e ON ans.exam_id = e.exam_id
#         WHERE ans.student_id = :sid AND e.exam_title = :etitle
#         LIMIT 1
#     """)
#     stats_record = db.execute(stats_query, {"sid": student_id, "etitle": exam_title}).mappings().first()

#     sheet_id = stats_record["sheet_id"] if stats_record else 0
#     exam_id = stats_record["exam_id"] if stats_record else 0
#     total_earned_mark = stats_record["total_earned_mark"] if stats_record else 0
#     total_marks = stats_record["total_marks"] if stats_record else 100

#     questions_query = text("""
#         SELECT 
#             q.question_id,
#             q.question_order,
#             q.question_text,
#             q.question_mark AS total,
#             sa.extracted_text AS student_answer,
#             sa.teacher_mark,
#             sa.ai_mark,
#             sa.ai_feedback AS evaluation,
#             ea.answer_text AS model_answer
#         FROM questions q
#         LEFT JOIN student_answers sa ON q.question_id = sa.question_id AND sa.sheet_id = :sheet_id
#         LEFT JOIN expected_answers ea ON q.question_id = ea.question_id
#         WHERE q.exam_id = :exam_id
#         ORDER BY q.question_order ASC
#     """)
#     questions_records = db.execute(questions_query, {"sheet_id": sheet_id, "exam_id": exam_id}).mappings().fetchall()

#     correct_count = 0
#     wrong_count = 0
#     partial_count = 0
#     formatted_questions = []

#     for row in questions_records:
#         q_order = row["question_order"]
#         total_q_mark = float(row["total"] or 0.0)
        
#         t_mark = row["teacher_mark"]
#         a_mark = row["ai_mark"]
#         earned_score = float(t_mark) if t_mark is not None else float(a_mark) if a_mark is not None else 0.0

#         if earned_score >= total_q_mark and total_q_mark > 0:
#             correct_count += 1
#         elif earned_score == 0.0 or (t_mark is None and a_mark is None):
#             wrong_count += 1
#         else:
#             partial_count += 1

#         # 🌟 الترجمة الحية لتقييم الذكاء الاصطناعي الخاص بكل سؤال
#         eval_text = row["evaluation"]
#         final_evaluation = translate_live(eval_text, user_lang) if eval_text else get_text(user_lang, "في انتظار التقييم الذكي", "Waiting for AI evaluation") # 👈 التعديل تم هنا

#         formatted_questions.append({
#             "id": str(q_order or 1),
#             "text": row["question_text"] or get_text(user_lang, "بدون نص", "No text"),
#             "score": earned_score,
#             "total": total_q_mark,
#             "modelAnswer": row["model_answer"] or get_text(user_lang, "الإجابة النموذجية قيد المراجعة", "Model answer under review"),
#             "studentAnswer": row["student_answer"] or get_text(user_lang, "لم يتم استخراج الإجابة", "Answer not extracted"),
#             "evaluation": final_evaluation # 👈 هنا المتغير المترجم 
#         })

#     images_query = text("""
#         SELECT image_path 
#         FROM sheet_images 
#         WHERE sheet_id = :sheet_id 
#         ORDER BY page_number ASC
#     """)
#     images_records = db.execute(images_query, {"sheet_id": sheet_id}).mappings().fetchall()
    
#     base_url = "http://127.0.0.1:8000/" 
#     paper_images = []
    
#     for row in images_records:
#         if row["image_path"]:
#             clean_path = row["image_path"].lstrip('/')
#             paper_images.append(f"{base_url}{clean_path}")

#     return {
#         "stats": {
#             "exam_id": str(exam_id), # 👈 أضيفي هذا السطر السحري فقط!
#             "total_earned_mark": str(round(total_earned_mark or 0)),
#             "total_marks": str(round(total_marks or 100)),
#             "total_questions": str(len(formatted_questions)),
#             "correct": str(correct_count),
#             "wrong": str(wrong_count),
#             "partial": str(partial_count),
#         },
#         "questions": formatted_questions,
#         "paper_images": paper_images
#     }

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

# ══════════════════════════════════════════════════════════════════════════════
# 1. دالة الداشبورد الرئيسية (مع حل الانفجار الديكارتي للحسابات)
# ══════════════════════════════════════════════════════════════════════════════
@router.get("/student-dashboard/{student_id}")
def get_student_dashboard_data(student_id: int, db: Session = Depends(get_db)):
    student_id = resolve_student_id(db, student_id) # 👈 الحماية هنا
    
    current_year_query = text("SELECT academic_year FROM semesters WHERE is_current = true LIMIT 1")
    current_year = db.execute(current_year_query).scalar()
    if not current_year:
        current_year = db.execute(text("SELECT academic_year FROM semesters ORDER BY semester_id DESC LIMIT 1")).scalar()
    
    year_pattern = f"{current_year}%" if current_year else "%"
    if current_year and "/" in current_year:
        year_base = current_year.split("/")[0]
        year_pattern = f"{year_base}%"

    profile_query = text("""
        SELECT u.full_name, l.level_name, d.department_name, u.language_code
        FROM student s
        JOIN users u ON s.user_id = u.user_id
        JOIN level l ON s.level_id = l.level_id
        JOIN department d ON s.department_id = d.department_id
        WHERE s.student_id = :sid
    """)
    profile = db.execute(profile_query, {"sid": student_id}).mappings().first()
    user_lang = profile["language_code"] if profile and profile["language_code"] else "ar"

    # 🌟 الحل السحري للحسابات: أخذ أحدث ورقة إجابة فقط لكل اختبار لمنع تكرار الأرقام
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
              AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
        )
        SELECT 
            COUNT(exam_id) AS exams_count,
            COALESCE(MAX(total_earned_mark), 0) AS highest_score,
            COALESCE(AVG((CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100), 0) AS gpa,
            COALESCE(SUM(CASE WHEN total_earned_mark >= passing_mark THEN 1 ELSE 0 END), 0) AS passed_exams
        FROM LatestSheets WHERE rn = 1
    """)
    stats = db.execute(stats_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year}).mappings().first()

    subjects_query = text("""
        SELECT COUNT(DISTINCT sc.course_id)
        FROM student_courses sc
        JOIN semesters s ON sc.semester_id = s.semester_id
        WHERE sc.student_id = :sid AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
    """)
    subjects_count = db.execute(subjects_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year}).scalar() or 0

    questions_query = text("""
        WITH LatestSheets AS (
            SELECT sheet_id, ROW_NUMBER() OVER(PARTITION BY exam_id ORDER BY uploaded_at DESC) as rn
            FROM answer_sheet WHERE student_id = :sid AND status IN ('Graded', 'graded')
        )
        SELECT COUNT(sa.answer_id)
        FROM student_answers sa
        JOIN questions q ON sa.question_id = q.question_id  
        JOIN LatestSheets ls ON sa.sheet_id = ls.sheet_id AND ls.rn = 1
        WHERE COALESCE(sa.teacher_mark, sa.ai_mark) = q.question_mark 
    """)
    correct_questions_count = db.execute(questions_query, {"sid": student_id}).scalar() or 0
    
    g_ex = get_text(user_lang, "امتياز", "Excellent")
    g_vg = get_text(user_lang, "جيد جداً", "Very Good")
    g_gd = get_text(user_lang, "جيد", "Good")
    g_pa = get_text(user_lang, "مقبول", "Pass")
    g_fa = get_text(user_lang, "ضعيف", "Fail")

    recent_query = text("""
        WITH LatestSheets AS (
            SELECT ans.total_earned_mark, e.total_marks, e.exam_id, e.exam_title, e.exam_date, e.number_of_questions, c.course_name,
                   ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
            FROM answer_sheet ans
            JOIN exam e ON ans.exam_id = e.exam_id
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id
            JOIN courses c ON tc.course_id = c.course_id
            JOIN semesters s ON tc.semester_id = s.semester_id
            WHERE ans.student_id = :sid 
              AND ans.status IN ('Graded', 'graded')
              AND (s.academic_year LIKE :year OR s.academic_year = :raw_year)
        )
        SELECT course_name, exam_title, total_earned_mark, total_marks, exam_date, number_of_questions, exam_id,
               CASE 
                   WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 90 THEN :g_ex
                   WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 80 THEN :g_vg
                   WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 70 THEN :g_gd
                   WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 50 THEN :g_pa
                   ELSE :g_fa
               END as grade_text
        FROM LatestSheets WHERE rn = 1
        ORDER BY exam_date DESC LIMIT 3
    """)
    recent_results = db.execute(recent_query, {"sid": student_id, "year": year_pattern, "raw_year": current_year, "g_ex": g_ex, "g_vg": g_vg, "g_gd": g_gd, "g_pa": g_pa, "g_fa": g_fa}).mappings().fetchall()
    
    exams_count = int(stats["exams_count"]) if stats else 0
    passed_exams = int(stats["passed_exams"]) if stats else 0
    gpa = float(stats["gpa"]) if stats else 0
    highest = float(stats["highest_score"]) if stats else 0
    
    success_rate = (passed_exams / exams_count * 100) if exams_count > 0 else 0
    
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
            "date": str(row["exam_date"]) if row["exam_date"] else "",
            "total_questions": str(row["number_of_questions"] or 0),
            "answered_questions": "0"
        })
    
    level_val = translate_live(profile['level_name'], user_lang) if profile else ""
    dept_val = translate_live(profile['department_name'], user_lang) if profile else ""

    return {
        # 🌟 رجعنا الاسم والمستوى برّا عشان فلاتر يقدر يقرأهم
        "name": profile["full_name"] if profile else get_text(user_lang, "غير معروف", "Unknown"),
        "level": f"{level_val} - {dept_val}" if profile else "",
        "badge": f"{round(gpa)}", 
        "stats": {
            "highest_score": f"{round(highest)}",
            "gpa": f"{round(gpa, 1)}%",
            "exams_count": str(exams_count),
            "subjects_count": str(subjects_count),
        },
        "recent_results": formatted_recent,
        "performance": {
            "graded_exams": str(passed_exams),              
            "total_exams": str(exams_count),                
            "success_rate": f"{round(success_rate, 1)}%",   
            "average_ai_score": f"{round(gpa, 1)}%",        
            "performance_level": level,
            "questions_mastered": str(correct_questions_count),      
        }
    }
# ══════════════════════════════════════════════════════════════════════════════
# 2. دالة صفحة المواد الدراسية
# ══════════════════════════════════════════════════════════════════════════════
@router.get("/student-subjects/{student_id}")
def get_student_subjects_data(student_id: int, db: Session = Depends(get_db)):
    student_id = resolve_student_id(db, student_id)
    lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")
    user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"

    semesters_query = text("""
        SELECT DISTINCT sem.semester_id, sem.semester_name FROM student_courses sc
        JOIN semesters sem ON sc.semester_id = sem.semester_id WHERE sc.student_id = :sid ORDER BY sem.semester_id
    """)
    semesters_records = db.execute(semesters_query, {"sid": student_id}).fetchall()
    semesters_list = [{"id": sem.semester_id, "name": translate_live(sem.semester_name, user_lang)} for sem in semesters_records]

    stats_query = text("""
        WITH LatestSheets AS (
            SELECT ans.exam_id, ans.total_earned_mark, tc.semester_id, e.total_marks,
                   ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
            FROM answer_sheet ans
            JOIN exam e ON ans.exam_id = e.exam_id
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id
            WHERE ans.student_id = :sid AND ans.status IN ('Graded', 'graded')
        )
        SELECT sc.semester_id,
               COALESCE(COUNT(DISTINCT ls.exam_id), 0) AS exams_count,
               COALESCE(MAX(ls.total_earned_mark), 0) AS highest_score,
               COALESCE(AVG((CAST(ls.total_earned_mark AS FLOAT) / NULLIF(ls.total_marks, 0)) * 100), 0) AS avg_percentage,
               COUNT(DISTINCT sc.course_id) AS subjects_count
        FROM student_courses sc
        LEFT JOIN LatestSheets ls ON ls.semester_id = sc.semester_id AND ls.rn = 1
        WHERE sc.student_id = :sid
        GROUP BY sc.semester_id
    """)
    stats_records = db.execute(stats_query, {"sid": student_id}).fetchall()
    
    stats_by_semester = {
        row.semester_id: {
            "highest_score": str(round(row.highest_score or 0)),        
            "average_score": f"{round(row.avg_percentage or 0, 1)}%",   
            "total_exams": str(row.exams_count or 0),
            "total_subjects": str(row.subjects_count or 0)
        } for row in stats_records
    }

    subjects_query = text("""
        WITH LatestSheets AS (
            SELECT ans.exam_id, e.exam_date, ans.total_earned_mark, tc.course_id, tc.semester_id,
                   ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
            FROM answer_sheet ans
            JOIN exam e ON ans.exam_id = e.exam_id
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id
            WHERE ans.student_id = :sid AND ans.status IN ('Graded', 'graded')
        )
        SELECT c.course_id, c.course_name, sc.semester_id,
            (SELECT u.full_name FROM teacher_courses tc_t JOIN teacher t ON tc_t.teacher_id = t.teacher_id
             JOIN users u ON t.user_id = u.user_id WHERE tc_t.course_id = c.course_id AND tc_t.semester_id = sc.semester_id LIMIT 1) AS teacher_name,
            COUNT(DISTINCT ls.exam_id) AS exams_taken, 
            SUM(ls.total_earned_mark) AS total_earned_mark, 
            MAX(ls.exam_date) AS last_exam_date
        FROM student_courses sc 
        JOIN courses c ON sc.course_id = c.course_id
        LEFT JOIN LatestSheets ls ON c.course_id = ls.course_id AND ls.semester_id = sc.semester_id AND ls.rn = 1
        WHERE sc.student_id = :sid 
        GROUP BY c.course_id, c.course_name, sc.semester_id
    """)
    subjects_records = db.execute(subjects_query, {"sid": student_id}).fetchall()

    semester_data = {}
    for sem in semesters_list:
        sem_id_str = str(sem["id"])
        semester_data[sem_id_str] = {
            "top_stats": stats_by_semester.get(sem["id"], {"highest_score": "0", "average_score": "0%", "total_exams": "0", "total_subjects": "0"}),
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
                "total_earned_mark": str(round(row.total_earned_mark or 0)),
                "exams": str(row.exams_taken or 0),
                "lastExam": row.last_exam_date.strftime("%Y-%m-%d") if row.last_exam_date else get_text(user_lang, "لا يوجد", "None")
            })

    return {"semesters": semesters_list, "semester_data": semester_data}

# ══════════════════════════════════════════════════════════════════════════════
# 3. دالة تفاصيل مادة معينة
# ══════════════════════════════════════════════════════════════════════════════
@router.get("/subject-details/{student_id}/{course_name}")
def get_subject_details_data(student_id: int, course_name: str, db: Session = Depends(get_db)):
    student_id = resolve_student_id(db, student_id)
    lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")
    user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"

    stats_query = text("""
        WITH LatestSheets AS (
            SELECT ans.exam_id, ans.total_earned_mark, e.total_marks, tc.course_id,
                   ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
            FROM answer_sheet ans
            JOIN exam e ON ans.exam_id = e.exam_id
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id
            JOIN courses c ON tc.course_id = c.course_id
            WHERE ans.student_id = :sid AND c.course_name = :cname AND ans.status IN ('Graded', 'graded')
        )
        SELECT 
            COUNT(exam_id) AS exams_count,
            COALESCE(MAX(total_earned_mark), 0) AS max_grade,
            COALESCE(MIN(total_earned_mark), 0) AS min_grade,
            COALESCE(AVG((CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100), 0) AS avg_grade
        FROM LatestSheets WHERE rn = 1
    """)
    stats = db.execute(stats_query, {"sid": student_id, "cname": course_name}).mappings().first()

    g_ex = get_text(user_lang, "امتياز", "Excellent")
    g_vg = get_text(user_lang, "جيد جداً", "Very Good")
    g_gd = get_text(user_lang, "جيد", "Good")
    g_pa = get_text(user_lang, "مقبول", "Pass")
    g_fa = get_text(user_lang, "ضعيف", "Fail")

    exams_query = text("""
        WITH LatestSheets AS (
            SELECT ans.sheet_id, ans.total_earned_mark, e.total_marks, e.exam_title, e.exam_date, e.number_of_questions,
                   ROW_NUMBER() OVER(PARTITION BY ans.exam_id ORDER BY ans.uploaded_at DESC) as rn
            FROM answer_sheet ans 
            JOIN exam e ON ans.exam_id = e.exam_id 
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id 
            JOIN courses c ON tc.course_id = c.course_id
            WHERE ans.student_id = :sid AND c.course_name = :cname AND ans.status IN ('Graded', 'graded')
        )
        SELECT exam_title, exam_date, total_earned_mark, total_marks, number_of_questions,
            (SELECT COUNT(*) FROM student_answers sa WHERE sa.sheet_id = ls.sheet_id) AS answered_count,
            CASE 
                WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 90 THEN :g_ex
                WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 80 THEN :g_vg
                WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 70 THEN :g_gd
                WHEN (CAST(total_earned_mark AS FLOAT) / NULLIF(total_marks, 0)) * 100 >= 50 THEN :g_pa
                ELSE :g_fa
            END as rating
        FROM LatestSheets ls WHERE rn = 1 ORDER BY exam_date DESC
    """)
    exams_records = db.execute(exams_query, {"sid": student_id, "cname": course_name, "g_ex": g_ex, "g_vg": g_vg, "g_gd": g_gd, "g_pa": g_pa, "g_fa": g_fa}).mappings().fetchall()

    formatted_exams = []
    for row in exams_records:
        formatted_exams.append({
            "title": row["exam_title"],
            "date": row["exam_date"].strftime("%Y-%m-%d") if row["exam_date"] else get_text(user_lang, "غير محدد", "Not specified"),
            "total_earned_mark": str(round(row["total_earned_mark"] or 0)), 
            "total_marks": str(round(row["total_marks"] or 0)),
            "total": str(row["number_of_questions"] or 0),            
            "answers": str(row["answered_count"] or 0),                
            "rating": row["rating"]
        })

    avg = float(stats["avg_grade"]) if stats else 0.0
    min_grade = float(stats["min_grade"]) if stats else 0.0
    max_grade = float(stats["max_grade"]) if stats else 0.0
    exams_count = int(stats["exams_count"]) if stats else 0

    ai_summary_query = text("""
        SELECT sc.subject_strengths, sc.subject_weaknesses
        FROM student_courses sc
        JOIN courses c ON sc.course_id = c.course_id
        WHERE sc.student_id = :sid AND c.course_name = :cname
    """)
    ai_summary = db.execute(ai_summary_query, {"sid": student_id, "cname": course_name}).mappings().first()

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
            "min": str(round(min_grade)),                
            "max": str(round(max_grade)),                
            "avg": f"{round(avg, 1)}%",                  
            "count": str(exams_count)                    
        },
        "exams": formatted_exams,
        "strengths": strengths,
        "improvements": improvements
    }

# ══════════════════════════════════════════════════════════════════════════════
# 4. دالة تفاصيل ورقة اختبار معين
# ══════════════════════════════════════════════════════════════════════════════
@router.get("/exam-details/{student_id}/{exam_title}")
def get_exam_details_data(student_id: int, exam_title: str, db: Session = Depends(get_db)):
    student_id = resolve_student_id(db, student_id)
    lang_query = text("SELECT language_code FROM users u JOIN student s ON u.user_id = s.user_id WHERE s.student_id = :sid LIMIT 1")
    user_lang = db.execute(lang_query, {"sid": student_id}).scalar() or "ar"

    stats_query = text("""
        SELECT 
            ans.sheet_id, ans.total_earned_mark, e.exam_id, e.total_marks
        FROM answer_sheet ans
        JOIN exam e ON ans.exam_id = e.exam_id
        WHERE ans.student_id = :sid AND e.exam_title = :etitle
        ORDER BY ans.uploaded_at DESC
        LIMIT 1
    """)
    stats_record = db.execute(stats_query, {"sid": student_id, "etitle": exam_title}).mappings().first()

    sheet_id = stats_record["sheet_id"] if stats_record else 0
    exam_id = stats_record["exam_id"] if stats_record else 0
    total_earned_mark = stats_record["total_earned_mark"] if stats_record else 0
    total_marks = stats_record["total_marks"] if stats_record else 100

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
        q_order = row["question_order"]
        total_q_mark = float(row["total"] or 0.0)
        
        t_mark = row["teacher_mark"]
        a_mark = row["ai_mark"]
        earned_score = float(t_mark) if t_mark is not None else float(a_mark) if a_mark is not None else 0.0

        if earned_score >= total_q_mark and total_q_mark > 0:
            correct_count += 1
        elif earned_score == 0.0 or (t_mark is None and a_mark is None):
            wrong_count += 1
        else:
            partial_count += 1

        eval_text = row["evaluation"]
        final_evaluation = translate_live(eval_text, user_lang) if eval_text else get_text(user_lang, "في انتظار التقييم الذكي", "Waiting for AI evaluation")

        formatted_questions.append({
            "id": str(q_order or 1),
            "text": row["question_text"] or get_text(user_lang, "بدون نص", "No text"),
            "score": earned_score,
            "total": total_q_mark,
            "modelAnswer": row["model_answer"] or get_text(user_lang, "الإجابة النموذجية قيد المراجعة", "Model answer under review"),
            "studentAnswer": row["student_answer"] or get_text(user_lang, "لم يتم استخراج الإجابة", "Answer not extracted"),
            "evaluation": final_evaluation 
        })

    images_query = text("""
        SELECT image_path 
        FROM sheet_images 
        WHERE sheet_id = :sheet_id 
        ORDER BY page_number ASC
    """)
    images_records = db.execute(images_query, {"sheet_id": sheet_id}).mappings().fetchall()
    
    base_url = "https://smart-grader-full.onrender.com/" 
    paper_images = []
    
    for row in images_records:
        if row["image_path"]:
            clean_path = row["image_path"].lstrip('/')
            paper_images.append(f"{base_url}{clean_path}")

    return {
        "stats": {
            "exam_id": str(exam_id),
            "total_earned_mark": str(round(total_earned_mark or 0)),
            "total_marks": str(round(total_marks or 100)),
            "total_questions": str(len(formatted_questions)),
            "correct": str(correct_count),
            "wrong": str(wrong_count),
            "partial": str(partial_count),
        },
        "questions": formatted_questions,
        "paper_images": paper_images
    }