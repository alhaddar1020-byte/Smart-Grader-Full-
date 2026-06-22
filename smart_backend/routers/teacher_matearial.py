# # from fastapi import APIRouter, Depends, HTTPException
# # from sqlalchemy.orm import Session
# # from db.database import get_db
# # from models.grading import QuestionGroup, QuestionSection, Question, ExpectedAnswer
# # from models.exams import Exam

# # # 1. استدعاء دوال المواد من ملف teacher_matearial
# # from crud.teacher_matearial import get_teacher_materials_list, get_course_details, create_new_course_with_flexible_dept, create_new_folder

# # # 2. استدعاء دالة الإحصائيات من ملف teacher_dashboard
# # from crud.teacher_dashboard import get_teacher_dashboard_stats 

# # from schemas.teacher_matearial import TeacherMaterialsWrapper, CourseFullDetailResponse
# # from schemas.teacher_matearial import SubjectCreate 

# # # تعريف راوتر واحد فقط لكل المسارات في هذا الملف
# # router = APIRouter(prefix="/teacher-materials", tags=["Teacher Materials (إدارة المواد)"])
# # @router.get("/academic-levels") # غيرنا الاسم ليكون فريداً تماماً
# # def get_levels(db: Session = Depends(get_db)):
# #     from models.academic import Level
# #     return db.query(Level).all()
# # # 1. مسار جلب قائمة المواد مع الإحصائيات المختصرة
# # @router.get("/{teacher_id}", response_model=TeacherMaterialsWrapper)
# # def get_teacher_materials(teacher_id: int, db: Session = Depends(get_db)):
# #     # جلب قائمة المواد
# #     courses = get_teacher_materials_list(db, teacher_id)
    
# #     # جلب إحصائيات المعلم لضمان دقة الأرقام (الطلاب، الأوراق، إلخ)
# #     stats = get_teacher_dashboard_stats(db, teacher_id)
    
# #     return {
# #         "courses": courses,
# #         "total_students": stats["total_students"],
# #         "total_corrected_papers": stats["corrected_papers"],
# #         "total_exams": stats["created_exams"],
# #         "total_drafts": stats["drafts"]
# #     }

# # # 2. مسار جلب تفاصيل المادة (المجلدات والاختبارات) ✅
# # @router.get("/detail/{course_id}/{teacher_id}", response_model=CourseFullDetailResponse)
# # def get_details(course_id: int, teacher_id: int, db: Session = Depends(get_db)):
# #     data = get_course_details(db, course_id, teacher_id)
# #     if not data:
# #         raise HTTPException(status_code=404, detail="Course details not found")
# #     return data

# # # 3. مسار إضافة مادة جديدة (البحث عن القسم أو إنشاؤه) ✅
# # # @router.post("/add-course/{teacher_id}")
# # # def add_course_endpoint(
# # #     teacher_id: int, 
# # #     name: str, 
# # #     dept_name: str, 
# # #     level_id: int, 
# # #     db: Session = Depends(get_db)
# # # ):
# # #     return create_new_course_with_flexible_dept(db, teacher_id, name, dept_name, level_id)
# # @router.post("/add-course/{teacher_id}")
# # def add_course_endpoint(
# #     teacher_id: int, 
# #     data: SubjectCreate, 
# #     db: Session = Depends(get_db)
# # ):
# #     """
# #     مسار إضافة مادة جديدة يربطها بالمعلم والقسم والمستوى (أو ينشئ مستوى جديداً).
# #     """
# #     # هنا نستدعي دالة الـ CRUD التي قمنا بتطويرها لتدعم المنطق الجديد
# #     from crud.teacher_matearial import create_new_course_with_flexible_dept
    
# #     return create_new_course_with_flexible_dept(db, teacher_id, data)
# # # 4. مسار إضافة مجلد جديد داخل المادة ✅
# # @router.post("/add-folder/{course_id}/{teacher_id}")
# # def add_folder(course_id: int, teacher_id: int, name: str, db: Session = Depends(get_db)):
# #     return create_new_folder(db, name, course_id, teacher_id)


