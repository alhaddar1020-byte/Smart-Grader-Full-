# from fastapi import Depends
# from core.security import get_current_user_id
# # ==========================================
# # هذا الملف هو "الأهم" للواجهات، لأنه يقرأ مباشرة من الفيوهات (Views) 
# # التي تعبنا في برمجتها في Supabase (مثل vw_StudentResults و vw_TeacherSubjects)
# # ==========================================

# from fastapi import APIRouter, Depends
# from sqlalchemy import text
# from sqlalchemy.orm import Session
# from db.database import get_db

# # 🌟 استدعاء دوال الطالب من ملف العمليات (CRUD)
# from crud.student_dashbord import (
#     get_student_dashboard_data, 
#     get_student_subjects_data, 
#     get_subject_details_data, 
#     get_exam_details_data
# )

# router = APIRouter(prefix="/views", tags=["Data Views (عرض البيانات جاهزة)"], dependencies=[Depends(get_current_user_id)])

# # --------------------------------------------------------------------------
# # القسم الأول: استعلامات الفيوهات المباشرة (Raw SQL Views)
# # --------------------------------------------------------------------------

# @router.get("/teacher-subjects/{teacher_id}")
# def get_teacher_subjects(teacher_id: int, db: Session = Depends(get_db)):
#     """ جلب المواد المرتبطة بالمعلم من الفيو المباشر """
#     query = text("SELECT * FROM vw_TeacherSubjects WHERE teacher_id = :tid")
#     result = db.execute(query, {"tid": teacher_id})
#     return [dict(row._mapping) for row in result]

# @router.get("/student-results/{student_id}")
# def get_student_results(student_id: int, db: Session = Depends(get_db)):
#     """ جلب نتائج الطالب من الفيو المباشر """
#     query = text("SELECT * FROM vw_StudentResults WHERE student_id = :sid")
#     result = db.execute(query, {"sid": student_id})
#     return [dict(row._mapping) for row in result]


# # --------------------------------------------------------------------------
# # القسم الثاني: شاشات تطبيق الطالب (Student App Endpoints)
# # --------------------------------------------------------------------------

# # 1. صفحة الداش بورد (الرئيسية)
# # @router.get("/student-dashboard/{student_id}")
# # def get_student_dashboard(student_id: int, db: Session = Depends(get_db)):
# #     """
# #     هذا الرابط يرسل بيانات لوحة تحكم الطالب جاهزة ومنسقة لتطبيق الفلاتر
# #     """
# #     # التمرير الصريح يحميك من أخطاء الترتيب
# #     return get_student_dashboard_data(db=db, student_id=student_id)


# # # 2. صفحة المواد الدراسية
# # @router.get("/student-subjects/{student_id}")
# # def get_student_subjects(student_id: int, db: Session = Depends(get_db)):
# #     """
# #     هذا الرابط يرسل بيانات شاشة المواد الدراسية للطالب
# #     """
# #     return get_student_subjects_data(db=db, student_id=student_id)


# # # 3. صفحة تفاصيل المادة
# # @router.get("/subject-details/{student_id}/{course_name}")
# # def get_subject_details(student_id: int, course_name: str, db: Session = Depends(get_db)):
# #     """
# #     هذا الرابط يرسل تفاصيل مادة معينة واختباراتها للطالب
# #     """
# #     return get_subject_details_data(db=db, student_id=student_id, course_name=course_name)


# # # 4. صفحة تفاصيل ورقة الاختبار (التصحيح التفصيلي)
# # @router.get("/exam-details/{student_id}/{exam_title}")
# # def get_exam_details(student_id: int, exam_title: str, db: Session = Depends(get_db)):
# #     """
# #     هذا الرابط يرسل بيانات تصحيح اختبار معين تفصيلياً لعرضها للطالب
# #     """
# #     return get_exam_details_data(db=db, student_id=student_id, exam_title=exam_title)

# @router.get("/student-dashboard/{student_id}")
# def get_student_dashboard(student_id: int, db: Session = Depends(get_db)):
#     return get_student_dashboard_data(db=db, student_id=student_id)

# @router.get("/student-subjects/{student_id}")
# def get_student_subjects(student_id: int, db: Session = Depends(get_db)):
#     return get_student_subjects_data(db=db, student_id=student_id)

# @router.get("/subject-details/{student_id}/{course_name}")
# def get_subject_details(student_id: int, course_name: str, db: Session = Depends(get_db)):
#     return get_subject_details_data(db=db, student_id=student_id, course_name=course_name)

