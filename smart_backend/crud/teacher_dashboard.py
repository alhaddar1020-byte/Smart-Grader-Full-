from sqlalchemy.orm import Session

def get_teacher_dashboard_stats(db: Session, teacher_id: int):
    """
    دالة مؤقتة لجلب إحصائيات المعلم لتشغيل السيرفر.
    يمكنك استبدالها بكود زميلتك لاحقاً.
    """
    return {
        "total_students": 120,       # رقم تجريبي لعدد الطلاب
        "corrected_papers": 45,      # رقم تجريبي للأوراق المصححة
        "created_exams": 10,         # رقم تجريبي للاختبارات
        "drafts": 2                  # رقم تجريبي للمسودات
    }