# # # 1. حذف المجلد (سيحذف الاختبارات تلقائياً بسبب CASCADE في الداتابيس)
# # @router.delete("/folder/{folder_id}")
# # def delete_folder(folder_id: int, db: Session = Depends(get_db)):
# #     from models.exams import Folder
# #     folder = db.query(Folder).filter(Folder.folder_id == folder_id).first()
# #     if not folder:
# #         raise HTTPException(status_code=404, detail="المجلد غير موجود")
# #     db.delete(folder)
# #     db.commit()
# #     return {"message": "تم حذف المجلد بنجاح"}

# # # 2. حذف اختبار واحد
# # @router.delete("/exam/{exam_id}")
# # def delete_exam(exam_id: int, db: Session = Depends(get_db)):
# #     # 1. نتأكد إن الاختبار موجود
# #     exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
# #     if not exam:
# #         raise HTTPException(status_code=404, detail="الاختبار غير موجود")
        
# #     # 2. نجيب كل الأبناء المرتبطين فيه
# #     groups = db.query(QuestionGroup).filter(QuestionGroup.exam_id == exam_id).all()
# #     group_ids = [g.group_id for g in groups]
    
# #     questions = db.query(Question).filter(Question.exam_id == exam_id).all()
# #     question_ids = [q.question_id for q in questions]

# #     # 3. الحذف العكسي (من الأصغر للأكبر عشان ما تضرب الداتا بيس)
# #     if question_ids:
# #         # حذف الإجابات أولاً
# #         db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id.in_(question_ids)).delete(synchronize_session=False)
    
# #     # حذف الأسئلة ثانياً
# #     db.query(Question).filter(Question.exam_id == exam_id).delete(synchronize_session=False)
    
# #     if group_ids:
# #         # حذف الأقسام ثالثاً
# #         db.query(QuestionSection).filter(QuestionSection.group_id.in_(group_ids)).delete(synchronize_session=False)
        
# #     # حذف المجموعات رابعاً
# #     db.query(QuestionGroup).filter(QuestionGroup.exam_id == exam_id).delete(synchronize_session=False)
    
# #     # أخيراً.. حذف الاختبار نفسه
# #     db.delete(exam)
# #     db.commit()
    
# #     return {"message": "تم حذف الاختبار بكامل محتوياته بنجاح"}
# # # 3. تعديل بيانات الاختبار
# # @router.put("/exam/{exam_id}")
# # def update_exam(exam_id: int, title: str, status: str, db: Session = Depends(get_db)):
# #     from models.exams import Exam
# #     exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
# #     if not exam:
# #         raise HTTPException(status_code=404, detail="الاختبار غير موجود")
# #     exam.exam_title = title
# #     exam.status = status
# #     db.commit()
# #     return {"message": "تم التعديل بنجاح"}
# # # @router.get("/levels")
# # # def get_levels(db: Session = Depends(get_db)):
# # #     from models.academic import Level
# # #     return db.query(Level).all()



# from fastapi import APIRouter, Depends, HTTPException
# from sqlalchemy.orm import Session
# from typing import List

# from db.database import get_db
# from models.academic import Level
# from models.exams import Folder, Exam
# from models.grading import QuestionGroup, QuestionSection, Question, ExpectedAnswer# استيراد قوالب البيانات
# from schemas.teacher_matearial import TeacherMaterialsWrapper, CourseFullDetailResponse, SubjectCreate

# # استيراد دوال العمليات
# from crud.teacher_matearial import (
#     get_teacher_materials_list,
#     get_course_details,
#     create_new_course_with_flexible_dept,
#     create_new_folder
# )

# # تعريف الـ Router
# router = APIRouter(prefix="/teacher-materials", tags=["Teacher Materials (إدارة المواد)"])

