from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db.database import get_db

# هنا نستدعي الملفين اللي تونا سويناهم!
from schemas.teacher_dashboard import DashboardStats
from crud.teacher_dashboard import get_teacher_dashboard_stats

# إنشاء الرابط (الجسر)
router = APIRouter(
    prefix="/teacher-dashboard",
    tags=["Teacher Dashboard"]
)

@router.get("/{teacher_id}", response_model=DashboardStats)
def get_dashboard_data(teacher_id: int, db: Session = Depends(get_db)):
    # هنا نرسل الطلب لملف الـ CRUD عشان يطبخ لنا البيانات
    stats = get_teacher_dashboard_stats(db, teacher_id)
    
    if not stats:
        # لو المعلم غير موجود نرجع هذا الخطأ للتطبيق
        raise HTTPException(status_code=404, detail="المعلم غير موجود في قاعدة البيانات")
        
    return stats