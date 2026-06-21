# from sqlalchemy.orm import Session
# from models.academic import Department, Level, StudentCourse
# from models.profiles import Course
# from models.exams import TeacherCourse, Folder, Exam
# from schemas.teacher_matearial import SubjectCreate
# from models.exams import Semester# 1. جلب تفاصيل المادة (المجلدات والاختبارات التابعة لها)





# def get_course_details(db: Session, course_id: int, teacher_id: int):
#     # نجد أولاً سجل الربط (TC_ID) لهذه المادة وهذا المعلم
#     tc = db.query(TeacherCourse).filter(
#         TeacherCourse.course_id == course_id,
#         TeacherCourse.teacher_id == teacher_id
#     ).first()

#     if not tc:
#         return None

#     # جلب كافة المجلدات التابعة لهذه المادة
#     folders = db.query(Folder).filter(Folder.tc_id == tc.tc_id).all()
    
#     # جلب عدد الطلاب الكلي في هذه المادة
#     student_count = db.query(StudentCourse).filter(StudentCourse.course_id == course_id).count()

#     # جلب اسم المادة 
#     course = db.query(Course).filter(Course.course_id == course_id).first()
#     course_name = course.course_name if course else "مادة غير معروفة"

#     # 👇=== هذا هو الجزء الناقص اللي بيحل المشكلة ===👇
#     level = db.query(Level).filter(Level.level_id == course.level_id).first() if course else None
#     level_name = level.level_name if level else "غير معروف"

#     dept = db.query(Department).filter(Department.department_id == tc.department_id).first() if tc else None
#     dept_name = dept.department_name if dept else "غير معروف"
#     # 👆===========================================👆

#     results = []
#     for folder in folders:
#         # جلب الاختبارات داخل كل مجلد
#         # أضفنا order_by عشان يرتب الاختبارات من الأحدث للأقدم
#         # جلب الاختبارات داخل كل مجلد (مرتبة حسب آخر تعديل ثم الأحدث إنشاءً)
#         exams = db.query(Exam).filter(Exam.folder_id == folder.folder_id).order_by(Exam.updated.desc().nulls_last(), Exam.exam_id.desc()).all()
#         results.append({
#             "folder_id": folder.folder_id,
#             "folder_name": folder.folder_name,
#             "exams": [
#                 {
#                     "exam_id": e.exam_id,
#                     "title": e.exam_title,
#                     "date": e.exam_date.strftime("%Y-%m-%d") if e.exam_date else "2026-05-07",
#                     "status": e.status,
#                     "student_count": student_count 
#                 } for e in exams
#             ]
#         })

#     # 👇=== تأكدي إن الـ Return يرسلهم للفلاتر ===👇
#     return {
#         "course_name": course_name, 
#         "department_name": dept_name, # 👈 أضفنا التخصص هنا
#         "level_name": level_name,     # 👈 أضفنا المستوى هنا
#         "total_students": student_count,
#         "folders": results
#     }
# # 2. إنشاء مجلد جديد
# def create_new_folder(db: Session, name: str, course_id: int, teacher_id: int):
#     tc = db.query(TeacherCourse).filter(
#         TeacherCourse.course_id == course_id,
#         TeacherCourse.teacher_id == teacher_id
#     ).first()
    
#     if tc:
#         new_folder = Folder(folder_name=name, tc_id=tc.tc_id)
#         db.add(new_folder)
#         db.commit()
#         db.refresh(new_folder)
#         return new_folder
#     return None


# # def create_new_course_with_flexible_dept(db: Session, teacher_id: int, data: SubjectCreate):
# #     # 1. منطق المستوى المرن (الجديد)
# #     final_level_id = data.level_id
    
# #     # إذا اختار المدرس "أخرى" (level_id = 0) وأدخل اسماً جديداً
# #     if data.level_id == 0 and data.new_level_name:
# #         new_level = Level(level_name=data.new_level_name)
# #         db.add(new_level)
# #         db.commit()
# #         db.refresh(new_level)
# #         final_level_id = new_level.level_id