# # ---------------------------------------------------------
# # 1. جلب المستويات الأكاديمية (للقائمة المنسدلة)
# # ---------------------------------------------------------
# @router.get("/academic-levels")
# def get_academic_levels(db: Session = Depends(get_db)):
#     levels = db.query(Level).all()
#     return [{"level_id": l.level_id, "level_name": l.level_name} for l in levels]

# # ---------------------------------------------------------
# # 2. جلب المواد والإحصائيات (الشاشة الرئيسية للمواد)
# # ---------------------------------------------------------
# @router.get("/{teacher_id}", response_model=TeacherMaterialsWrapper)
# def get_teacher_materials(teacher_id: int, db: Session = Depends(get_db)):
#     # الدالة في الـ CRUD صارت ترجع كل الإحصائيات مع المواد
#     data = get_teacher_materials_list(db, teacher_id)
#     return data

# # ---------------------------------------------------------
# # 3. جلب تفاصيل المادة (المجلدات والاختبارات)
# # ---------------------------------------------------------
# @router.get("/detail/{course_id}/{teacher_id}", response_model=CourseFullDetailResponse)
# def get_details(course_id: int, teacher_id: int, db: Session = Depends(get_db)):
#     data = get_course_details(db, course_id, teacher_id)
#     if not data:
#         raise HTTPException(status_code=404, detail="تفاصيل المادة غير موجودة أو غير مرتبطة بك")
#     return data

# # ---------------------------------------------------------
# # 4. إضافة مادة جديدة
# # ---------------------------------------------------------
# @router.post("/add-course/{teacher_id}")
# def add_course_endpoint(teacher_id: int, data: SubjectCreate, db: Session = Depends(get_db)):
#     new_course = create_new_course_with_flexible_dept(db, teacher_id, data)
#     return {"message": "تمت إضافة المادة بنجاح", "course_id": new_course.course_id}

# # ---------------------------------------------------------
# # 5. إضافة مجلد جديد
# # ---------------------------------------------------------
# @router.post("/add-folder/{course_id}/{teacher_id}")
# def add_folder(course_id: int, teacher_id: int, name: str, db: Session = Depends(get_db)):
#     new_folder = create_new_folder(db, name, course_id, teacher_id)
#     if not new_folder:
#         raise HTTPException(status_code=404, detail="المادة غير موجودة أو غير مرتبطة بك")
#     return {"message": "تم إنشاء المجلد بنجاح", "folder_id": new_folder.folder_id}

# # ---------------------------------------------------------
# # 6. حذف مجلد
# # ---------------------------------------------------------
# @router.delete("/folder/{folder_id}")
# def delete_folder(folder_id: int, db: Session = Depends(get_db)):
#     folder = db.query(Folder).filter(Folder.folder_id == folder_id).first()
#     if not folder:
#         raise HTTPException(status_code=404, detail="المجلد غير موجود")
    
#     # حذف الاختبارات المتعلقة لتجنب خطأ الـ FK
#     db.query(Exam).filter(Exam.folder_id == folder_id).delete()
    
#     db.delete(folder)
#     db.commit()
#     return {"message": "تم حذف المجلد بنجاح"}

# # ---------------------------------------------------------
# # 7. حذف اختبار
# # ---------------------------------------------------------
# @router.delete("/exam/{exam_id}")
# def delete_exam(exam_id: int, db: Session = Depends(get_db)):
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
    
#     return {"message": "تم حذف الاختبار بكامل محتوياته بنجاح"}

# # ---------------------------------------------------------
# # 8. تعديل حالة واسم الاختبار
# # ---------------------------------------------------------
# @router.put("/exam/{exam_id}")
# def update_exam(exam_id: int, title: str, status: str, db: Session = Depends(get_db)):
#     exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
#     if not exam:
#         raise HTTPException(status_code=404, detail="الاختبار غير موجود")
#     exam.exam_title = title
#     exam.status = status
#     db.commit()
#     return {"message": "تم التعديل بنجاح"}


