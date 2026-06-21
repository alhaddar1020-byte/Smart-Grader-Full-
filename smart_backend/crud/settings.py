# مسار الملف: crud/settings.py

from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import Dict, Any
from models.exams import Semester

def get_active_semester_id(db: Session) -> int | None:
    active_semester = db.query(Semester).filter(Semester.is_current == True).first()
    return active_semester.semester_id if active_semester else None

def get_user_profile_data(db: Session, user_id: int) -> dict | None:
    """
    دالة متخصصة لجلب بيانات الملف الشخصي للمستخدم (أدمن، معلم، أو طالب)
    """
    query = text("""
        SELECT u.user_id, u.full_name, u.email, u.phone_number, 
               l.level_name, d.department_name, u.language_code, u.is_dark_mode,
               CAST(u.last_password_change AS TEXT) AS last_password_change
        FROM users u
        LEFT JOIN student s ON u.user_id = s.user_id
        LEFT JOIN level l ON s.level_id = l.level_id
        LEFT JOIN department d ON s.department_id = d.department_id
        WHERE u.user_id = :uid
    """)
    
    result = db.execute(query, {"uid": user_id}).mappings().first()
    return dict(result) if result else None