# @router.get("/exam-details/{student_id}/{exam_title}")
# def get_exam_details(student_id: int, exam_title: str, db: Session = Depends(get_db)):
#     return get_exam_details_data(db=db, student_id=student_id, exam_title=exam_title)


# ==========================================
# هذا الملف هو "الأهم" للواجهات، لأنه يقرأ مباشرة من الفيوهات (Views) 
# التي تعبنا في برمجتها في Supabase (مثل vw_StudentResults و vw_TeacherSubjects)
# ==========================================

from fastapi import APIRouter, Depends
from sqlalchemy import text
from sqlalchemy.orm import Session
from db.database import get_db

# 🌟 استدعاء دوال الطالب من ملف العمليات (CRUD)
from crud.student_dashbord import (
    get_student_dashboard_data, 
    get_student_subjects_data, 
    get_subject_details_data, 
    get_exam_details_data,
    mark_result_as_read_data
)

router = APIRouter(prefix="/views", tags=["Data Views (عرض البيانات جاهزة)"])

# --------------------------------------------------------------------------
# القسم الأول: استعلامات الفيوهات المباشرة (Raw SQL Views)
# --------------------------------------------------------------------------

@router.get("/teacher-subjects/{teacher_id}")
def get_teacher_subjects(teacher_id: int, db: Session = Depends(get_db)):
    """ جلب المواد المرتبطة بالمعلم من الفيو المباشر """
    query = text("SELECT * FROM vw_TeacherSubjects WHERE teacher_id = :tid")
    result = db.execute(query, {"tid": teacher_id})
    return [dict(row._mapping) for row in result]

@router.get("/student-results/{student_id}")
def get_student_results(student_id: int, db: Session = Depends(get_db)):
    """ جلب نتائج الطالب من الفيو المباشر """
    query = text("SELECT * FROM vw_StudentResults WHERE student_id = :sid")
    result = db.execute(query, {"sid": student_id})
    return [dict(row._mapping) for row in result]


# --------------------------------------------------------------------------
# القسم الثاني: شاشات تطبيق الطالب (Student App Endpoints)
# --------------------------------------------------------------------------

# 1. صفحة الداش بورد (الرئيسية)
@router.get("/student-dashboard/{student_id}")
def get_student_dashboard(student_id: int, db: Session = Depends(get_db)):
    """
    هذا الرابط يرسل بيانات لوحة تحكم الطالب جاهزة ومنسقة لتطبيق الفلاتر
    """
    # التمرير الصريح يحميك من أخطاء الترتيب
    return get_student_dashboard_data(db=db, student_id=student_id)


# 2. صفحة المواد الدراسية
@router.get("/student-subjects/{student_id}")
def get_student_subjects(student_id: int, db: Session = Depends(get_db)):
    """
    هذا الرابط يرسل بيانات شاشة المواد الدراسية للطالب
    """
    return get_student_subjects_data(db=db, student_id=student_id)


# 3. صفحة تفاصيل المادة
@router.get("/subject-details/{student_id}/{course_name}")
def get_subject_details(student_id: int, course_name: str, db: Session = Depends(get_db)):
    """
    هذا الرابط يرسل تفاصيل مادة معينة واختباراتها للطالب
    """
    return get_subject_details_data(db=db, student_id=student_id, course_name=course_name)


# 4. صفحة تفاصيل ورقة الاختبار (التصحيح التفصيلي)
# 🌟 التعديل: تغيير exam_title إلى exam_id
@router.get("/exam-details/{student_id}/{exam_id}")
def get_exam_details(student_id: int, exam_id: int, db: Session = Depends(get_db)):
    # 🌟 التعديل: إرسال exam_id للدالة الأساسية
    return get_exam_details_data(db=db, student_id=student_id, exam_id=exam_id)


# 5. تحديث حالة النتيجة إلى مقروءة (لإخفاء النقطة الزرقاء)
@router.put("/mark-result-read/{student_id}/{exam_id}")
def mark_result_as_read(student_id: int, exam_id: int, db: Session = Depends(get_db)):
    """
    هذا الرابط يستقبل طلب فلاتر لمسح النقطة الزرقاء ويوجهه للـ CRUD
    """
    # ⚠️ تأكدي إنك مسوية استدعاء (import) لدالة mark_result_as_read_data في أعلى ملف views.py
    return mark_result_as_read_data(db=db, student_id=student_id, exam_id=exam_id)