# # مسار حذف المادة
# @router.delete("/course/{course_id}/{teacher_id}")
# def delete_course_endpoint(course_id: int, teacher_id: int, db: Session = Depends(get_db)):
#     from crud.teacher_matearial import delete_entire_course
#     success = delete_entire_course(db, course_id, teacher_id)
#     if not success:
#         raise HTTPException(status_code=404, detail="المادة غير موجودة أو غير مرتبطة بك")
#     return {"message": "تم حذف المادة بنجاح"}


# from fastapi import APIRouter, Depends, HTTPException
# from sqlalchemy.orm import Session
# from db.database import get_db
# from models.grading import QuestionGroup, QuestionSection, Question, ExpectedAnswer
# from models.exams import Exam

# # 1. استدعاء دوال المواد من ملف teacher_matearial
# from crud.teacher_matearial import get_teacher_materials_list, get_course_details, create_new_course_with_flexible_dept, create_new_folder

# # 2. استدعاء دالة الإحصائيات من ملف teacher_dashboard
# from crud.teacher_dashboard import get_teacher_dashboard_stats 

# from schemas.teacher_matearial import TeacherMaterialsWrapper, CourseFullDetailResponse
# from schemas.teacher_matearial import SubjectCreate 

# # تعريف راوتر واحد فقط لكل المسارات في هذا الملف
# router = APIRouter(prefix="/teacher-materials", tags=["Teacher Materials (إدارة المواد)"])
# @router.get("/academic-levels") # غيرنا الاسم ليكون فريداً تماماً
# def get_levels(db: Session = Depends(get_db)):
#     from models.academic import Level
#     return db.query(Level).all()
# # 1. مسار جلب قائمة المواد مع الإحصائيات المختصرة
# @router.get("/{teacher_id}", response_model=TeacherMaterialsWrapper)
# def get_teacher_materials(teacher_id: int, db: Session = Depends(get_db)):
#     # جلب قائمة المواد
#     courses = get_teacher_materials_list(db, teacher_id)
    
#     # جلب إحصائيات المعلم لضمان دقة الأرقام (الطلاب، الأوراق، إلخ)
#     stats = get_teacher_dashboard_stats(db, teacher_id)
    
#     return {
#         "courses": courses,
#         "total_students": stats["total_students"],
#         "total_corrected_papers": stats["corrected_papers"],
#         "total_exams": stats["created_exams"],
#         "total_drafts": stats["drafts"]
#     }

# # 2. مسار جلب تفاصيل المادة (المجلدات والاختبارات) ✅
# @router.get("/detail/{course_id}/{teacher_id}", response_model=CourseFullDetailResponse)
# def get_details(course_id: int, teacher_id: int, db: Session = Depends(get_db)):
#     data = get_course_details(db, course_id, teacher_id)
#     if not data:
#         raise HTTPException(status_code=404, detail="Course details not found")
#     return data

# # 3. مسار إضافة مادة جديدة (البحث عن القسم أو إنشاؤه) ✅
# # @router.post("/add-course/{teacher_id}")
# # def add_course_endpoint(
# #     teacher_id: int, 
# #     name: str, 
# #     dept_name: str, 
# #     level_id: int, 
# #     db: Session = Depends(get_db)
# # ):
# #     return create_new_course_with_flexible_dept(db, teacher_id, name, dept_name, level_id)
# @router.post("/add-course/{teacher_id}")
# def add_course_endpoint(
#     teacher_id: int, 
#     data: SubjectCreate, 
#     db: Session = Depends(get_db)
# ):
#     """
#     مسار إضافة مادة جديدة يربطها بالمعلم والقسم والمستوى (أو ينشئ مستوى جديداً).
#     """
#     # هنا نستدعي دالة الـ CRUD التي قمنا بتطويرها لتدعم المنطق الجديد
#     from crud.teacher_matearial import create_new_course_with_flexible_dept
    
#     return create_new_course_with_flexible_dept(db, teacher_id, data)
# # 4. مسار إضافة مجلد جديد داخل المادة ✅
# @router.post("/add-folder/{course_id}/{teacher_id}")
# def add_folder(course_id: int, teacher_id: int, name: str, db: Session = Depends(get_db)):
#     return create_new_folder(db, name, course_id, teacher_id)


