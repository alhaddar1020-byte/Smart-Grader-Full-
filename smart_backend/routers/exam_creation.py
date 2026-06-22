# # ==========================================
# # ملف: routers/exam_creation.py  (النسخة الاحترافية - 3 مستويات)
# # التحديثات:
# # 1. دعم الهيكل الهرمي: QuestionGroup -> QuestionSection -> Question
# # 2. توافق كامل مع قاعدة البيانات الجديدة
# # 3. تعديل الـ Response Schemas لتدعم الأقسام
# # ==========================================

# from fastapi import APIRouter, Depends, HTTPException, status
# from sqlalchemy.orm import Session
# from typing import List, Optional, Literal
# from pydantic import BaseModel, Field, validator
# from decimal import Decimal
# from datetime import datetime
# from sqlalchemy.sql import func
# from sqlalchemy import text # تأكدي من وجودها فوق
# from db.database import get_db
# from models.grading import QuestionGroup, QuestionSection, Question, ExpectedAnswer
# from models.exams import Exam
# from models.academic import Department, Level
# from models.profiles import Course
# from models.exams import TeacherCourse, Folder

# router = APIRouter(prefix="/api/exams", tags=["Exam Creation"])






# # ============================================================
# @router.get("/check-answers/{exam_id}")
# def check_if_exam_has_answers(exam_id: int, db: Session = Depends(get_db)):
#     # 🌟 الاستعلام الذكي باستخدام JOIN:
#     # نبحث في جدول student_answers ونربطه بجدول questions عشان نوصل للـ exam_id
#     check_query = text("""
#         SELECT 1 
#         FROM student_answers sa
#         JOIN questions q ON sa.question_id = q.question_id
#         WHERE q.exam_id = :eid 
#         LIMIT 1
#     """)
    
#     # تنفيذ البحث
#     has_answers = db.execute(check_query, {"eid": exam_id}).scalar()
    
#     # إرجاع النتيجة للفلاتر
#     return {"has_answers": bool(has_answers)}
# # ============================================================
# # GET /teacher/{teacher_id}/courses-dropdown
# # ============================================================
# @router.get(
#     "/teacher/{teacher_id}/courses-dropdown",
#     summary="جلب بيانات المواد ومجلداتها لملء القوائم المنسدلة"
# )
# def get_teacher_courses_dropdown(teacher_id: int, db: Session = Depends(get_db)):
#     results = (
#         db.query(
#             Course.course_id,
#             Course.course_name,
#             Department.department_name,
#             Level.level_name,
#             Folder.folder_id,
#             Folder.folder_name
#         )
#         .join(TeacherCourse, TeacherCourse.course_id == Course.course_id)
#         .join(Department, TeacherCourse.department_id == Department.department_id)
#         .join(Level, Course.level_id == Level.level_id)
#         .join(Folder, Folder.tc_id == TeacherCourse.tc_id) 
#         .filter(TeacherCourse.teacher_id == teacher_id)
#         .all()
#     )

#     courses_dict = {}
#     for r in results:
#         if r.course_id not in courses_dict:
#             courses_dict[r.course_id] = {
#                 "id": r.course_id,
#                 "name": r.course_name,
#                 "specialization": r.department_name,
#                 "level": r.level_name,
#                 "folders": []
#             }
        
#         courses_dict[r.course_id]["folders"].append({
#             "id": r.folder_id,
#             "name": r.folder_name
#         })
    
#     return list(courses_dict.values())


# # ============================================================
# # Pydantic Schemas — الإجابات النموذجية
# # ============================================================

# class MCQOptionSchema(BaseModel):
#     option_text: str = Field(default="") # 👈 شلنا شرط الطول
#     is_correct: bool = Field(False)

# class TrueFalseAnswerSchema(BaseModel):
#     correct_answer: Optional[Literal["true", "false"]] = Field(default=None)

# class FillBlankAnswerSchema(BaseModel):
#     correct_word: str = Field(default="")

# class MatchingPairSchema(BaseModel):
#     term: str = Field(default="")
#     match: str = Field(default="")

# class EssayAnswerSchema(BaseModel):
#     model_answer: str = Field(default="")
#     keywords: Optional[str] = Field(None)


# # ============================================================
# # Pydantic Schemas — الفقرة (Branch) والقسم (Section) والمجموعة (Group)
# # ============================================================

# class BranchSchema(BaseModel):
#     question_text: str = Field(default="") 
#     question_mark: Decimal = Field(default=0) # 👈 خليناها تقبل 0 في المسودة
#     question_order: int = Field(default=1)
#     question_numbering_style: str = Field(default="numbers")
    
#     mcq_options: Optional[List[MCQOptionSchema]] = None
#     true_false_answer: Optional[TrueFalseAnswerSchema] = None
#     fill_blank_answer: Optional[FillBlankAnswerSchema] = None
#     matching_pairs: Optional[List[MatchingPairSchema]] = None
#     essay_answer: Optional[EssayAnswerSchema] = None

# QuestionTypeEnum = Literal["essay", "mcq", "true_false", "matching", "fill_blank"]

