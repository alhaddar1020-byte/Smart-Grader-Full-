from fastapi import Depends
from core.security import get_current_user_id
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from db.database import get_db  # تأكدي من مسار الاتصال بقاعدة البيانات
from crud import exams_crud
from schemas import exams as exams_schema
from models.exams import Semester

# أنشأنا الراوتر بـ prefix يشمل كل العمليات الأكاديمية
router = APIRouter(prefix="/academic", tags=["Academic & Exams Management"], dependencies=[Depends(get_current_user_id)])

# ==========================================
# 1. مسارات الأترام الدراسية (Semesters)
# ==========================================
@router.get("/semesters", response_model=List[exams_schema.SemesterResponse])
def get_all_semesters(db: Session = Depends(get_db)):
    """جلب قائمة بجميع الأترام الدراسية"""
    return exams_crud.get_all_semesters(db)

@router.post("/semesters", response_model=exams_schema.SemesterResponse)
def create_new_semester(semester_data: exams_schema.SemesterCreate, db: Session = Depends(get_db)):
    """إضافة ترم دراسي جديد"""
    try:
        return exams_crud.create_semester(db=db, semester_data=semester_data)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"حدث خطأ أثناء إضافة الترم: {str(e)}")

@router.put("/semesters/{semester_id}/toggle-current")
def toggle_semester_status(semester_id: int, db: Session = Depends(get_db)):
    """تفعيل ترم محدد كترم نشط (وإلغاء الباقي)"""
    result = exams_crud.set_current_semester(db=db, semester_id=semester_id)
    if not result:
        raise HTTPException(status_code=404, detail="الفصل غير موجود في قاعدة البيانات")
    return {"message": "تم تحديث الترم الحالي بنجاح"}

@router.delete("/semesters/{semester_id}")
def delete_semester_endpoint(semester_id: int, db: Session = Depends(get_db)):
    """مسار حذف ترم دراسي"""
    result = exams_crud.delete_semester(db=db, semester_id=semester_id)
    if not result:
        raise HTTPException(status_code=404, detail="الفصل غير موجود في قاعدة البيانات")
    return {"message": "تم الحذف بنجاح"}

@router.put("/semesters/{semester_id}", response_model=exams_schema.SemesterResponse)
def edit_semester(semester_id: int, semester_data: exams_schema.SemesterCreate, db: Session = Depends(get_db)):
    """مسار تعديل بيانات الفصل الدراسي"""
    updated_semester = exams_crud.update_semester(db=db, semester_id=semester_id, semester_data=semester_data)
    if not updated_semester:
        raise HTTPException(status_code=404, detail="الفصل غير موجود في قاعدة البيانات")
    return updated_semester

@router.get("/dashboard-filters")
def get_dashboard_filters(db: Session = Depends(get_db)):
    """مسار مخصص لجلب السنوات والفصول للوحة تحكم المدير"""
    try:
        # جلب السنوات الفريدة
        years_raw = db.query(Semester.academic_year).distinct().order_by(Semester.academic_year.desc()).all()
        # جلب كل الفصول
        semesters_raw = db.query(Semester).all()
        
        return {
            "years": [str(y[0]) for y in years_raw if y[0]], # تحويلها لنصوص لضمان عدم تعليق فلاتر
            "semesters": [
                {"id": s.semester_id, "name": s.semester_name, "year": str(s.academic_year), "is_current": s.is_current} 
                for s in semesters_raw
            ]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ==========================================
# 2. مسارات التكاليف الأكاديمية (Teacher Courses)
# ==========================================
@router.get("/teacher-courses/{teacher_id}/{semester_id}", response_model=List[exams_schema.TeacherCourseResponse])
def get_courses_for_teacher(teacher_id: int, semester_id: int, db: Session = Depends(get_db)):
    """جلب المواد المسندة لمعلم محدد في ترم محدد"""
    return exams_crud.get_teacher_courses(db=db, teacher_id=teacher_id, semester_id=semester_id)

@router.post("/teacher-courses", response_model=exams_schema.TeacherCourseResponse)
def assign_course_to_teacher(tc_data: exams_schema.TeacherCourseCreate, db: Session = Depends(get_db)):
    """إسناد مادة لمعلم (إنشاء تكليف)"""
    try:
        return exams_crud.assign_teacher_to_course(db=db, tc_data=tc_data)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"حدث خطأ أثناء إسناد المادة: {str(e)}")


# ==========================================
# 3. مسارات المجلدات التنظيمية (Folders)
# ==========================================
@router.get("/folders/{tc_id}", response_model=List[exams_schema.FolderResponse])
def get_folders_for_course(tc_id: int, db: Session = Depends(get_db)):
    """جلب المجلدات الخاصة بتكليف/مادة معينة"""
    return exams_crud.get_folders_by_tc(db=db, tc_id=tc_id)

@router.post("/folders", response_model=exams_schema.FolderResponse)
def create_new_folder(folder_data: exams_schema.FolderCreate, db: Session = Depends(get_db)):
    """إنشاء مجلد جديد لتنظيم الاختبارات"""
    try:
        return exams_crud.create_folder(db=db, folder_data=folder_data)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"حدث خطأ أثناء إنشاء المجلد: {str(e)}")


# ==========================================
# 4. مسارات الاختبارات (Exams)
# ==========================================
@router.get("/folders/{folder_id}/exams", response_model=List[exams_schema.ExamResponse])
def get_exams_in_folder(folder_id: int, db: Session = Depends(get_db)):
    """جلب جميع الاختبارات داخل مجلد محدد"""
    return exams_crud.get_exams_by_folder(db=db, folder_id=folder_id)

@router.post("/exams", response_model=exams_schema.ExamResponse)
def create_new_exam(exam_data: exams_schema.ExamCreate, db: Session = Depends(get_db)):
    """إنشاء إعدادات اختبار جديد"""
    try:
        return exams_crud.create_exam(db=db, exam_data=exam_data)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"حدث خطأ أثناء حفظ إعدادات الاختبار: {str(e)}")