# from pydantic import BaseModel, ConfigDict  # تأكدي من إضافة ConfigDict هنا
# from typing import List, Optional
# # قالب بيانات المادة الواحدة (الذي يظهر في الشبكة)
# class CourseMaterialResponse(BaseModel):
#     course_id: int
#     course_name: str
#     department_name: str
#     level_name: str
#     total_folders: int 
#     total_exams: int
    
#     model_config = ConfigDict(from_attributes=True)

# # قالب الرد الكامل (قائمة المواد + الإحصائيات الأربعة للداشبورد العلوي)
# class TeacherMaterialsWrapper(BaseModel):
#     courses: List[CourseMaterialResponse]
#     total_students: int
#     total_corrected_papers: int
#     total_exams: int
#     total_drafts: int

# # أضفت لكِ هذا القالب الجديد لاستخدامه في عملية الإضافة (POST)
# class CourseCreateRequest(BaseModel):
#     name: str
#     dept_name: str  # هنا نستخدم الاسم وليس الـ ID لضمان المرونة
#     level_id: int

# class ExamDetail(BaseModel):
#     exam_id: int
#     title: str
#     date: str
#     status: str
#     student_count: int

# class FolderDetail(BaseModel):
#     folder_id: int
#     folder_name: str
#     exams: List[ExamDetail]

# class CourseFullDetailResponse(BaseModel):
#     course_name: str
#     total_students: int
#     department_name: str 
#     level_name: str
#     folders: List[FolderDetail]
# class SubjectCreate(BaseModel):
#     name: str              # اسم المادة
#     dept_name: str         # اسم القسم
#     level_id: Optional[int] = None      # الـ ID المختار من القائمة (ممكن يكون null)
#     new_level_name: Optional[str] = None # الاسم المدخل إذا اختار "أخرى" (ممكن يكون null)





from pydantic import BaseModel, ConfigDict
from typing import List, Optional

# ==========================================
# Schemas for Input (طلبات الإضافة / POST)
# ==========================================
class SubjectCreate(BaseModel):
    name: str
    dept_name: str
    level_id: Optional[int] = None
    new_level_name: Optional[str] = None

# ==========================================
# Schemas for Output (ردود السيرفر / GET)
# ==========================================

# 1. تفاصيل المادة الواحدة (في الصفحة الرئيسية)
class CourseMaterialResponse(BaseModel):
    course_id: int              # رجعناها
    course_name: str            # رجعناها
    department_name: str        # رجعناها
    level_name: str             # رجعناها
    total_folders: int          # رجعناها
    total_exams: int            # رجعناها
    
    model_config = ConfigDict(from_attributes=True)

# 2. الرد الشامل (مواد + إحصائيات علوية)
class TeacherMaterialsWrapper(BaseModel):
    total_students: int         # رجعناها
    total_corrected_papers: int # رجعناها
    total_exams: int            # رجعناها
    total_drafts: int           # رجعناها
    courses: List[CourseMaterialResponse]

# 3. تفاصيل الاختبار الواحد (داخل المجلد)
class ExamDetail(BaseModel):
    exam_id: int
    title: str
    date: str
    status: str
    exam_type: str
    student_count: int

# 4. تفاصيل المجلد الواحد (داخله اختبارات)
class FolderDetail(BaseModel):
    folder_id: int
    folder_name: str
    exams: List[ExamDetail]

# 5. التفاصيل الكاملة للمادة (في الشاشة الداخلية)
class CourseFullDetailResponse(BaseModel):
    course_name: str
    department_name: str 
    level_name: str
    total_students: int
    folders: List[FolderDetail]