# class SectionSchema(BaseModel): 
#     section_title: Optional[str] = None
#     section_type: QuestionTypeEnum = Field(...)
#     section_order: int = Field(default=1)
#     section_numbering_style: str = Field(default="letters_ar")
    
#     items: List[BranchSchema] = Field(default_factory=list)

   

# class QuestionGroupSchema(BaseModel):
#     group_title: Optional[str] = None
#     group_order: int = Field(default=1)
#     group_numbering_style: str = Field(default="numbers")
    
#     sections: List[SectionSchema] = Field(default_factory=list)

# class CreateExamRequest(BaseModel):
#     exam_id: Optional[int] = None # 👈 ضيفي هذا السطر هنا
#     exam_title: str = Field(...)
#     exam_date: str = Field(...)        
#     time_limit: str = Field("60 min")
#     folder_id: int = Field(...)
#     question_groups: List[QuestionGroupSchema] = Field(..., min_items=1)
#     group_numbering_style: str = Field(default="numbers") # 👈 جديد
#     status: str = Field(...) # 👈 أضفي هذا السطر
#     exam_type: str = Field(default="manual") # 👈 ضيفي هذا السطر عشان الباك إند يقبل الكلمة من الفلاتر

# # ============================================================
# # Response Schemas (تحديث لتدعم 3 مستويات)
# # ============================================================

# class BranchResponse(BaseModel):
#     question_id: int
#     question_text: str
#     question_mark: Decimal
#     question_order: int
#     question_type: str
#     class Config:
#         from_attributes = True

# class SectionResponse(BaseModel):
#     section_id: int
#     section_title: Optional[str]
#     section_type: str
#     section_order: int
#     section_total_mark: Optional[Decimal]
#     items: List[BranchResponse]  # تم ربط الفقرات بالقسم هنا
#     class Config:
#         from_attributes = True

# class GroupResponse(BaseModel):
#     group_id: int
#     group_title: Optional[str]
#     group_order: int
#     group_total_mark: Optional[Decimal]
#     sections: List[SectionResponse] # تم ربط الأقسام بالمجموعة هنا
#     class Config:
#         from_attributes = True


# # ============================================================
# # Helper — حفظ الإجابات النموذجية بحسب نوع السؤال
# # ============================================================

# def _save_expected_answers(
#     db: Session,
#     question: Question,
#     branch: BranchSchema,
#     group_type: str,
# ) -> int:
#     count = 0

#     if group_type == "mcq" and branch.mcq_options:
#         for option in branch.mcq_options:
#             db.add(ExpectedAnswer(
#                 question_id=question.question_id,
#                 answer_text=option.option_text,
#                 is_correct=option.is_correct,
#                 match_text=None,
#                 keywords=None,
#             ))
#             count += 1

#     elif group_type == "true_false" and branch.true_false_answer:
#         db.add(ExpectedAnswer(
#             question_id=question.question_id,
#             answer_text=branch.true_false_answer.correct_answer,
#             is_correct=True,
#             match_text=None,
#             keywords=None,
#         ))
#         count += 1

#     elif group_type == "fill_blank" and branch.fill_blank_answer:
#         db.add(ExpectedAnswer(
#             question_id=question.question_id,
#             answer_text=branch.fill_blank_answer.correct_word,
#             is_correct=True,
#             match_text=None,
#             keywords=None,
#         ))
#         count += 1

#     elif group_type == "matching" and branch.matching_pairs:
#         for pair in branch.matching_pairs:
#             db.add(ExpectedAnswer(
#                 question_id=question.question_id,
#                 answer_text=pair.term,
#                 is_correct=True,
#                 match_text=pair.match,
#                 keywords=None,
#             ))
#             count += 1

#     elif group_type == "essay" and branch.essay_answer:
#         db.add(ExpectedAnswer(
#             question_id=question.question_id,
#             answer_text=branch.essay_answer.model_answer,
#             is_correct=True,
#             match_text=None,
#             keywords=branch.essay_answer.keywords,
#         ))
#         count += 1

#     return count


# # ============================================================
# # POST /api/exams/create-full-exam
# # ============================================================

# @router.post(
#     "/create-full-exam",
#     response_model=dict,
#     status_code=status.HTTP_201_CREATED,
#     summary="إنشاء الاختبار كاملاً بـ 3 مستويات (مجموعات + أقسام + فقرات + إجابات)",
# )
# def create_full_exam(
#     payload: CreateExamRequest,
#     db: Session = Depends(get_db),
# ):
#     try:
#         # حساب الدرجة الكلية للامتحان بالكامل
#         # حساب الدرجة الكلية للامتحان بالكامل
#         total_marks = sum(
#             sum(sum(b.question_mark for b in s.items) for s in g.sections)
#             for g in payload.question_groups
#         )

#         # 👈 [ التعديل الجذري يبدأ من هنا ] 👉
#         if payload.exam_id:
#             # تحديث اختبار موجود (مسودة سابقة)
#             new_exam = db.query(Exam).filter(Exam.exam_id == payload.exam_id).first()
#             if not new_exam:
#                 raise HTTPException(status_code=404, detail="الاختبار غير موجود")
            
