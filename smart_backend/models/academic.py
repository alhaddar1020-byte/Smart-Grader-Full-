# ==========================================
# ملف: academic.py
# وظيفته: تعريف الكيانات الأكاديمية الثابتة في الكلية.
# الجداول:
# - Department: أقسام الكلية (تقنية معلومات، علوم حاسوب..).
# - Level: المستويات الدراسية.
# - StudentCourse: سجل تسجيل الطلاب في المواد الدراسية.
# ==========================================

# ==========================================
# ملف: academic.py
# وظيفته: تعريف الكيانات الأكاديمية الثابتة في الكلية.
# ==========================================

from sqlalchemy import Column, Integer, String, ForeignKey, UniqueConstraint,DateTime
from sqlalchemy.orm import relationship
from .base import Base

class Department(Base):
    __tablename__ = "department"
    department_id = Column(Integer, primary_key=True, index=True)
    department_name = Column(String(100), nullable=False)

class Level(Base):
    __tablename__ = "level"
    level_id = Column(Integer, primary_key=True, index=True)
    level_name = Column(String(50), nullable=False)

class StudentCourse(Base):
    __tablename__ = "student_courses"
    sc_id = Column(Integer, primary_key=True, index=True)
    student_id = Column(Integer, ForeignKey("student.student_id", ondelete="CASCADE"), nullable=False, index=True) # فهرس
    course_id = Column(Integer, ForeignKey("courses.course_id", ondelete="CASCADE"), nullable=False)
    semester_id = Column(Integer, ForeignKey("semesters.semester_id", ondelete="CASCADE"), nullable=False)
    subject_strengths = Column(String, nullable=True) 
    subject_weaknesses = Column(String, nullable=True)
    last_ai_update = Column(DateTime, nullable=True)
    
    # قيد لمنع تسجيل الطالب في نفس المادة لنفس الترم أكثر من مرة
    __table_args__ = (UniqueConstraint('student_id', 'course_id', 'semester_id', name='UQ_Student_Course_Semester'),)