# #     # 2. البحث عن القسم أو إنشاؤه (من كودك الأصلي)
# #     dept = db.query(Department).filter(Department.department_name == data.dept_name).first()
# #     if not dept:
# #         dept = Department(department_name=data.dept_name)
# #         db.add(dept)
# #         db.commit()
# #         db.refresh(dept)
    
# #     # 3. البحث عن المادة أو إنشاؤها
# #     existing_course = db.query(Course).filter(
# #         Course.course_name == data.name, 
# #         Course.level_id == final_level_id
# #     ).first()

# #     if existing_course:
# #         new_course = existing_course
# #     else:
# #         new_course = Course(course_name=data.name, level_id=final_level_id)
# #         db.add(new_course)
# #         db.commit()
# #         db.refresh(new_course)
    
# #     # 4. ربط المعلم بالمادة والقسم (الرابط)
# #     existing_link = db.query(TeacherCourse).filter(
# #         TeacherCourse.teacher_id == teacher_id,
# #         TeacherCourse.course_id == new_course.course_id,
# #         TeacherCourse.department_id == dept.department_id
# #     ).first()

# #     if not existing_link:
# #         new_link = TeacherCourse(
# #             teacher_id=teacher_id,
# #             course_id=new_course.course_id,
# #             department_id=dept.department_id,
# #             semester_id=1 # أو يمكنك جعله الترم النشط الذي جلبناه سابقاً
# #         )
# #         db.add(new_link)
# #         db.commit()
    
# #     return new_course

# def create_new_course_with_flexible_dept(db: Session, teacher_id: int, data: SubjectCreate):
#     # 1. منطق المستوى المرن
#     final_level_id = data.level_id
#     if data.level_id == 0 and data.new_level_name:
#         new_level = Level(level_name=data.new_level_name)
#         db.add(new_level)
#         db.commit()
#         db.refresh(new_level)
#         final_level_id = new_level.level_id

#     # 2. البحث عن القسم أو إنشاؤه
#     dept = db.query(Department).filter(Department.department_name == data.dept_name).first()
#     if not dept:
#         dept = Department(department_name=data.dept_name)
#         db.add(dept)
#         db.commit()
#         db.refresh(dept)
    
#     # 3. البحث عن المادة أو إنشاؤها
#     existing_course = db.query(Course).filter(
#         Course.course_name == data.name, 
#         Course.level_id == final_level_id
#     ).first()

#     if existing_course:
#         new_course = existing_course
#     else:
#         new_course = Course(course_name=data.name, level_id=final_level_id)
#         db.add(new_course)
#         db.commit()
#         db.refresh(new_course)
    
#     # 4. ربط المعلم بالمادة والقسم (مع الترم النشط تلقائياً) ✅
#     # هنا نجلب الترم النشط من قاعدة البيانات بدلاً من كتابته يدوياً
#     active_semester = db.query(Semester).filter(Semester.is_current == True).first()
#     active_semester_id = active_semester.semester_id if active_semester else 1 

#     existing_link = db.query(TeacherCourse).filter(
#         TeacherCourse.teacher_id == teacher_id,
#         TeacherCourse.course_id == new_course.course_id,
#         TeacherCourse.department_id == dept.department_id,
#         TeacherCourse.semester_id == active_semester_id # ربط بالترم الحالي فقط
#     ).first()

#     if not existing_link:
#         new_link = TeacherCourse(
#             teacher_id=teacher_id,
#             course_id=new_course.course_id,
#             department_id=dept.department_id,
#             semester_id=active_semester_id # استخدام الـ ID التلقائي
#         )
#         db.add(new_link)
#         db.commit()
    
#     return new_course
# # 4. جلب قائمة المواد
# # def get_teacher_materials_list(db: Session, teacher_id: int):
# #     query = db.query(
# #         Course.course_id,
# #         Course.course_name,
# #         Department.department_name,
# #         Level.level_name
# #     ).join(TeacherCourse, Course.course_id == TeacherCourse.course_id)\
# #      .join(Department, TeacherCourse.department_id == Department.department_id)\
# #      .join(Level, Course.level_id == Level.level_id)\
# #      .filter(TeacherCourse.teacher_id == teacher_id).all()

