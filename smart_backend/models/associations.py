# ==========================================
# ملف: associations.py
# وظيفته: يحتوي على "جداول الربط" (Many-to-Many) التي تربط الجداول ببعضها.
# الجداول: 
# - user_roles: ربط المستخدمين بالصلاحيات.
# - course_departments: ربط المواد بالأقسام.
# - exam_departments: ربط الاختبارات بالأقسام.
# ==========================================

from sqlalchemy import Table, Column, Integer, ForeignKey
from .base import Base

user_roles = Table(
    "user_roles", Base.metadata,
    Column("user_id", Integer, ForeignKey("users.user_id", ondelete="CASCADE"), primary_key=True),
    Column("role_id", Integer, ForeignKey("roles.role_id"), primary_key=True)
)

course_departments = Table(
    "course_departments", Base.metadata,
    Column("course_id", Integer, ForeignKey("courses.course_id", ondelete="CASCADE"), primary_key=True),
    Column("department_id", Integer, ForeignKey("department.department_id", ondelete="CASCADE"), primary_key=True)
)

exam_departments = Table(
    "exam_departments", Base.metadata,
    Column("exam_id", Integer, ForeignKey("exam.exam_id", ondelete="CASCADE"), primary_key=True),
    Column("department_id", Integer, ForeignKey("department.department_id"), primary_key=True)
)