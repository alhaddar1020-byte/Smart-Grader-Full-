# ==========================================
# ملف: profiles.py
# وظيفته: تفصيل الملفات الشخصية للمستخدمين والمواد.
# الجداول:
# - Student: التفاصيل الأكاديمية للطالب (الرقم الجامعي، قسمه، مستواه).
# - Teacher: ملف المعلم.
# - Admin: ملف مدير النظام.
# - Course: المواد الدراسية وارتباطها بالمستويات.
# ==========================================
from sqlalchemy import Column, Integer, String, ForeignKey, UniqueConstraint
from sqlalchemy.orm import relationship
from .base import Base

class Student(Base):
    __tablename__ = "student"
    student_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.user_id", ondelete="CASCADE"), unique=True, nullable=False)
    university_id = Column(String(50), unique=True, nullable=False)
    department_id = Column(Integer, ForeignKey("department.department_id"), nullable=False)
    level_id = Column(Integer, ForeignKey("level.level_id"), nullable=False)

class Teacher(Base):
    __tablename__ = "teacher"
    teacher_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.user_id", ondelete="CASCADE"), unique=True, nullable=False)

class Admin(Base):
    __tablename__ = "admin"
    admin_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.user_id", ondelete="CASCADE"), unique=True, nullable=False)

class Course(Base):
    __tablename__ = "courses"
    course_id = Column(Integer, primary_key=True, index=True)
    course_name = Column(String(100), nullable=False)
    level_id = Column(Integer, ForeignKey("level.level_id"), nullable=False)
    
    # قيد لمنع تكرار المادة في نفس المستوى
    __table_args__ = (UniqueConstraint('course_name', 'level_id', name='UQ_Course_Level'),)