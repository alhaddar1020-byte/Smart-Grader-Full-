from sqlalchemy.orm import Session
from sqlalchemy import func, or_, cast, Date, text
from models.settings import ActivityLog
from models.users import User, Role
from models.associations import user_roles
from datetime import date, datetime
from typing import Optional
import io
import csv


def get_logs_summary(db: Session, active_term: bool = False) -> dict:
    """إحصائيات سريعة للسجل"""
    query_actions = db.query(ActivityLog)
    query_logins = db.query(ActivityLog).filter(
        or_(
            ActivityLog.action_type.ilike('%تسجيل دخول%'),
            ActivityLog.action_type.ilike('%Login%')
        )
    )
    query_today = db.query(ActivityLog).filter(cast(ActivityLog.timestamp, Date) == date.today())
    
    if active_term:
        from crud.settings import get_active_semester_id
        active_semester_id = get_active_semester_id(db)
        if active_semester_id:
            query_actions = query_actions.filter(ActivityLog.semester_id == active_semester_id)
            query_logins = query_logins.filter(ActivityLog.semester_id == active_semester_id)
            query_today = query_today.filter(ActivityLog.semester_id == active_semester_id)

    total_actions = query_actions.count()
    login_records = query_logins.count()
    today_count = query_today.count()

    return {
        "total_actions": total_actions,
        "login_records": login_records,
        "today_count": today_count
    }


def get_logs(
    db: Session,
    search: Optional[str] = None,
    role: Optional[str] = None,
    selected_date: Optional[str] = None,
    skip: int = 0,
    limit: int = 50,
    active_term: bool = False
) -> dict:
    """جلب السجلات مع الفلاتر"""

    from sqlalchemy import table, column
    vw_system_logs = table(
        "vw_system_logs",
        column("log_id"),
        column("user_name"),
        column("user_role"),
        column("action_taken"),
        column("ip_address"),
        column("action_date_time"),
        column("semester_id")
    )

    # البناء الأساسي للاستعلام من الـ View مباشرة
    query = db.query(
        vw_system_logs.c.log_id,
        vw_system_logs.c.user_name,
        vw_system_logs.c.user_role,
        vw_system_logs.c.action_taken,
        vw_system_logs.c.ip_address,
        vw_system_logs.c.action_date_time
    ).select_from(vw_system_logs)

    # فلتر البحث بالاسم
    if search and search.strip():
        query = query.filter(
            vw_system_logs.c.user_name.ilike(f"%{search.strip()}%")
        )

    # فلتر الدور
    if role and role.upper() not in ["ALL", "الكل", ""]:
        query = query.filter(
            func.upper(vw_system_logs.c.user_role) == role.upper()
        )

    # فلتر التاريخ
    if selected_date and selected_date.strip():
        try:
            parsed_date = datetime.strptime(selected_date.strip(), "%Y-%m-%d").date()
            query = query.filter(
                cast(vw_system_logs.c.action_date_time, Date) == parsed_date
            )
        except ValueError:
            pass

    # فلتر الترم النشط
    if active_term:
        from crud.settings import get_active_semester_id
        active_semester_id = get_active_semester_id(db)
        if active_semester_id:
            query = query.filter(vw_system_logs.c.semester_id == active_semester_id)

    total_count = query.count()

    logs_raw = query.order_by(
        vw_system_logs.c.action_date_time.desc()
    ).offset(skip).limit(limit).all()

    logs = []
    for row in logs_raw:
        logs.append({
            "log_id": row.log_id,
            "user_name": row.user_name or "مجهول",
            "user_role": row.user_role or "غير محدد",
            "action_taken": row.action_taken or "",
            "ip_address": row.ip_address or "-",
            "action_date_time": row.action_date_time
        })

    return {
        "total_count": total_count,
        "logs": logs
    }


def export_logs_csv(
    db: Session,
    search: Optional[str] = None,
    role: Optional[str] = None,
    selected_date: Optional[str] = None,
    active_term: bool = False
) -> bytes:
    """تصدير السجلات كـ CSV مع دعم العربية"""

    # جلب كل السجلات بدون limit للتصدير
    result = get_logs(
        db=db,
        search=search,
        role=role,
        selected_date=selected_date,
        skip=0,
        limit=100000,
        active_term=active_term
    )

    output = io.StringIO()
    # BOM لدعم العربية في Excel
    output.write('\ufeff')

    writer = csv.writer(output, lineterminator='\n')

    # العناوين
    writer.writerow([
        "اسم المستخدم",
        "الدور",
        "الإجراء",
        "التاريخ والوقت",
        "عنوان IP"
    ])

    # البيانات
    for log in result["logs"]:
        dt = log["action_date_time"]
        if isinstance(dt, datetime):
            formatted_dt = dt.strftime("%Y-%m-%d | %I:%M %p")
        else:
            formatted_dt = str(dt)

        writer.writerow([
            log["user_name"],
            log["user_role"],
            log["action_taken"],
            formatted_dt,
            log["ip_address"]
        ])

    return output.getvalue().encode("utf-8-sig")