# #     results = []
# #     for row in query:
# #         # نحسب عدد المجلدات الخاصة بهذه المادة وهذا المعلم
# #         f_count = db.query(Folder).join(TeacherCourse).filter(
# #             TeacherCourse.course_id == row.course_id,
# #             TeacherCourse.teacher_id == teacher_id
# #         ).count()
# #         e_count = db.query(Exam).join(Folder).join(TeacherCourse, Folder.tc_id == TeacherCourse.tc_id)\
# #             .filter(TeacherCourse.course_id == row.course_id, TeacherCourse.teacher_id == teacher_id).count()

# #         results.append({
# #             "course_id": row.course_id,
# #             "course_name": row.course_name,
# #             "department_name": row.department_name,
# #             "level_name": row.level_name,
# #             "total_folders": f_count,
# #             "total_exams": e_count
# #         })
# #     return results

# # def get_teacher_materials_list(db: Session, teacher_id: int):
    

# #     query = db.query(
# #         Course.course_id,
# #         Course.course_name,
# #         Department.department_name,
# #         Level.level_name
# #     ).join(TeacherCourse, Course.course_id == TeacherCourse.course_id)\
# #      .join(Department, TeacherCourse.department_id == Department.department_id)\
# #      .join(Level, Course.level_id == Level.level_id)\
# #      .join(Semester, TeacherCourse.semester_id == Semester.semester_id)\
# #      .filter(
# #          TeacherCourse.teacher_id == teacher_id, 
# #          Semester.is_current == True  # هنا يكمن سر التصفية التلقائية للترم النشط
# #      ).all()
# def get_teacher_materials_list(db: Session, teacher_id: int):
#     # نستخدم Join مع TeacherCourse ثم مع Semester للفلترة
#     query = db.query(
#         Course.course_id,
#         Course.course_name,
#         Department.department_name,
#         Level.level_name
#     ).join(TeacherCourse, Course.course_id == TeacherCourse.course_id)\
#      .join(Semester, TeacherCourse.semester_id == Semester.semester_id)\
#      .join(Department, TeacherCourse.department_id == Department.department_id)\
#      .join(Level, Course.level_id == Level.level_id)\
#      .filter(
#          TeacherCourse.teacher_id == teacher_id, 
#          Semester.is_current == True  # الفلتر يعتمد على حالة الترم في جدول Semester
#      ).all()
    
#     # ... بقية منطق النتائج كما هو

#     results = []
#     for row in query:
#         # حساب المجلدات والاختبارات المرتبطة فقط بالمواد الموجودة في الترم النشط
#         f_count = db.query(Folder).join(TeacherCourse).filter(
#             TeacherCourse.course_id == row.course_id,
#             TeacherCourse.teacher_id == teacher_id
#         ).count()
        
#         e_count = db.query(Exam).join(Folder).join(TeacherCourse, Folder.tc_id == TeacherCourse.tc_id)\
#             .filter(
#                 TeacherCourse.course_id == row.course_id, 
#                 TeacherCourse.teacher_id == teacher_id
#             ).count()

#         results.append({
#             "course_id": row.course_id,
#             "course_name": row.course_name,
#             "department_name": row.department_name,
#             "level_name": row.level_name,
#             "total_folders": f_count,
#             "total_exams": e_count
#         })
#     return results



from sqlalchemy.orm import Session
from sqlalchemy import or_
from models.academic import Department, Level, StudentCourse
from models.profiles import Course
from models.exams import TeacherCourse, Folder, Exam, Semester
from models.grading import AnswerSheet # 👈 استيراد جدول الأوراق المصححة
from schemas.teacher_matearial import SubjectCreate

