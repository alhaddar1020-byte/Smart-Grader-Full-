from models.exams import Semester
from sqlalchemy.orm import Session
from models.exams import Exam
from datetime import date


def get_target_semester_id(db: Session, requested_id: int = None):
    # 1. إذا طلب المدير "الكل" (0)، نرجع None لتعطيل الفلترة
    if requested_id == 0:
        return None
    # 2. إذا طلب المدير ترم محدد، نرجعه هو نفسه
    if requested_id is not None and requested_id > 0:
        return requested_id
    # 3. إذا لم يُرسل أي ID (حالة الأستاذ/الطالب أو بداية دخول المدير)، نأخذ النشط تلقائياً
    active = db.query(Semester).filter(Semester.is_current == True).first()
    return active.semester_id if active else None