# # 1. حذف المجلد (سيحذف الاختبارات تلقائياً بسبب CASCADE في الداتابيس)
# @router.delete("/folder/{folder_id}")
# def delete_folder(folder_id: int, db: Session = Depends(get_db)):
#     from models.exams import Folder
#     folder = db.query(Folder).filter(Folder.folder_id == folder_id).first()
#     if not folder:
#         raise HTTPException(status_code=404, detail="المجلد غير موجود")
#     db.delete(folder)
#     db.commit()
#     return {"message": "تم حذف المجلد بنجاح"}

# # 2. حذف اختبار واحد
# @router.delete("/exam/{exam_id}")
# def delete_exam(exam_id: int, db: Session = Depends(get_db)):
#     # 1. نتأكد إن الاختبار موجود
#     exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
#     if not exam:
#         raise HTTPException(status_code=404, detail="الاختبار غير موجود")
        
#     # 2. نجيب كل الأبناء المرتبطين فيه
#     groups = db.query(QuestionGroup).filter(QuestionGroup.exam_id == exam_id).all()
#     group_ids = [g.group_id for g in groups]
    
#     questions = db.query(Question).filter(Question.exam_id == exam_id).all()
#     question_ids = [q.question_id for q in questions]

#     # 3. الحذف العكسي (من الأصغر للأكبر عشان ما تضرب الداتا بيس)
#     if question_ids:
#         # حذف الإجابات أولاً
#         db.query(ExpectedAnswer).filter(ExpectedAnswer.question_id.in_(question_ids)).delete(synchronize_session=False)
    
#     # حذف الأسئلة ثانياً
#     db.query(Question).filter(Question.exam_id == exam_id).delete(synchronize_session=False)
    
#     if group_ids:
#         # حذف الأقسام ثالثاً
#         db.query(QuestionSection).filter(QuestionSection.group_id.in_(group_ids)).delete(synchronize_session=False)
        
#     # حذف المجموعات رابعاً
#     db.query(QuestionGroup).filter(QuestionGroup.exam_id == exam_id).delete(synchronize_session=False)
    
#     # أخيراً.. حذف الاختبار نفسه
#     db.delete(exam)
#     db.commit()
    
#     return {"message": "تم حذف الاختبار بكامل محتوياته بنجاح"}
# # 3. تعديل بيانات الاختبار
# @router.put("/exam/{exam_id}")
# def update_exam(exam_id: int, title: str, status: str, db: Session = Depends(get_db)):
#     from models.exams import Exam
#     exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
#     if not exam:
#         raise HTTPException(status_code=404, detail="الاختبار غير موجود")
#     exam.exam_title = title
#     exam.status = status
#     db.commit()
#     return {"message": "تم التعديل بنجاح"}
# # @router.get("/levels")
# # def get_levels(db: Session = Depends(get_db)):
# #     from models.academic import Level
# #     return db.query(Level).all()



from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from db.database import get_db
from models.academic import Level
from models.exams import Folder, Exam
from models.grading import QuestionGroup, QuestionSection, Question, ExpectedAnswer# استيراد قوالب البيانات
from schemas.teacher_matearial import TeacherMaterialsWrapper, CourseFullDetailResponse, SubjectCreate

# استيراد دوال العمليات
from crud.teacher_matearial import (
    get_teacher_materials_list,
    get_course_details,
    create_new_course_with_flexible_dept,
    create_new_folder
)

# تعريف الـ Router
router = APIRouter(prefix="/teacher-materials", tags=["Teacher Materials (إدارة المواد)"])

# ---------------------------------------------------------
# 1. جلب المستويات الأكاديمية (للقائمة المنسدلة)
# ---------------------------------------------------------
@router.get("/academic-levels")
def get_academic_levels(db: Session = Depends(get_db)):
    levels = db.query(Level).all()
    return [{"level_id": l.level_id, "level_name": l.level_name} for l in levels]

