# routers/admin.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from schemas.admin_dashboard import AdminDashboardResponse
from crud import dashboard as crud_dashboard

router = APIRouter(
    prefix="/admin",
    tags=["Admin Dashboard"]
)

@router.get("/dashboard-stats", response_model=AdminDashboardResponse)
def get_dashboard_statistics(db: Session = Depends(get_db)):
    """
    جلب جميع إحصائيات لوحة تحكم الإدارة (العلوي، السفلي، والتنبيهات)
    """
    # بكل بساطة ونظافة: استدعي دالة الـ CRUD ورجع البيانات!
    return crud_dashboard.get_admin_dashboard_data(db)