from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from db.database import get_db

# 1. استدعاء الموديلات الأساسية
from models.exams import Exam
from models.grading import QuestionGroup, QuestionSection, Question, ExpectedAnswer

# 2. استدعاء الفيو (View) اللي سوته صاحبتك عشان نجيب الأسماء الحقيقية
from models.view import VwTeacherExamsList

# 3. استدعاء سكيما ودالة الإنشاء القديمة (خليناها عشان ما ينكسر أي شيء من شغل صاحبتك)
from schemas.exams import ExamCreate 
from crud.exams import create_exam

# إنشاء الـ Router بنفس الرابط الأساسي
router = APIRouter(prefix="/exams", tags=["Exams (إدارة الاختبارات)"])

# ============================================================
# 1. إنشاء اختبار (الكود القديم حق صاحبتك)
# ============================================================
@router.post("/create")
def create_new_exam(exam: ExamCreate, db: Session = Depends(get_db)):
    try:
        exam_id = create_exam(
            db=db,
            folder_id=exam.folder_id,
            title=exam.exam_title,
            num_questions=exam.number_of_questions,
            total_marks=exam.total_marks,
            passing_mark=exam.passing_mark,
            allowed_time=exam.allowed_time
        )
        return {"message": "تم إنشاء الاختبار بنجاح", "exam_id": exam_id}
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"حدث خطأ أثناء الإنشاء: {str(e)}")

# ============================================================
# 2. جلب قائمة الاختبارات (احترافي باستخدام الـ View)
# ============================================================
@router.get("/list", summary="جلب قائمة الاختبارات حسب الحالة")
def get_exams_list(
    teacher_id: int,
    status: str = Query(..., description="Manual, AI, or Draft"),
    db: Session = Depends(get_db)
):
    from models.exams import Folder, TeacherCourse
    from models.profiles import Course

    query = db.query(
        Exam.exam_id,
        Exam.exam_title,
        Exam.exam_date,
        Exam.number_of_questions,
        Exam.status,
        Exam.exam_type,
        Course.course_name
    ).select_from(Exam).join(
        Folder, Exam.folder_id == Folder.folder_id
    ).join(
        TeacherCourse, Folder.tc_id == TeacherCourse.tc_id
    ).join(
        Course, TeacherCourse.course_id == Course.course_id
    ).filter(
        TeacherCourse.teacher_id == teacher_id
    )

    req_status = status.strip().lower()
    
    if req_status == "manual":
        query = query.filter(Exam.status == "Published", Exam.exam_type == "manual")
    elif req_status == "ai":
        query = query.filter(Exam.status == "Published", Exam.exam_type == "ai")
    elif req_status == "draft":
        query = query.filter(Exam.status == "Draft")

    # 🌟 التعديل السحري هنا: 
    # 1. ترتيب تنازلي حسب التاريخ (الأحدث أولاً)
    # 2. nulls_last() عشان الاختبارات اللي بدون تاريخ ما تخرب الترتيب وتطلع فوق
    # 3. ترتيب ثانوي بالـ exam_id عشان لو فيه اختبارين بنفس اليوم يترتبون صح
     # الترتيب سيعتمد على (أحدث ما تم العمل عليه سواء إنشاء أو تعديل)
# وإذا تساوى الوقت (أو كان قديماً)، نرتب برقم الاختبار كاحتياط
    results = query.order_by(Exam.updated.desc().nulls_last(), Exam.exam_id.desc()).all()    
    exams_list = []
    for r in results:
        exams_list.append({
            "exam_id": r.exam_id,
            "exam_title": r.exam_title or "بدون عنوان",
            "exam_date": str(r.exam_date) if r.exam_date else "N/A",
            "number_of_questions": r.number_of_questions or 0,
            "level_name": "غير محدد", 
            "course_name": r.course_name or "بدون مادة", 
            "status": r.status,
            "exam_type": r.exam_type or "manual"
        })
        
    return exams_list

# ============================================================
# 3. الحذف الجذري والآمن للاختبار (لكي لا يضرب الـ Foreign Key)
# ============================================================
@router.delete("/delete/{exam_id}")
def delete_exam(exam_id: int, db: Session = Depends(get_db)):
    exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
    if not exam:
        raise HTTPException(status_code=404, detail="الاختبار غير موجود")

    # جلب كل المجموعات والأسئلة المرتبطة بالاختبار
    groups = db.query(QuestionGroup).filter(QuestionGroup.exam_id == exam_id).all()
    group_ids = [g.group_id for g in groups]
    
    questions = db.query(Question).filter(Question.exam_id == exam_id).all()
    question_ids = [q.question_id for q in questions]

    # الحذف العكسي الصارم (إجابات ➔ أسئلة ➔ أقسام ➔ مجموعات ➔ اختبار)
    if question_ids:
        db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id.in_(question_ids)).delete(synchronize_session=False)
    
    db.query(Question).filter(Question.exam_id == exam_id).delete(synchronize_session=False)
    
    if group_ids:
        db.query(QuestionSection).filter(QuestionSection.group_id.in_(group_ids)).delete(synchronize_session=False)
        
    db.query(QuestionGroup).filter(QuestionGroup.exam_id == exam_id).delete(synchronize_session=False)
    
    # أخيراً حذف الاختبار
    db.delete(exam)
    db.commit()
    
    return {"message": "تم حذف الاختبار بكامل محتوياته بنجاح"}