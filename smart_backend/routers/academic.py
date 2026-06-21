from fastapi import Depends
from core.security import get_current_user_id
# هذا الملف يسحب البيانات من جداول department, level, courses و semesters
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List

from db.database import get_db
from models.academic import Department, Level
from models.profiles import Course
from models.exams import Semester

router = APIRouter(prefix="/academic", tags=["Academic (البيانات الأكاديمية)"], dependencies=[Depends(get_current_user_id)])

@router.get("/departments")
def get_all_departments(db: Session = Depends(get_db)):
    return db.query(Department).all()

@router.get("/levels")
def get_all_levels(db: Session = Depends(get_db)):
    return db.query(Level).all()

@router.get("/courses/{level_id}")
def get_courses_by_level(level_id: int, db: Session = Depends(get_db)):
    return db.query(Course).filter(Course.level_id == level_id).all()

@router.get("/dashboard-filters")
def get_dashboard_filters(db: Session = Depends(get_db)):
    # جلب السنوات الفريدة مرتبة تنازلياً
    years_raw = db.query(Semester.academic_year).distinct().order_by(Semester.academic_year.desc()).all()
    # جلب كل الفصول
    semesters_raw = db.query(Semester).all()
    
    return {
        "years": [y[0] for y in years_raw],
        "semesters": [
            {
                "id": s.semester_id, 
                "name": s.semester_name, 
                "year": s.academic_year, 
                "is_current": s.is_current
            } 
            for s in semesters_raw
        ]
    }