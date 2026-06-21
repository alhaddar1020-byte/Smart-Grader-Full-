from pydantic import BaseModel, ConfigDict
from typing import List, Optional

# ==========================================
# Schemas for Department
# ==========================================
class DepartmentBase(BaseModel):
    department_name: str

class DepartmentCreate(DepartmentBase):
    pass

class DepartmentResponse(DepartmentBase):
    department_id: int
    model_config = ConfigDict(from_attributes=True)

# ==========================================
# Schemas for Level
# ==========================================
class LevelBase(BaseModel):
    level_name: str

class LevelResponse(LevelBase):
    level_id: int
    model_config = ConfigDict(from_attributes=True)

# ==========================================
# Schemas for Courses
# ==========================================
class CourseBase(BaseModel):
    course_name: str
    level_id: int

class CourseCreate(CourseBase):
    pass

class CourseResponse(CourseBase):
    course_id: int
    model_config = ConfigDict(from_attributes=True)


# ==========================================
# Schemas for Student Courses (AI Report)
# ==========================================
class SubjectAIReportResponse(BaseModel):
    # المتغيرات اللي تروح للفلاتر على شكل مصفوفة (عشان ترسمينها في البوكسات بسهولة)
    strengths: List[str] = []
    weaknesses: List[str] = []

    model_config = ConfigDict(from_attributes=True)