#             new_exam.exam_title = payload.exam_title
#             new_exam.number_of_questions = sum(sum(len(s.items) for s in g.sections) for g in payload.question_groups)
#             new_exam.total_marks = total_marks
#             new_exam.passing_mark = total_marks / 2
#             new_exam.exam_date = datetime.strptime(payload.exam_date, "%Y-%m-%d").date() if payload.exam_date else datetime.utcnow().date()
#             new_exam.allowed_time = payload.time_limit
#             new_exam.folder_id = payload.folder_id
#             new_exam.status = payload.status
#             new_exam.exam_type = payload.exam_type
            
#             # 👇 التعديل هنا: نحذف الأبناء ثم الآباء بالترتيب لتجنب خطأ الـ Foreign Key
#             # 1. إحضار المجموعات والأسئلة المرتبطة بالاختبار
#             groups = db.query(QuestionGroup).filter(QuestionGroup.exam_id == new_exam.exam_id).all()
#             group_ids = [g.group_id for g in groups]
            
#             questions = db.query(Question).filter(Question.exam_id == new_exam.exam_id).all()
#             question_ids = [q.question_id for q in questions]

#             # 2. الحذف العكسي (الإجابات ➔ الأسئلة ➔ الأقسام ➔ المجموعات)
#             if question_ids:
#                 db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id.in_(question_ids)).delete(synchronize_session=False)
            
#             db.query(Question).filter(Question.exam_id == new_exam.exam_id).delete(synchronize_session=False)
            
#             if group_ids:
#                 db.query(QuestionSection).filter(QuestionSection.group_id.in_(group_ids)).delete(synchronize_session=False)
                
#             db.query(QuestionGroup).filter(QuestionGroup.exam_id == new_exam.exam_id).delete(synchronize_session=False)
            
#             db.flush()
#         else:
#             # إنشاء اختبار جديد تماماً
#             new_exam = Exam(
#                 exam_title=payload.exam_title,
#                 number_of_questions=sum(sum(len(s.items) for s in g.sections) for g in payload.question_groups),
#                 total_marks=total_marks,
#                 passing_mark=total_marks / 2,
#                 exam_date=datetime.strptime(payload.exam_date, "%Y-%m-%d").date() if payload.exam_date else datetime.utcnow().date(),
#                 allowed_time=payload.time_limit,
#                 folder_id=payload.folder_id,
#                 status=payload.status,
#                 exam_type=payload.exam_type,
#             )
#             db.add(new_exam)
#             db.flush()
#         # 👈 [ التعديل ينتهي هنا، وبقية الكود Loop 1, 2, 3 يبقى كما هو بدون تغيير ] 👉

#         groups_created = sections_created = questions_created = answers_created = 0

#         # Loop 1: المجموعات (السؤال الرئيسي)
#         for group_data in payload.question_groups:
#             total_group_mark = sum(sum(b.question_mark for b in s.items) for s in group_data.sections)
            
#             group = QuestionGroup(
#                 exam_id=new_exam.exam_id,
#                 group_title=group_data.group_title,
#                 group_order=group_data.group_order,
#                 group_total_mark=total_group_mark,
#                 group_numbering_style=group_data.group_numbering_style, # 👈 أضفنا ستايل الترقيم للسؤال الرئيسي
#             )
#             db.add(group)
#             db.flush()
#             groups_created += 1

#             # Loop 2: الأقسام (الفرعية)
#             for section_data in group_data.sections:
#                 total_section_mark = sum(b.question_mark for b in section_data.items)
                
#                 section = QuestionSection(
#                     group_id=group.group_id,
#                     section_title=section_data.section_title,
#                     section_type=section_data.section_type,
#                     section_order=section_data.section_order,
#                     section_total_mark=total_section_mark,
#                     section_numbering_style=section_data.section_numbering_style, # 👈 أضفنا ستايل الترقيم للقسم
#                 )
#                 db.add(section)
#                 db.flush()
#                 sections_created += 1

#                 # Loop 3: الفقرات
#                 for branch_data in section_data.items:
#                     question = Question(
#                         exam_id=new_exam.exam_id,
#                         # group_id=group.group_id, 
#                         section_id=section.section_id, 
#                         question_text=branch_data.question_text,
#                         question_mark=branch_data.question_mark,
#                         question_order=branch_data.question_order,
#                         question_type=section_data.section_type, 
#                         question_numbering_style=branch_data.question_numbering_style, # 👈 أضفنا ستايل الترقيم للفقرة
#                     )
#                     db.add(question)
#                     db.flush()
                    
#                     ans_count = _save_expected_answers(db, question, branch_data, section_data.section_type)
#                     questions_created += 1
#                     answers_created += ans_count

#         db.commit()
#         return {
#             "message": "تم إنشاء الاختبار بنجاح",
#             "exam_id": new_exam.exam_id,
#             "groups": groups_created,
#             "sections": sections_created,
#             "questions": questions_created
#         }

