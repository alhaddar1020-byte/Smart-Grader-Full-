# ==========================================
# ملف: exams.py
# وظيفته: إدارة العمليات الأكاديمية، التكاليف، وإنشاء الاختبارات.
# الجداول:
# - Semester: الأترام الدراسية وتحديد الترم النشط.
# - TeacherCourse: التكاليف (ربط المعلم بالمادة والقسم والترم).
# - Folder: المجلدات التنظيمية للاختبارات.
# - Exam: الإعدادات الأساسية للاختبار (العنوان، الدرجة، عدد الأسئلة).
# ==========================================

from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, Date, Numeric, UniqueConstraint, CheckConstraint,DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from .base import Base
from sqlalchemy.sql import func

class Semester(Base):
    __tablename__ = "semesters"
    semester_id = Column(Integer, primary_key=True, index=True)
    semester_name = Column(String(100), nullable=False)
    academic_year = Column(String(20), nullable=False)
    start_date = Column(Date, nullable=True)
    end_date = Column(Date, nullable=True)
    is_current = Column(Boolean, default=False)

class TeacherCourse(Base):
    __tablename__ = "teacher_courses"
    tc_id = Column(Integer, primary_key=True, index=True)
    teacher_id = Column(Integer, ForeignKey("teacher.teacher_id", ondelete="CASCADE"), nullable=False, index=True)
    course_id = Column(Integer, ForeignKey("courses.course_id", ondelete="CASCADE"), nullable=False)
    department_id = Column(Integer, ForeignKey("department.department_id", ondelete="CASCADE"), nullable=False)
    semester_id = Column(Integer, ForeignKey("semesters.semester_id", ondelete="CASCADE"), nullable=False)

    __table_args__ = (
        UniqueConstraint('teacher_id', 'course_id', 'department_id', 'semester_id', name='UQ_Teacher_Course_Dept_Semester'),
    )

class Folder(Base):
    __tablename__ = "folder"
    folder_id = Column(Integer, primary_key=True, index=True)
    folder_name = Column(String(100), nullable=False)
    tc_id = Column(Integer, ForeignKey("teacher_courses.tc_id", ondelete="CASCADE"), nullable=False)

class Exam(Base):
    __tablename__ = "exam"
    exam_id = Column(Integer, primary_key=True, index=True)
    exam_title = Column(String(150), nullable=False)
    number_of_questions = Column(Integer, nullable=False)
    total_marks = Column(Numeric(5, 2), nullable=False)
    passing_mark = Column(Numeric(5, 2), nullable=False)
    exam_date = Column(Date, default=datetime.utcnow)
    allowed_time = Column(String(50), nullable=True)
    status = Column(String(50), default="Draft")
    folder_id = Column(Integer, ForeignKey("folder.folder_id", ondelete="CASCADE"), nullable=False, index=True)
    updated = Column(DateTime(timezone=True), default=func.now(), onupdate=func.now())    # تحديد نوع الاختبار بقيمة افتراضية
    exam_type = Column(String(20), default="manual", nullable=False)

    # حماية إضافية على مستوى قاعدة البيانات لرفض أي قيمة غير المحددة
    __table_args__ = (
        CheckConstraint("exam_type IN ('manual', 'ai')", name='chk_exam_type'),
    )