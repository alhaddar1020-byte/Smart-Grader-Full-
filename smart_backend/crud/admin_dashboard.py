from datetime import datetime, timedelta
from sqlalchemy import func, distinct, desc
from sqlalchemy.orm import Session
from models import (
    User, Student, Teacher, Exam, AnswerSheet, 
    BackupHistory, Semester, Folder, TeacherCourse, 
    StudentCourse, ActivityLog, ImportHistory
)
from schemas.admin_dashboard import AdminDashboardResponse, TopStats, PerformanceStats, AlertItem

def get_admin_dashboard_data(db: Session, semester_id: int = 0) -> AdminDashboardResponse:
    
    # 1. تحديد نطاق البيانات (فلترة الترم)
    is_all = (semester_id == 0)
    target_id = semester_id if not is_all else None

    # 2. الإحصائيات العلوية (Top Stats)
    if is_all:
        total_students = db.query(Student).count()
        total_teachers = db.query(Teacher).count()
    else:
        total_students = db.query(func.count(distinct(StudentCourse.student_id))).filter(StudentCourse.semester_id == target_id).scalar() or 0
        total_teachers = db.query(func.count(distinct(TeacherCourse.teacher_id))).filter(TeacherCourse.semester_id == target_id).scalar() or 0

    active_users = db.query(User).filter(User.is_active == True).count()
    
    exam_query = db.query(Exam)
    if not is_all:
        exam_query = exam_query.join(Folder).join(TeacherCourse).filter(TeacherCourse.semester_id == target_id)
    total_exams = exam_query.count()

    # 3. حساب نسب الإنجاز
    sheet_query = db.query(AnswerSheet)
    if not is_all:
        sheet_query = sheet_query.join(Exam).join(Folder).join(TeacherCourse).filter(TeacherCourse.semester_id == target_id)
    
    total_sheets = sheet_query.count()
    graded_sheets = sheet_query.filter(AnswerSheet.status == 'Graded').count()
    overall_progress_pct = round((graded_sheets / total_sheets * 100), 1) if total_sheets > 0 else 0.0
    
    # إرسال مفاتيح (Keys) للواجهة لتقوم بترجمتها
    top_stats = TopStats(
        total_students=total_students,
        students_percentage="KEY_REGISTERED", 
        total_teachers=total_teachers,
        teachers_percentage="KEY_REGISTERED",
        total_exams=total_exams,
        exams_percentage=f"{overall_progress_pct}%_KEY_GRADED", # نرسل النسبة مدمجة مع المفتاح
        active_users=active_users,
        active_users_percentage="KEY_ACTIVE_NOW"
    )

    # 4. إحصائيات الأداء
    avg_score_query = db.query(func.avg((AnswerSheet.total_earned_mark / func.nullif(Exam.total_marks, 0)) * 100)).join(Exam).filter(AnswerSheet.status == 'Graded')
    if not is_all:
        avg_score_query = avg_score_query.join(Folder).join(TeacherCourse).filter(TeacherCourse.semester_id == target_id)
    average_score = round(avg_score_query.scalar() or 0.0, 1)

    passed_query = db.query(AnswerSheet).join(Exam).filter(AnswerSheet.status == 'Graded', AnswerSheet.total_earned_mark >= Exam.passing_mark)
    if not is_all:
        passed_query = passed_query.join(Folder).join(TeacherCourse).filter(TeacherCourse.semester_id == target_id)
    
    passed_count = passed_query.count()
    success_rate = round((passed_count / graded_sheets * 100), 1) if graded_sheets > 0 else 0.0

    performance_stats = PerformanceStats(
        exams_completion_rate=overall_progress_pct,
        success_rate=success_rate,
        average_score=average_score
    )

    # 5. التنبيهات (إرسال مفاتيح ومعطيات خام فقط)
    all_alerts = []
    
    backups = db.query(BackupHistory).order_by(desc(BackupHistory.backup_date)).limit(3).all()
    for b in backups:
        all_alerts.append({
            "timestamp": b.backup_date,
            "item": AlertItem(
                title="KEY_ALERT_BACKUP", 
                subtitle=b.backup_date.strftime('%Y-%m-%d'), # نرسل التاريخ الخام فقط
                time_ago="KEY_RECENTLY", 
                icon_type="backup"
            )
        })
    
    logins = db.query(ActivityLog).filter(ActivityLog.action_type == 'login_success').order_by(desc(ActivityLog.timestamp)).limit(3).all()
    for l in logins:
        all_alerts.append({
            "timestamp": l.timestamp,
            "item": AlertItem(
                title="KEY_ALERT_LOGIN", 
                subtitle=l.timestamp.strftime('%H:%M'), # نرسل الوقت الخام فقط
                time_ago="KEY_RECENTLY", 
                icon_type="security"
            )
        })

    imports = db.query(ImportHistory).order_by(desc(ImportHistory.import_date)).limit(3).all()
    for i in imports:
        all_alerts.append({
            "timestamp": i.import_date,
            "item": AlertItem(
                title="KEY_ALERT_IMPORT", 
                subtitle=f"{i.file_name}|{i.record_count}", # نرسل القيم مفصولة بعلامة |
                time_ago="KEY_RECENTLY", 
                icon_type="import"
            )
        })
    
    all_alerts.sort(key=lambda x: x["timestamp"], reverse=True)
    alerts = [alert["item"] for alert in all_alerts[:4]]

    # 6. الرسم البياني
    today = datetime.now().date()
    seven_days_ago = today - timedelta(days=6)
    
    chart_data_query = db.query(func.date(Exam.exam_date), func.count(Exam.exam_id))\
        .filter(func.date(Exam.exam_date) >= seven_days_ago)\
        .group_by(func.date(Exam.exam_date)).all()
    
    counts_by_date = {str(row[0]): float(row[1]) for row in chart_data_query}
    
    chart_data = []
    for i in range(6, -1, -1):
        day_str = str(today - timedelta(days=i))
        chart_data.append(counts_by_date.get(day_str, 0.0))

    return AdminDashboardResponse(
        top_stats=top_stats,
        performance_stats=performance_stats,
        alerts=alerts,
        system_usage_chart=chart_data
    )