#     except HTTPException:
#         db.rollback()
#         raise
#     except Exception as e:
#         db.rollback()
#         raise HTTPException(status_code=500, detail=f"خطأ أثناء الحفظ: {str(e)}")
    



# # ============================================================
# # GET /api/exams/{exam_id}/question-groups
# # ============================================================

# @router.get(
#     "/{exam_id}/question-groups",
#     response_model=List[GroupResponse],
#     summary="جلب مجموعات أسئلة اختبار معيّن",
# )
# def get_exam_question_groups(
#     exam_id: int,
#     db: Session = Depends(get_db),
# ):
#     exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
#     if not exam:
#         raise HTTPException(status_code=404, detail="الاختبار غير موجود")

#     groups = (
#         db.query(QuestionGroup)
#         .filter(QuestionGroup.exam_id == exam_id)
#         .order_by(QuestionGroup.group_order)
#         .all()
#     )
#     return groups


# # ============================================================
# # DELETE /api/exams/{exam_id}/question-groups/{group_id}
# # ============================================================

# @router.delete(
#     "/{exam_id}/question-groups/{group_id}",
#     status_code=status.HTTP_204_NO_CONTENT,
#     summary="حذف مجموعة أسئلة مع فقراتها وإجاباتها",
# )
# def delete_question_group(
#     exam_id: int,
#     group_id: int,
#     db: Session = Depends(get_db),
# ):
#     group = (
#         db.query(QuestionGroup)
#         .filter(QuestionGroup.group_id == group_id, QuestionGroup.exam_id == exam_id)
#         .first()
#     )
#     if not group:
#         raise HTTPException(status_code=404, detail="المجموعة غير موجودة")
#     db.delete(group)
#     db.commit()


# # ---------------------------------------------------------
# # 1. جلب الاختبار كاملاً (ليتم تعديله في الفلاتر)
# # ---------------------------------------------------------
# @router.get("/get-full-exam/{exam_id}")
# def get_full_exam(exam_id: int, db: Session = Depends(get_db)):
#     exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
#     if not exam:
#         raise HTTPException(status_code=404, detail="الاختبار غير موجود")

#     groups = db.query(QuestionGroup).filter(QuestionGroup.exam_id == exam_id).order_by(QuestionGroup.group_order).all()
#     groups_data = []
    
#     for g in groups:
#         sections = db.query(QuestionSection).filter(QuestionSection.group_id == g.group_id).order_by(QuestionSection.section_order).all()
#         sections_data = []
#         for s in sections:
#             questions = db.query(Question).filter(Question.section_id == s.section_id).order_by(Question.question_order).all()
#             items_data = []
#             for q in questions:
#                 answers = db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id == q.question_id).all()
                
#                 branch_dict = {
#                     "question_text": q.question_text,
#                     "question_mark": float(q.question_mark),
#                     "question_order": q.question_order,
#                     "question_numbering_style": q.question_numbering_style or "numbers"
#                 }
                
#                 if q.question_type == "mcq":
#                     branch_dict["mcq_options"] = [{"option_text": a.answer_text, "is_correct": a.is_correct} for a in answers]
#                 elif q.question_type == "true_false":
#                     ans = next((a for a in answers if a.is_correct), None)
#                     if ans: branch_dict["true_false_answer"] = {"correct_answer": ans.answer_text}
#                 elif q.question_type == "fill_blank":
#                     ans = next((a for a in answers if a.is_correct), None)
#                     if ans: branch_dict["fill_blank_answer"] = {"correct_word": ans.answer_text}
#                 elif q.question_type == "matching":
#                     branch_dict["matching_pairs"] = [{"term": a.answer_text, "match": a.match_text} for a in answers]
#                 elif q.question_type == "essay":
#                     ans = next((a for a in answers if a.is_correct), None)
#                     if ans: branch_dict["essay_answer"] = {"model_answer": ans.answer_text, "keywords": ans.keywords or ""}
                    
#                 items_data.append(branch_dict)
                
#             sections_data.append({
#                 "section_title": s.section_title or "",
#                 "section_type": s.section_type,
#                 "section_order": s.section_order,
#                 "section_numbering_style": s.section_numbering_style or "letters_ar",
#                 "items": items_data
#             })
        
#         groups_data.append({
#             "group_title": g.group_title or "",
#             "group_order": g.group_order,
#             "group_numbering_style": g.group_numbering_style or "numbers",
#             "sections": sections_data
#         })

#     return {
#         "exam_id": exam.exam_id,
#         "exam_title": exam.exam_title,
#         "exam_date": str(exam.exam_date) if exam.exam_date else "",
#         "time_limit": exam.allowed_time,
#         "folder_id": exam.folder_id,
#         "status": exam.status,
#         "exam_type": exam.exam_type,
#         "question_groups": groups_data
#     }

# # ---------------------------------------------------------
# # 2. حذف الاختبار كاملاً من جذوره
# # ---------------------------------------------------------
# @router.delete("/teacher-materials/exam/{exam_id}")
# def delete_entire_exam(exam_id: int, db: Session = Depends(get_db)):
#     exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
#     if not exam:
#         raise HTTPException(status_code=404, detail="الاختبار غير موجود")
        
