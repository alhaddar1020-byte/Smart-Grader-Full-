import sys
import os

# هذا السطر يخبر بايثون أن ينظر في المجلد الحالي بحثاً عن الملفات
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from sqlalchemy.orm import Session
from db.database import SessionLocal, engine
from models.base import Base
from models.users import User, Role, VerificationCode
from models.academic import Department, Level, StudentCourse
from models.profiles import Student, Teacher, Admin, Course
from models.exams import Semester, TeacherCourse, Folder, Exam
from models.grading import AnswerSheet, Question, ExpectedAnswer, StudentAnswer, Report, SheetImage
from models.settings import SystemSetting, ActivityLog, BackupHistory, ImportHistory
from datetime import datetime, timedelta

# تأكدي من إنشاء الجداول أولاً

def seed_all_data():
    db = SessionLocal()
    try:
        # 1. الإعدادات العامة (Settings)
        setting = SystemSetting(university_name="جامعة ذمار", college_name="كلية الحاسبات")
        db.add(setting)

        # 2. الأدوار والمستخدمين (Users & Roles)
        roles = [Role(role_name="Admin"), Role(role_name="Teacher"), Role(role_name="Student")]
        db.add_all(roles)
        db.commit() # نحتاج الـ IDs للخطوات القادمة

        users = [
            User(full_name="علي الآدمن", email="admin@mail.com", password="123"),
            User(full_name="د. هند المعلمة", email="hind@mail.com", password="123"),
            User(full_name="عمر الطالب", email="omar@mail.com", password="123")
        ]
        db.add_all(users)
        db.commit()

        # 3. الأقسام والمستويات (Academic Basics)
        depts = [Department(department_name="تقنية المعلومات"), Department(department_name="علوم حاسوب")]
        levels = [Level(level_name="المستوى الأول"), Level(level_name="المستوى الثاني")]
        db.add_all(depts + levels)
        db.commit()

        # 4. الملفات الشخصية (Profiles)
        admin_p = Admin(user_id=users[0].user_id)
        teacher_p = Teacher(user_id=users[1].user_id)
        student_p = Student(user_id=users[2].user_id, university_id="UG2024-001", 
                            department_id=depts[0].department_id, level_id=levels[0].level_id)
        db.add_all([admin_p, teacher_p, student_p])
        
        courses = [
            Course(course_name="أساسيات البرمجة", level_id=levels[0].level_id),
            Course(course_name="تراكيب البيانات", level_id=levels[1].level_id)
        ]
        db.add_all(courses)
        db.commit()

        # 5. الأترام والتكاليف (Exams & Academic Setup)
        semester = Semester(semester_name="الترم الحالي", academic_year="2024", is_current=True)
        db.add(semester)
        db.commit()

        tc = TeacherCourse(teacher_id=teacher_p.teacher_id, course_id=courses[0].course_id, 
                           department_id=depts[0].department_id, semester_id=semester.semester_id)
        db.add(tc)
        db.commit()

        # 6. المجلدات والاختبارات
        folder = Folder(folder_name="مجلد الميدترم", tc_id=tc.tc_id)
        db.add(folder)
        db.commit()

        exam = Exam(exam_title="اختبار البرمجة الأول", number_of_questions=1, total_marks=10, 
                    passing_mark=5, folder_id=folder.folder_id)
        db.add(exam)
        db.commit()

        # 7. الأسئلة والتصحيح (Grading System)
        q = Question(exam_id=exam.exam_id, question_text="ما هو الـ Variable؟", 
                     question_mark=10, question_order=1, question_type="Short Answer")
        db.add(q)
        db.commit()

        expected = ExpectedAnswer(question_id=q.question_id, answer_text="مكان في الذاكرة لتخزين البيانات", is_correct=True)
        db.add(expected)

        sheet = AnswerSheet(exam_id=exam.exam_id, student_id=student_p.student_id, status="Pending")
        db.add(sheet)
        db.commit()

        s_answer = StudentAnswer(sheet_id=sheet.sheet_id, question_id=q.question_id, 
                                 extracted_text="وعاء للبيانات", ai_mark=8, confidence_score=0.9)
        report = Report(sheet_id=sheet.sheet_id, strengths="فهم جيد", academic_description="مستواه ممتاز")
        db.add_all([s_answer, report])

        # 8. السجلات والـ Logs
        log = ActivityLog(user_id=users[0].user_id, action_type="CREATE", action_details="إضافة بيانات تجريبية")
        backup = BackupHistory(admin_id=admin_p.admin_id, file_path="/backups/db.bak", status="Success")
        db.add_all([log, backup])

        db.commit()
        print("🚀 تمت إضافة البيانات لكل الجداول بنجاح!")

    except Exception as e:
        db.rollback()
        print(f"❌ خطأ: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    seed_all_data()