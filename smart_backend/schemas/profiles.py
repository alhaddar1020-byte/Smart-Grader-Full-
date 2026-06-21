from pydantic import BaseModel, ConfigDict
from typing import Optional

# ==========================================
# Schemas for Student
# ==========================================
class StudentBase(BaseModel):
    user_id: int
    university_id: str
    department_id: int
    level_id: int

class StudentCreate(StudentBase):
    pass

class StudentResponse(StudentBase):
    student_id: int
    model_config = ConfigDict(from_attributes=True)

# ==========================================
# Schemas for Teacher & Admin
# ==========================================
class TeacherBase(BaseModel):
    user_id: int

class TeacherCreate(TeacherBase):
    pass

class TeacherResponse(TeacherBase):
    teacher_id: int
    model_config = ConfigDict(from_attributes=True)

class AdminBase(BaseModel):
    user_id: int

class AdminCreate(AdminBase):
    pass

class AdminResponse(AdminBase):
    admin_id: int
    model_config = ConfigDict(from_attributes=True)