#     groups = db.query(QuestionGroup).filter(QuestionGroup.exam_id == exam_id).all()
#     group_ids = [g.group_id for g in groups]
#     questions = db.query(Question).filter(Question.exam_id == exam_id).all()
#     question_ids = [q.question_id for q in questions]

#     if question_ids:
#         db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id.in_(question_ids)).delete(synchronize_session=False)
#     db.query(Question).filter(Question.exam_id == exam_id).delete(synchronize_session=False)
#     if group_ids:
#         db.query(QuestionSection).filter(QuestionSection.group_id.in_(group_ids)).delete(synchronize_session=False)
#     db.query(QuestionGroup).filter(QuestionGroup.exam_id == exam_id).delete(synchronize_session=False)
    
#     db.delete(exam)
#     db.commit()
#     return {"message": "تم حذف الاختبار بنجاح"}


# ==========================================
# ملف: routers/exam_creation.py  (النسخة الاحترافية - 3 مستويات)
# التحديثات:
# 1. دعم الهيكل الهرمي: QuestionGroup -> QuestionSection -> Question
# 2. توافق كامل مع قاعدة البيانات الجديدة
# 3. تعديل الـ Response Schemas لتدعم الأقسام
# ==========================================

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional, Literal
from pydantic import BaseModel, Field, validator
from decimal import Decimal
from datetime import datetime
from sqlalchemy.sql import func
from sqlalchemy import text # تأكدي من وجودها فوق
from db.database import get_db
from models.grading import QuestionGroup, QuestionSection, Question, ExpectedAnswer
from models.exams import Exam
from models.academic import Department, Level
from models.profiles import Course
from models.exams import TeacherCourse, Folder

router = APIRouter(prefix="/api/exams", tags=["Exam Creation"])






# ============================================================
@router.get("/check-answers/{exam_id}")
def check_if_exam_has_answers(exam_id: int, db: Session = Depends(get_db)):
    # 🌟 الاستعلام الذكي باستخدام JOIN:
    # نبحث في جدول student_answers ونربطه بجدول questions عشان نوصل للـ exam_id
    check_query = text("""
        SELECT 1 
        FROM student_answers sa
        JOIN questions q ON sa.question_id = q.question_id
        WHERE q.exam_id = :eid 
        LIMIT 1
    """)
    
    # تنفيذ البحث
    has_answers = db.execute(check_query, {"eid": exam_id}).scalar()
    
    # إرجاع النتيجة للفلاتر
    return {"has_answers": bool(has_answers)}
# ============================================================
# GET /teacher/{teacher_id}/courses-dropdown
# ============================================================
@router.get(
    "/teacher/{teacher_id}/courses-dropdown",
    summary="جلب بيانات المواد ومجلداتها لملء القوائم المنسدلة"
)
def get_teacher_courses_dropdown(teacher_id: int, db: Session = Depends(get_db)):
    results = (
        db.query(
            Course.course_id,
            Course.course_name,
            Department.department_name,
            Level.level_name,
            Folder.folder_id,
            Folder.folder_name
        )
        .join(TeacherCourse, TeacherCourse.course_id == Course.course_id)
        .join(Department, TeacherCourse.department_id == Department.department_id)
        .join(Level, Course.level_id == Level.level_id)
        .join(Folder, Folder.tc_id == TeacherCourse.tc_id) 
        .filter(TeacherCourse.teacher_id == teacher_id)
        .all()
    )

    courses_dict = {}
    for r in results:
        if r.course_id not in courses_dict:
            courses_dict[r.course_id] = {
                "id": r.course_id,
                "name": r.course_name,
                "specialization": r.department_name,
                "level": r.level_name,
                "folders": []
            }
        
        courses_dict[r.course_id]["folders"].append({
            "id": r.folder_id,
            "name": r.folder_name
        })
    
    return list(courses_dict.values())


# ============================================================
# Pydantic Schemas — الإجابات النموذجية
# ============================================================

class MCQOptionSchema(BaseModel):
    option_text: str = Field(default="") # 👈 شلنا شرط الطول
    is_correct: bool = Field(False)

class TrueFalseAnswerSchema(BaseModel):
    correct_answer: Optional[Literal["true", "false"]] = Field(default=None)

class FillBlankAnswerSchema(BaseModel):
    correct_word: str = Field(default="")

class MatchingPairSchema(BaseModel):
    term: str = Field(default="")
    match: str = Field(default="")

class EssayAnswerSchema(BaseModel):
    model_answer: str = Field(default="")
    keywords: Optional[str] = Field(None)


# ============================================================
# Pydantic Schemas — الفقرة (Branch) والقسم (Section) والمجموعة (Group)
# ============================================================

class BranchSchema(BaseModel):
    question_text: str = Field(default="") 
    question_mark: Decimal = Field(default=0) # 👈 خليناها تقبل 0 في المسودة
    question_order: int = Field(default=1)
    question_numbering_style: str = Field(default="numbers")
    
    mcq_options: Optional[List[MCQOptionSchema]] = None
    true_false_answer: Optional[TrueFalseAnswerSchema] = None
    fill_blank_answer: Optional[FillBlankAnswerSchema] = None
    matching_pairs: Optional[List[MatchingPairSchema]] = None
    essay_answer: Optional[EssayAnswerSchema] = None

