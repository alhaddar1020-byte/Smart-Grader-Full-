from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session
from typing import List

from db.database import get_db 
from schemas.admin_dashboard import AdminDashboardResponse
from crud.admin_dashboard import get_admin_dashboard_data
from models import Semester

router = APIRouter(
    prefix="/admin",
    tags=["Admin Dashboard"]
)

@router.get("/dashboard-stats", response_model=AdminDashboardResponse)
def get_dashboard_stats(semester_id: int = Query(0), db: Session = Depends(get_db)):
    """جلب إحصائيات لوحة التحكم بناءً على الترم المختار"""
    try:
        return get_admin_dashboard_data(db=db, semester_id=semester_id)
    except Exception as e:
        raise HTTPException(status_code=500, detail="error_loading_stats")

@router.get("/dashboard-filters")
def get_dashboard_filters(db: Session = Depends(get_db)):
    """مسار يجلب السنوات والفصول للوحة التحكم"""
    try:
        years_raw = db.query(Semester.academic_year).distinct().all()
        semesters_raw = db.query(Semester).all()
        
        return {
            "years": [str(y[0]) for y in years_raw if y[0]],
            "semesters": [
                {
                    "id": str(s.semester_id),
                    "name": str(s.semester_name), 
                    "year": str(s.academic_year)
                } 
                for s in semesters_raw
            ]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail="error_fetch_filters")