# 1. جلب الإحصائيات وقائمة المواد
def get_teacher_materials_list(db: Session, teacher_id: int):
    # جلب الترم النشط
    active_semester = db.query(Semester).filter(Semester.is_current == True).first()
    active_semester_id = active_semester.semester_id if active_semester else 1

    # جلب جميع روابط المعلم في هذا الترم
    teacher_courses = db.query(TeacherCourse).filter(
        TeacherCourse.teacher_id == teacher_id,
        TeacherCourse.semester_id == active_semester_id
    ).all()

    tc_ids = [tc.tc_id for tc in teacher_courses]
    course_ids = [tc.course_id for tc in teacher_courses]

    # حساب الطلاب (إجمالي التسجيلات في مواد الترم النشط بدون distinct)
    total_students = 0
    if course_ids:
        total_students = db.query(StudentCourse.student_id).filter(
            StudentCourse.course_id.in_(course_ids),
            StudentCourse.semester_id == active_semester_id
        ).distinct().count() # 👈 شلنا distinct عشان يحسب كل التسجيلات

    total_published_exams = 0
    total_drafts = 0
    total_corrected_papers = 0 # 👈 متغير الأوراق المصححة

    if tc_ids:
        # جلب المجلدات
        active_folders = db.query(Folder.folder_id).filter(Folder.tc_id.in_(tc_ids)).all()
        folder_ids = [f.folder_id for f in active_folders]
        
        if folder_ids:
            # جلب الاختبارات المنشورة والمسودات
            active_exams = db.query(Exam.exam_id, Exam.status).filter(Exam.folder_id.in_(folder_ids)).all()
            
            published_exam_ids = []
            for e in active_exams:
                if str(e.status).lower() == "published":
                    total_published_exams += 1
                    published_exam_ids.append(e.exam_id)
                elif str(e.status).lower() == "draft":
                    total_drafts += 1

            # 👈 حساب الأوراق المصححة (الحقيقية) من جدول answer_sheet
            if published_exam_ids:
                total_corrected_papers = db.query(AnswerSheet).filter(
                    AnswerSheet.exam_id.in_(published_exam_ids),
                    AnswerSheet.status.ilike("Graded") # فقط الأوراق اللي حالتها Graded
                ).count()

    # جلب بيانات المواد للكروت
    courses_list = []
    for tc in teacher_courses:
        course = db.query(Course).filter(Course.course_id == tc.course_id).first()
        dept = db.query(Department).filter(Department.department_id == tc.department_id).first()
        level = db.query(Level).filter(Level.level_id == course.level_id).first() if course else None
        
        f_count = db.query(Folder).filter(Folder.tc_id == tc.tc_id).count()
        e_count = db.query(Exam).join(Folder).filter(Folder.tc_id == tc.tc_id).count()

        courses_list.append({
            "course_id": course.course_id,
            "course_name": course.course_name,
            "department_name": dept.department_name if dept else "عام",
            "level_name": level.level_name if level else "غير محدد",
            "total_folders": f_count,
            "total_exams": e_count
        })

    return {
        "total_students": total_students,
        "total_corrected_papers": total_corrected_papers, # 👈 أرسلناها للواجهة
        "total_exams": total_published_exams,
        "total_drafts": total_drafts,
        "courses": courses_list
    }

# 2. جلب تفاصيل المادة (المجلدات والاختبارات التابعة لها)
def get_course_details(db: Session, course_id: int, teacher_id: int):
    active_semester = db.query(Semester).filter(Semester.is_current == True).first()
    active_semester_id = active_semester.semester_id if active_semester else 1

    tc = db.query(TeacherCourse).filter(
        TeacherCourse.course_id == course_id,
        TeacherCourse.teacher_id == teacher_id,
        TeacherCourse.semester_id == active_semester_id
    ).first()

    if not tc: return None

    folders = db.query(Folder).filter(Folder.tc_id == tc.tc_id).all()
    
    student_count = db.query(StudentCourse).filter(
        StudentCourse.course_id == course_id,
        StudentCourse.semester_id == active_semester_id
    ).count()

    course = db.query(Course).filter(Course.course_id == course_id).first()
    level = db.query(Level).filter(Level.level_id == course.level_id).first()
    dept = db.query(Department).filter(Department.department_id == tc.department_id).first()

    results = []
    for folder in folders:
        exams = db.query(Exam).filter(Exam.folder_id == folder.folder_id).order_by(Exam.updated.desc().nulls_last()).all()
        results.append({
            "folder_id": folder.folder_id,
            "folder_name": folder.folder_name,
            "exams": [
                {
                    "exam_id": e.exam_id,
                    "title": e.exam_title,
                    "date": e.exam_date.strftime("%Y-%m-%d") if e.exam_date else "N/A",
                    "status": e.status,
                    "exam_type": e.exam_type or "manual",
                    "student_count": student_count
                } for e in exams
            ]
        })

    return {
        "course_name": course.course_name if course else "غير معروف",
        "department_name": dept.department_name if dept else "عام",
        "level_name": level.level_name if level else "غير معروف",
        "total_students": student_count,
        "folders": results
    }