QuestionTypeEnum = Literal["essay", "mcq", "true_false", "matching", "fill_blank"]

class SectionSchema(BaseModel): 
    section_title: Optional[str] = None
    section_type: QuestionTypeEnum = Field(...)
    section_order: int = Field(default=1)
    section_numbering_style: str = Field(default="letters_ar")
    
    items: List[BranchSchema] = Field(default_factory=list)

   

class QuestionGroupSchema(BaseModel):
    group_title: Optional[str] = None
    group_order: int = Field(default=1)
    group_numbering_style: str = Field(default="numbers")
    
    sections: List[SectionSchema] = Field(default_factory=list)

class CreateExamRequest(BaseModel):
    exam_id: Optional[int] = None # 👈 ضيفي هذا السطر هنا
    exam_title: str = Field(...)
    exam_date: str = Field(...)        
    time_limit: str = Field("60 min")
    folder_id: int = Field(...)
    question_groups: List[QuestionGroupSchema] = Field(..., min_items=1)
    group_numbering_style: str = Field(default="numbers") # 👈 جديد
    status: str = Field(...) # 👈 أضفي هذا السطر
    exam_type: str = Field(default="manual") # 👈 ضيفي هذا السطر عشان الباك إند يقبل الكلمة من الفلاتر

# ============================================================
# Response Schemas (تحديث لتدعم 3 مستويات)
# ============================================================

class BranchResponse(BaseModel):
    question_id: int
    question_text: str
    question_mark: Decimal
    question_order: int
    question_type: str
    class Config:
        from_attributes = True

class SectionResponse(BaseModel):
    section_id: int
    section_title: Optional[str]
    section_type: str
    section_order: int
    section_total_mark: Optional[Decimal]
    items: List[BranchResponse]  # تم ربط الفقرات بالقسم هنا
    class Config:
        from_attributes = True

class GroupResponse(BaseModel):
    group_id: int
    group_title: Optional[str]
    group_order: int
    group_total_mark: Optional[Decimal]
    sections: List[SectionResponse] # تم ربط الأقسام بالمجموعة هنا
    class Config:
        from_attributes = True


# ============================================================
# Helper — حفظ الإجابات النموذجية بحسب نوع السؤال
# ============================================================

def _save_expected_answers(
    db: Session,
    question: Question,
    branch: BranchSchema,
    group_type: str,
) -> int:
    count = 0

    if group_type == "mcq" and branch.mcq_options:
        for option in branch.mcq_options:
            db.add(ExpectedAnswer(
                question_id=question.question_id,
                answer_text=option.option_text,
                is_correct=option.is_correct,
                match_text=None,
                keywords=None,
            ))
            count += 1

    elif group_type == "true_false" and branch.true_false_answer:
        db.add(ExpectedAnswer(
            question_id=question.question_id,
            answer_text=branch.true_false_answer.correct_answer,
            is_correct=True,
            match_text=None,
            keywords=None,
        ))
        count += 1

    elif group_type == "fill_blank" and branch.fill_blank_answer:
        db.add(ExpectedAnswer(
            question_id=question.question_id,
            answer_text=branch.fill_blank_answer.correct_word,
            is_correct=True,
            match_text=None,
            keywords=None,
        ))
        count += 1

    elif group_type == "matching" and branch.matching_pairs:
        for pair in branch.matching_pairs:
            db.add(ExpectedAnswer(
                question_id=question.question_id,
                answer_text=pair.term,
                is_correct=True,
                match_text=pair.match,
                keywords=None,
            ))
            count += 1

    elif group_type == "essay" and branch.essay_answer:
        db.add(ExpectedAnswer(
            question_id=question.question_id,
            answer_text=branch.essay_answer.model_answer,
            is_correct=True,
            match_text=None,
            keywords=branch.essay_answer.keywords,
        ))
        count += 1

    return count


# ============================================================
# POST /api/exams/create-full-exam
# ============================================================

