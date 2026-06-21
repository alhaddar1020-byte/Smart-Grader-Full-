from sqlalchemy.orm import Session
from sqlalchemy import func, case, Integer
from models.users import User
from models.profiles import Student, Teacher, Course
from models.exams import Exam, TeacherCourse, Folder
from models.grading import AnswerSheet
from models.academic import StudentCourse

def get_reports_data(db: Session, active_term: bool = False) -> dict:

    active_semester_id = None
    if active_term:
        from crud.settings import get_active_semester_id
        active_semester_id = get_active_semester_id(db)

    # 1. إجمالي الطلاب
    q_students = db.query(Student)
    if active_semester_id:
        q_students = q_students.join(StudentCourse, Student.student_id == StudentCourse.student_id).filter(StudentCourse.semester_id == active_semester_id)
    total_students = q_students.count()

    # 2. المعلمين النشطين
    q_teachers = db.query(Teacher).join(User, Teacher.user_id == User.user_id).filter(User.is_active == True)
    if active_semester_id:
        q_teachers = q_teachers.join(TeacherCourse, Teacher.teacher_id == TeacherCourse.teacher_id).filter(TeacherCourse.semester_id == active_semester_id)
    active_teachers = q_teachers.distinct().count()

    # 3. متوسط الدرجات العام
    q_avg = db.query(func.avg((AnswerSheet.total_earned_mark / Exam.total_marks) * 100)).join(Exam).filter(AnswerSheet.status == 'Graded')
    if active_semester_id:
        q_avg = q_avg.join(Folder, Exam.folder_id == Folder.folder_id).join(TeacherCourse, Folder.tc_id == TeacherCourse.tc_id).filter(TeacherCourse.semester_id == active_semester_id)
    avg_result = q_avg.scalar()
    general_average = round(float(avg_result or 0.0), 1)

    # 4. نسب النجاح والرسوب
    q_total_graded = db.query(AnswerSheet).filter(AnswerSheet.status == 'Graded')
    if active_semester_id:
        q_total_graded = q_total_graded.join(Exam).join(Folder, Exam.folder_id == Folder.folder_id).join(TeacherCourse, Folder.tc_id == TeacherCourse.tc_id).filter(TeacherCourse.semester_id == active_semester_id)
    total_graded = q_total_graded.count()

    q_passed = db.query(AnswerSheet).join(Exam).filter(AnswerSheet.status == 'Graded', AnswerSheet.total_earned_mark >= Exam.passing_mark)
    if active_semester_id:
        q_passed = q_passed.join(Folder, Exam.folder_id == Folder.folder_id).join(TeacherCourse, Folder.tc_id == TeacherCourse.tc_id).filter(TeacherCourse.semester_id == active_semester_id)
    passed = q_passed.count()

    pass_pct = round((passed / total_graded * 100), 1) if total_graded > 0 else 0.0
    fail_pct = round(100 - pass_pct, 1)

    # 5. أداء المواد
    q_courses = db.query(
        TeacherCourse.course_id,
        func.count(AnswerSheet.sheet_id).label('total'),
        func.sum(case((AnswerSheet.total_earned_mark >= Exam.passing_mark, 1), else_=0)).label('passed')
    ).join(Folder, TeacherCourse.tc_id == Folder.tc_id)\
     .join(Exam, Folder.folder_id == Exam.folder_id)\
     .join(AnswerSheet, Exam.exam_id == AnswerSheet.exam_id)\
     .filter(AnswerSheet.status == 'Graded')

    if active_semester_id:
        q_courses = q_courses.filter(TeacherCourse.semester_id == active_semester_id)
    
    courses_data = q_courses.group_by(TeacherCourse.course_id).all()

    subjects_performance = []
    for row in courses_data:
        course = db.query(Course).filter(Course.course_id == row.course_id).first()
        if course and row.total > 0:
            s_rate = round((row.passed / row.total) * 100, 1)
            subjects_performance.append({
                "subject_name": course.course_name,
                "success_rate": s_rate,
                "fail_rate": round(100 - s_rate, 1)
            })

    # 6. استخدام النظام
    q_teacher_stats = db.query(
        Teacher.teacher_id,
        func.count(Exam.exam_id).label('exam_count')
    ).join(TeacherCourse, Teacher.teacher_id == TeacherCourse.teacher_id)\
     .join(Folder, TeacherCourse.tc_id == Folder.tc_id)\
     .join(Exam, Folder.folder_id == Exam.folder_id)

    if active_semester_id:
        q_teacher_stats = q_teacher_stats.filter(TeacherCourse.semester_id == active_semester_id)
    
    teacher_stats = q_teacher_stats.group_by(Teacher.teacher_id)\
     .order_by(func.count(Exam.exam_id).desc())\
     .limit(5).all()

    max_count = teacher_stats[0].exam_count if teacher_stats else 1
    teachers_usage = []
    for i, row in enumerate(teacher_stats):
        teacher_user = db.query(User).join(Teacher, User.user_id == Teacher.user_id).filter(Teacher.teacher_id == row.teacher_id).first()
        teachers_usage.append({
            "rank": i + 1,
            "teacher_name": teacher_user.full_name if teacher_user else "غير معروف",
            "tasks_count": row.exam_count,
            "progress": round(row.exam_count / max_count, 2)
        })

    return {
        "summary": {
            "total_students": total_students,
            "general_average": general_average,
            "active_teachers": active_teachers,
            "pass_percentage": pass_pct,
            "fail_percentage": fail_pct
        },
        "subjects_performance": subjects_performance,
        "teachers_usage": teachers_usage
    }