# 3. إنشاء مادة جديدة 
def create_new_course_with_flexible_dept(db: Session, teacher_id: int, data: SubjectCreate):
    active_semester = db.query(Semester).filter(Semester.is_current == True).first()
    active_semester_id = active_semester.semester_id if active_semester else 1

    final_level_id = data.level_id
    if data.level_id == 0 and data.new_level_name:
        new_level = Level(level_name=data.new_level_name)
        db.add(new_level)
        db.commit()
        db.refresh(new_level)
        final_level_id = new_level.level_id

    dept_name = data.dept_name.strip() if data.dept_name and data.dept_name.strip() else "عام"
    dept = db.query(Department).filter(Department.department_name == dept_name).first()
    if not dept:
        dept = Department(department_name=dept_name)
        db.add(dept)
        db.commit()
        db.refresh(dept)

    existing_course = db.query(Course).filter(
        Course.course_name == data.name,
        Course.level_id == final_level_id
    ).first()

    if existing_course:
        new_course = existing_course
    else:
        new_course = Course(course_name=data.name, level_id=final_level_id)
        db.add(new_course)
        db.commit()
        db.refresh(new_course)

    existing_link = db.query(TeacherCourse).filter(
        TeacherCourse.teacher_id == teacher_id,
        TeacherCourse.course_id == new_course.course_id,
        TeacherCourse.department_id == dept.department_id,
        TeacherCourse.semester_id == active_semester_id
    ).first()

    if not existing_link:
        new_link = TeacherCourse(
            teacher_id=teacher_id,
            course_id=new_course.course_id,
            department_id=dept.department_id,
            semester_id=active_semester_id
        )
        db.add(new_link)
        db.commit()

    return new_course

# 4. إنشاء مجلد جديد
def create_new_folder(db: Session, name: str, course_id: int, teacher_id: int):
    active_semester = db.query(Semester).filter(Semester.is_current == True).first()
    active_semester_id = active_semester.semester_id if active_semester else 1

    tc = db.query(TeacherCourse).filter(
        TeacherCourse.course_id == course_id,
        TeacherCourse.teacher_id == teacher_id,
        TeacherCourse.semester_id == active_semester_id
    ).first()

    if tc:
        new_folder = Folder(folder_name=name, tc_id=tc.tc_id)
        db.add(new_folder)
        db.commit()
        db.refresh(new_folder)
        return new_folder
    return None

# 5. حذف مادة بالكامل (دالة جديدة)
def delete_entire_course(db: Session, course_id: int, teacher_id: int):
    active_semester = db.query(Semester).filter(Semester.is_current == True).first()
    active_semester_id = active_semester.semester_id if active_semester else 1

    # البحث عن الرابط بين المعلم والمادة في هذا الترم
    tc = db.query(TeacherCourse).filter(
        TeacherCourse.course_id == course_id,
        TeacherCourse.teacher_id == teacher_id,
        TeacherCourse.semester_id == active_semester_id
    ).first()

    if not tc:
        return False

    # بدلاً من حذف المادة من الجذور (قد تكون مرتبطة بمعلم آخر)، نقوم بحذف الرابط (TeacherCourse)
    # وقاعدة البيانات ستقوم بحذف المجلدات والاختبارات التابعة لهذا الرابط تلقائياً إذا كان الـ Cascade مفعلاً،
    # ولكن كإجراء آمن نحذف المجلدات يدوياً أولاً.
    
    folders = db.query(Folder).filter(Folder.tc_id == tc.tc_id).all()
    for f in folders:
        # يفضل استدعاء الدالة الخاصة بحذف المجلد أو حذف الاختبارات هنا
        db.query(Exam).filter(Exam.folder_id == f.folder_id).delete()
        db.delete(f)

    db.delete(tc)
    db.commit()
    return True