@router.post(
    "/create-full-exam",
    response_model=dict,
    status_code=status.HTTP_201_CREATED,
    summary="إنشاء الاختبار كاملاً بـ 3 مستويات (مجموعات + أقسام + فقرات + إجابات)",
)
def create_full_exam(
    payload: CreateExamRequest,
    db: Session = Depends(get_db),
):
    try:
        # حساب الدرجة الكلية للامتحان بالكامل
        # حساب الدرجة الكلية للامتحان بالكامل
        total_marks = sum(
            sum(sum(b.question_mark for b in s.items) for s in g.sections)
            for g in payload.question_groups
        )

        # 👈 [ التعديل الجذري يبدأ من هنا ] 👉
        if payload.exam_id:
            # تحديث اختبار موجود (مسودة سابقة)
            new_exam = db.query(Exam).filter(Exam.exam_id == payload.exam_id).first()
            if not new_exam:
                raise HTTPException(status_code=404, detail="الاختبار غير موجود")
            
            new_exam.exam_title = payload.exam_title
            new_exam.number_of_questions = sum(sum(len(s.items) for s in g.sections) for g in payload.question_groups)
            new_exam.total_marks = total_marks
            new_exam.passing_mark = total_marks / 2
            new_exam.exam_date = datetime.strptime(payload.exam_date, "%Y-%m-%d").date() if payload.exam_date else datetime.utcnow().date()
            new_exam.allowed_time = payload.time_limit
            new_exam.folder_id = payload.folder_id
            new_exam.status = payload.status
            new_exam.exam_type = payload.exam_type
            
            # 👇 التعديل هنا: نحذف الأبناء ثم الآباء بالترتيب لتجنب خطأ الـ Foreign Key
            # 1. إحضار المجموعات والأسئلة المرتبطة بالاختبار
            groups = db.query(QuestionGroup).filter(QuestionGroup.exam_id == new_exam.exam_id).all()
            group_ids = [g.group_id for g in groups]
            
            questions = db.query(Question).filter(Question.exam_id == new_exam.exam_id).all()
            question_ids = [q.question_id for q in questions]

            # 2. الحذف العكسي (الإجابات ➔ الأسئلة ➔ الأقسام ➔ المجموعات)
            if question_ids:
                db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id.in_(question_ids)).delete(synchronize_session=False)
            
            db.query(Question).filter(Question.exam_id == new_exam.exam_id).delete(synchronize_session=False)
            
            if group_ids:
                db.query(QuestionSection).filter(QuestionSection.group_id.in_(group_ids)).delete(synchronize_session=False)
                
            db.query(QuestionGroup).filter(QuestionGroup.exam_id == new_exam.exam_id).delete(synchronize_session=False)
            
            db.flush()
        else:
            # إنشاء اختبار جديد تماماً
            new_exam = Exam(
                exam_title=payload.exam_title,
                number_of_questions=sum(sum(len(s.items) for s in g.sections) for g in payload.question_groups),
                total_marks=total_marks,
                passing_mark=total_marks / 2,
                exam_date=datetime.strptime(payload.exam_date, "%Y-%m-%d").date() if payload.exam_date else datetime.utcnow().date(),
                allowed_time=payload.time_limit,
                folder_id=payload.folder_id,
                status=payload.status,
                exam_type=payload.exam_type,
            )
            db.add(new_exam)
            db.flush()
        # 👈 [ التعديل ينتهي هنا، وبقية الكود Loop 1, 2, 3 يبقى كما هو بدون تغيير ] 👉

        groups_created = sections_created = questions_created = answers_created = 0

        # Loop 1: المجموعات (السؤال الرئيسي)
        for group_data in payload.question_groups:
            total_group_mark = sum(sum(b.question_mark for b in s.items) for s in group_data.sections)
            
            group = QuestionGroup(
                exam_id=new_exam.exam_id,
                group_title=group_data.group_title,
                group_order=group_data.group_order,
                group_total_mark=total_group_mark,
                group_numbering_style=group_data.group_numbering_style, # 👈 أضفنا ستايل الترقيم للسؤال الرئيسي
            )
            db.add(group)
            db.flush()
            groups_created += 1

            # Loop 2: الأقسام (الفرعية)
            for section_data in group_data.sections:
                total_section_mark = sum(b.question_mark for b in section_data.items)
                
                section = QuestionSection(
                    group_id=group.group_id,
                    section_title=section_data.section_title,
                    section_type=section_data.section_type,
                    section_order=section_data.section_order,
                    section_total_mark=total_section_mark,
                    section_numbering_style=section_data.section_numbering_style, # 👈 أضفنا ستايل الترقيم للقسم
                )
                db.add(section)
                db.flush()
                sections_created += 1

                # Loop 3: الفقرات
                for branch_data in section_data.items:
                    question = Question(
                        exam_id=new_exam.exam_id,
                        # group_id=group.group_id, 
                        section_id=section.section_id, 
                        question_text=branch_data.question_text,
                        question_mark=branch_data.question_mark,
                        question_order=branch_data.question_order,
                        question_type=section_data.section_type, 
                        question_numbering_style=branch_data.question_numbering_style, # 👈 أضفنا ستايل الترقيم للفقرة
                    )
                    db.add(question)
                    db.flush()
                    
                    ans_count = _save_expected_answers(db, question, branch_data, section_data.section_type)
                    questions_created += 1
                    answers_created += ans_count

        db.commit()
        return {
            "message": "تم إنشاء الاختبار بنجاح",
            "exam_id": new_exam.exam_id,
            "groups": groups_created,
            "sections": sections_created,
            "questions": questions_created
        }

    except HTTPException:
        db.rollback()
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"خطأ أثناء الحفظ: {str(e)}")
    



# ============================================================
# GET /api/exams/{exam_id}/question-groups
# ============================================================

