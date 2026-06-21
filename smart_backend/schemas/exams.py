# from pydantic import BaseModel, ConfigDict
# from typing import Optional
# from datetime import date

# # ==========================================
# # Schemas for Semester (الأترام)
# # ==========================================
# class SemesterBase(BaseModel):
#     semester_name: str
#     academic_year: str
#     start_date: Optional[date] = None
#     end_date: Optional[date] = None
#     is_current: bool = False

# class SemesterCreate(SemesterBase):
#     pass

# class SemesterResponse(SemesterBase):
#     semester_id: int
#     model_config = ConfigDict(from_attributes=True)

# # ==========================================
# # Schemas for Exam (الاختبارات)
# # ==========================================
# class ExamBase(BaseModel):
#     exam_title: str
#     number_of_questions: int
#     total_marks: float
#     passing_mark: float
#     allowed_time: Optional[str] = None
#     folder_id: int
#     exam_type: str = "manual" # 👈 أضفنا نوع الاختبار هنا

# class ExamCreate(ExamBase):
#     pass

# class ExamResponse(ExamBase):
#     exam_id: int
#     status: str
#     exam_date: date
#     model_config = ConfigDict(from_attributes=True)


# # ==========================================
# # Schema الجديدة لصفحة إدارة الاختبارات (View)
# # ==========================================
# class ExamRead(BaseModel):
#     exam_id: int
#     exam_title: str
#     exam_date: Optional[date] = None
#     number_of_questions: int
#     level_name: str
#     course_name: str
#     status: str
#     exam_type: str # 👈 أضفناها هنا (مهم جداً عشان الفلاتر يعرف يفرز الاختبارات في التابات)

#     model_config = ConfigDict(from_attributes=True)

from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import date

# ==========================================
# 1. Schemas for Semester (الأترام الدراسية)
# ==========================================
class SemesterBase(BaseModel):
    semester_name: str
    academic_year: str
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    is_current: bool = False

class SemesterCreate(SemesterBase):
    pass

class SemesterResponse(SemesterBase):
    semester_id: int
    model_config = ConfigDict(from_attributes=True)


# ==========================================
# 2. Schemas for TeacherCourse (التكاليف الأكاديمية)
# ==========================================
class TeacherCourseBase(BaseModel):
    teacher_id: int
    course_id: int
    department_id: int
    semester_id: int

class TeacherCourseCreate(TeacherCourseBase):
    pass

class TeacherCourseResponse(TeacherCourseBase):
    tc_id: int
    model_config = ConfigDict(from_attributes=True)


# ==========================================
# 3. Schemas for Folder (المجلدات التنظيمية)
# ==========================================
class FolderBase(BaseModel):
    folder_name: str
    tc_id: int

class FolderCreate(FolderBase):
    pass

class FolderResponse(FolderBase):
    folder_id: int
    model_config = ConfigDict(from_attributes=True)


# ==========================================
# 4. Schemas for Exam (الاختبارات)
# ==========================================
class ExamBase(BaseModel):
    exam_title: str
    number_of_questions: int
    total_marks: float
    passing_mark: float
    allowed_time: Optional[str] = None
    folder_id: int
    exam_type: str = "manual" # 👈 الإضافة الجديدة الخاصة بنوع الاختبار

class ExamCreate(ExamBase):
    pass

class ExamResponse(ExamBase):
    exam_id: int
    exam_date: date
    status: str
    model_config = ConfigDict(from_attributes=True)


# ==========================================
# 5. Schema الجديدة لصفحة إدارة الاختبارات (View)
# ==========================================
class ExamRead(BaseModel):
    exam_id: int
    exam_title: str
    exam_date: Optional[date] = None
    number_of_questions: int
    level_name: str
    course_name: str
    status: str
    exam_type: str # 👈 الإضافة الجديدة لدعم فرز التابات في فلاتر

    model_config = ConfigDict(from_attributes=True)