from sqlalchemy.orm import Session
# استيراد الجداول الأربعة من الموديل
from models.exams import Semester, TeacherCourse, Folder, Exam 
# استيراد الشيمات اللي سويناها
from schemas import exams

# ==========================================
# 1. عمليات الأترام الدراسية (Semester)
# ==========================================
def get_all_semesters(db: Session):
    """جلب جميع الأترام مرتبة من الأحدث"""
    return db.query(Semester).order_by(Semester.semester_id.desc()).all()

def create_semester(db: Session, semester_data: exams.SemesterCreate):
    """إضافة ترم دراسي جديد"""
    # حذفنا is_current=False من هنا لأنها موجودة أساساً داخل الـ Schema
    new_semester = Semester(**semester_data.model_dump())
    db.add(new_semester)
    db.commit()
    db.refresh(new_semester)
    return new_semester

def set_current_semester(db: Session, semester_id: int):
    """تفعيل ترم وإلغاء تفعيل الباقي"""
    db.query(Semester).update({Semester.is_current: False})
    
    target_semester = db.query(Semester).filter(Semester.semester_id == semester_id).first()
    if target_semester:
        target_semester.is_current = True
        db.commit()
        db.refresh(target_semester)
    else:
        db.rollback()
        
    return target_semester

def delete_semester(db: Session, semester_id: int):
    """حذف ترم دراسي من قاعدة البيانات"""
    target = db.query(Semester).filter(Semester.semester_id == semester_id).first()
    if target:
        db.delete(target)
        db.commit()
        return True
    return False

def update_semester(db: Session, semester_id: int, semester_data: exams.SemesterCreate):
    """تعديل بيانات ترم دراسي موجود"""
    target = db.query(Semester).filter(Semester.semester_id == semester_id).first()
    if target:
        target.semester_name = semester_data.semester_name
        target.academic_year = semester_data.academic_year
        target.start_date = semester_data.start_date
        target.end_date = semester_data.end_date
        db.commit()
        db.refresh(target)
        return target
    return None


# ==========================================
# 2. عمليات التكاليف الأكاديمية (TeacherCourse)
# ==========================================
def get_teacher_courses(db: Session, teacher_id: int, semester_id: int):
    """جلب مواد معلم معين في ترم معين"""
    return db.query(TeacherCourse).filter(
        TeacherCourse.teacher_id == teacher_id,
        TeacherCourse.semester_id == semester_id
    ).all()

def assign_teacher_to_course(db: Session, tc_data: exams.TeacherCourseCreate):
    """إسناد مادة لمعلم (إنشاء تكليف جديد)"""
    new_assignment = TeacherCourse(**tc_data.model_dump())
    db.add(new_assignment)
    db.commit()
    db.refresh(new_assignment)
    return new_assignment


# ==========================================
# 3. عمليات المجلدات (Folder)
# ==========================================
def get_folders_by_tc(db: Session, tc_id: int):
    """جلب المجلدات الخاصة بتكليف/مادة معينة"""
    return db.query(Folder).filter(Folder.tc_id == tc_id).all()

def create_folder(db: Session, folder_data: exams.FolderCreate):
    """إنشاء مجلد جديد"""
    new_folder = Folder(**folder_data.model_dump())
    db.add(new_folder)
    db.commit()
    db.refresh(new_folder)
    return new_folder


# ==========================================
# 4. عمليات الاختبارات (Exam)
# ==========================================
def get_exams_by_folder(db: Session, folder_id: int):
    """جلب جميع الاختبارات التابعة لمجلد محدد"""
    return db.query(Exam).filter(Exam.folder_id == folder_id).order_by(Exam.exam_id.desc()).all()

def create_exam(db: Session, exam_data: exams.ExamCreate):
    """إنشاء إعدادات اختبار جديد"""
    # نستخدم model_dump ونضيف حالة الاختبار "Draft" بشكل افتراضي
    new_exam = Exam(**exam_data.model_dump(), status="Draft")
    db.add(new_exam)
    db.commit()
    db.refresh(new_exam)
    return new_exam

