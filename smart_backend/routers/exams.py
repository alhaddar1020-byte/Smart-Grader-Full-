from fastapi import Depends
from core.security import get_current_user_id
# from fastapi import APIRouter, Depends, HTTPException
# from sqlalchemy.orm import Session
# from db.database import get_db
# from schemas.exams import ExamCreate
# from crud.exams import create_exam

# # إنشاء الـ Router وتسمية الرابط
# router = APIRouter(prefix="/exams", tags=["Exams (الاختبارات)"], dependencies=[Depends(get_current_user_id)])

# @router.post("/create")
# def create_new_exam(exam: ExamCreate, db: Session = Depends(get_db)):
#     """
#     هذا الرابط يستقبل بيانات الاختبار من الفلاتر، ويحفظها في قاعدة البيانات.
#     """
#     try:
#         # إرسال البيانات لدالة الـ CRUD اللي كتبناها سابقاً
#         exam_id = create_exam(
#             db=db,
#             folder_id=exam.folder_id,
#             title=exam.exam_title,
#             num_questions=exam.number_of_questions,
#             total_marks=exam.total_marks,
#             passing_mark=exam.passing_mark,
#             allowed_time=exam.allowed_time
#         )
#         # نرجع الـ ID حق الاختبار الجديد للتطبيق
#         return {"message": "تم إنشاء الاختبار بنجاح", "exam_id": exam_id}
    
#     except Exception as e:
#         raise HTTPException(status_code=400, detail=f"حدث خطأ أثناء الإنشاء: {str(e)}")

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from db.database import get_db
from schemas.exams import ExamCreate
from crud.exams import create_exam
from crud.utils import get_target_semester_id # الدالة المساعدة التي اقترحناها

router = APIRouter(prefix="/exams", tags=["Exams (الاختبارات)"], dependencies=[Depends(get_current_user_id)])

@router.post("/create")
def create_new_exam(exam: ExamCreate, semester_id: int = Query(None), db: Session = Depends(get_db)):
    """
    إنشاء اختبار جديد:
    - إذا أرسل فلاتر semester_id (المدير اختار ترم معين)، سيتم الحفظ فيه.
    - إذا لم يرسل (المعلم أضاف اختبار)، سيتم جلب الترم 'النشط' تلقائياً.
    """
    try:
        # تحديد الترم المستهدف للحفظ
        target_semester = get_target_semester_id(db, semester_id)
        
        exam_id = create_exam(
            db=db,
            folder_id=exam.folder_id,
            title=exam.exam_title,
            num_questions=exam.number_of_questions,
            total_marks=exam.total_marks,
            passing_mark=exam.passing_mark,
            allowed_time=exam.allowed_time,
            semester_id=target_semester # تمرير الترم للدالة
        )
        return {"message": "تم إنشاء الاختبار بنجاح", "exam_id": exam_id}
    
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"حدث خطأ أثناء الإنشاء: {str(e)}")