@router.get(
    "/{exam_id}/question-groups",
    response_model=List[GroupResponse],
    summary="جلب مجموعات أسئلة اختبار معيّن",
)
def get_exam_question_groups(
    exam_id: int,
    db: Session = Depends(get_db),
):
    exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
    if not exam:
        raise HTTPException(status_code=404, detail="الاختبار غير موجود")

    groups = (
        db.query(QuestionGroup)
        .filter(QuestionGroup.exam_id == exam_id)
        .order_by(QuestionGroup.group_order)
        .all()
    )
    return groups


# ============================================================
# DELETE /api/exams/{exam_id}/question-groups/{group_id}
# ============================================================

@router.delete(
    "/{exam_id}/question-groups/{group_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="حذف مجموعة أسئلة مع فقراتها وإجاباتها",
)
def delete_question_group(
    exam_id: int,
    group_id: int,
    db: Session = Depends(get_db),
):
    group = (
        db.query(QuestionGroup)
        .filter(QuestionGroup.group_id == group_id, QuestionGroup.exam_id == exam_id)
        .first()
    )
    if not group:
        raise HTTPException(status_code=404, detail="المجموعة غير موجودة")
    db.delete(group)
    db.commit()


# ---------------------------------------------------------
# 1. جلب الاختبار كاملاً (ليتم تعديله في الفلاتر)
# ---------------------------------------------------------
@router.get("/get-full-exam/{exam_id}")
def get_full_exam(exam_id: int, db: Session = Depends(get_db)):
    exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
    if not exam:
        raise HTTPException(status_code=404, detail="الاختبار غير موجود")

    groups = db.query(QuestionGroup).filter(QuestionGroup.exam_id == exam_id).order_by(QuestionGroup.group_order).all()
    groups_data = []
    
    for g in groups:
        sections = db.query(QuestionSection).filter(QuestionSection.group_id == g.group_id).order_by(QuestionSection.section_order).all()
        sections_data = []
        for s in sections:
            questions = db.query(Question).filter(Question.section_id == s.section_id).order_by(Question.question_order).all()
            items_data = []
            for q in questions:
                answers = db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id == q.question_id).all()
                
                branch_dict = {
                    "question_text": q.question_text,
                    "question_mark": float(q.question_mark),
                    "question_order": q.question_order,
                    "question_numbering_style": q.question_numbering_style or "numbers"
                }
                
                if q.question_type == "mcq":
                    branch_dict["mcq_options"] = [{"option_text": a.answer_text, "is_correct": a.is_correct} for a in answers]
                elif q.question_type == "true_false":
                    ans = next((a for a in answers if a.is_correct), None)
                    if ans: branch_dict["true_false_answer"] = {"correct_answer": ans.answer_text}
                elif q.question_type == "fill_blank":
                    ans = next((a for a in answers if a.is_correct), None)
                    if ans: branch_dict["fill_blank_answer"] = {"correct_word": ans.answer_text}
                elif q.question_type == "matching":
                    branch_dict["matching_pairs"] = [{"term": a.answer_text, "match": a.match_text} for a in answers]
                elif q.question_type == "essay":
                    ans = next((a for a in answers if a.is_correct), None)
                    if ans: branch_dict["essay_answer"] = {"model_answer": ans.answer_text, "keywords": ans.keywords or ""}
                    
                items_data.append(branch_dict)
                
            sections_data.append({
                "section_title": s.section_title or "",
                "section_type": s.section_type,
                "section_order": s.section_order,
                "section_numbering_style": s.section_numbering_style or "letters_ar",
                "items": items_data
            })
        
        groups_data.append({
            "group_title": g.group_title or "",
            "group_order": g.group_order,
            "group_numbering_style": g.group_numbering_style or "numbers",
            "sections": sections_data
        })

    return {
        "exam_id": exam.exam_id,
        "exam_title": exam.exam_title,
        "exam_date": str(exam.exam_date) if exam.exam_date else "",
        "time_limit": exam.allowed_time,
        "folder_id": exam.folder_id,
        "status": exam.status,
        "exam_type": exam.exam_type,
        "question_groups": groups_data
    }

# ---------------------------------------------------------
# 2. حذف الاختبار كاملاً من جذوره
# ---------------------------------------------------------
@router.delete("/teacher-materials/exam/{exam_id}")
def delete_entire_exam(exam_id: int, db: Session = Depends(get_db)):
    exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
    if not exam:
        raise HTTPException(status_code=404, detail="الاختبار غير موجود")
        
    groups = db.query(QuestionGroup).filter(QuestionGroup.exam_id == exam_id).all()
    group_ids = [g.group_id for g in groups]
    questions = db.query(Question).filter(Question.exam_id == exam_id).all()
    question_ids = [q.question_id for q in questions]

    if question_ids:
        db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id.in_(question_ids)).delete(synchronize_session=False)
    db.query(Question).filter(Question.exam_id == exam_id).delete(synchronize_session=False)
    if group_ids:
        db.query(QuestionSection).filter(QuestionSection.group_id.in_(group_ids)).delete(synchronize_session=False)
    db.query(QuestionGroup).filter(QuestionGroup.exam_id == exam_id).delete(synchronize_session=False)
    
    db.delete(exam)
    db.commit()
    return {"message": "تم حذف الاختبار بنجاح"}


    