# ---------------------------------------------------------
# 2. جلب المواد والإحصائيات (الشاشة الرئيسية للمواد)
# ---------------------------------------------------------
@router.get("/{teacher_id}", response_model=TeacherMaterialsWrapper)
def get_teacher_materials(teacher_id: int, db: Session = Depends(get_db)):
    # الدالة في الـ CRUD صارت ترجع كل الإحصائيات مع المواد
    data = get_teacher_materials_list(db, teacher_id)
    return data

# ---------------------------------------------------------
# 3. جلب تفاصيل المادة (المجلدات والاختبارات)
# ---------------------------------------------------------
@router.get("/detail/{course_id}/{teacher_id}", response_model=CourseFullDetailResponse)
def get_details(course_id: int, teacher_id: int, db: Session = Depends(get_db)):
    data = get_course_details(db, course_id, teacher_id)
    if not data:
        raise HTTPException(status_code=404, detail="تفاصيل المادة غير موجودة أو غير مرتبطة بك")
    return data

# ---------------------------------------------------------
# 4. إضافة مادة جديدة
# ---------------------------------------------------------
@router.post("/add-course/{teacher_id}")
def add_course_endpoint(teacher_id: int, data: SubjectCreate, db: Session = Depends(get_db)):
    new_course = create_new_course_with_flexible_dept(db, teacher_id, data)
    return {"message": "تمت إضافة المادة بنجاح", "course_id": new_course.course_id}

# ---------------------------------------------------------
# 5. إضافة مجلد جديد
# ---------------------------------------------------------
@router.post("/add-folder/{course_id}/{teacher_id}")
def add_folder(course_id: int, teacher_id: int, name: str, db: Session = Depends(get_db)):
    new_folder = create_new_folder(db, name, course_id, teacher_id)
    if not new_folder:
        raise HTTPException(status_code=404, detail="المادة غير موجودة أو غير مرتبطة بك")
    return {"message": "تم إنشاء المجلد بنجاح", "folder_id": new_folder.folder_id}

# ---------------------------------------------------------
# 6. حذف مجلد
# ---------------------------------------------------------
@router.delete("/folder/{folder_id}")
def delete_folder(folder_id: int, db: Session = Depends(get_db)):
    folder = db.query(Folder).filter(Folder.folder_id == folder_id).first()
    if not folder:
        raise HTTPException(status_code=404, detail="المجلد غير موجود")
    
    # حذف الاختبارات المتعلقة لتجنب خطأ الـ FK
    db.query(Exam).filter(Exam.folder_id == folder_id).delete()
    
    db.delete(folder)
    db.commit()
    return {"message": "تم حذف المجلد بنجاح"}

# ---------------------------------------------------------
# 7. حذف اختبار
# ---------------------------------------------------------
@router.delete("/exam/{exam_id}")
def delete_exam(exam_id: int, db: Session = Depends(get_db)):
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
    
    return {"message": "تم حذف الاختبار بكامل محتوياته بنجاح"}

# ---------------------------------------------------------
# 8. تعديل حالة واسم الاختبار
# ---------------------------------------------------------
@router.put("/exam/{exam_id}")
def update_exam(exam_id: int, title: str, status: str, db: Session = Depends(get_db)):
    exam = db.query(Exam).filter(Exam.exam_id == exam_id).first()
    if not exam:
        raise HTTPException(status_code=404, detail="الاختبار غير موجود")
    exam.exam_title = title
    exam.status = status
    db.commit()
    return {"message": "تم التعديل بنجاح"}


# مسار حذف المادة
@router.delete("/course/{course_id}/{teacher_id}")
def delete_course_endpoint(course_id: int, teacher_id: int, db: Session = Depends(get_db)):
    from crud.teacher_matearial import delete_entire_course
    success = delete_entire_course(db, course_id, teacher_id)
    if not success:
        raise HTTPException(status_code=404, detail="المادة غير موجودة أو غير مرتبطة بك")
    return {"message": "تم حذف المادة بنجاح"}