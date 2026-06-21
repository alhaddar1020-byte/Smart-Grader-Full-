# ==========================================
# ملف: grading.py
# وظيفته: القلب النابض للنظام (إدارة أوراق الطلاب، الأسئلة، وتصحيح الذكاء الاصطناعي).
# ==========================================

from sqlalchemy import Column, Integer, String, ForeignKey, Numeric, DateTime, Boolean, UniqueConstraint, CheckConstraint
from sqlalchemy.orm import relationship
from datetime import datetime
from .base import Base

class AnswerSheet(Base):
    __tablename__ = "answer_sheet"
    sheet_id = Column(Integer, primary_key=True, index=True)
    exam_id = Column(Integer, ForeignKey("exam.exam_id", ondelete="CASCADE"), nullable=False)
    student_id = Column(Integer, ForeignKey("student.student_id", ondelete="CASCADE"), nullable=False, index=True)
    status = Column(String(50), default="Pending")
    is_published = Column(Boolean, default=False)
    total_earned_mark = Column(Numeric(5, 2), default=0)
    uploaded_at = Column(DateTime, default=datetime.utcnow)
    
    __table_args__ = (
        UniqueConstraint('student_id', 'exam_id', name='UQ_Student_Exam'),
        CheckConstraint('total_earned_mark >= 0', name='CHK_TotalEarnedMark'),
    )

class QuestionGroup(Base):
    __tablename__ = "question_groups"
    group_id = Column(Integer, primary_key=True, index=True)
    # 👇 تم حذف حرف الـ s من هنا (صارت exam.exam_id) 👇
    exam_id = Column(Integer, ForeignKey("exam.exam_id", ondelete="CASCADE"))
    group_title = Column(String)
    group_order = Column(Integer)
    group_total_mark = Column(Numeric)
    group_numbering_style = Column(String, default="numbers")

class QuestionSection(Base):
    __tablename__ = "question_sections"
    section_id = Column(Integer, primary_key=True, index=True)
    group_id = Column(Integer, ForeignKey("question_groups.group_id", ondelete="CASCADE"))
    section_title = Column(String)
    section_type = Column(String)
    section_order = Column(Integer)
    section_total_mark = Column(Numeric)
    section_numbering_style = Column(String, default="letters_ar")

class Question(Base):
    __tablename__ = "questions"
    question_id = Column(Integer, primary_key=True, index=True)
    # 👇 تم حذف حرف الـ s من هنا أيضاً (صارت exam.exam_id) 👇
    exam_id = Column(Integer, ForeignKey("exam.exam_id", ondelete="CASCADE"))
    question_numbering_style = Column(String, default="numbers") 
    
    section_id = Column(Integer, ForeignKey("question_sections.section_id", ondelete="CASCADE"), nullable=True) 
    
    question_text = Column(String)
    question_mark = Column(Numeric)
    question_order = Column(Integer)
    question_type = Column(String)
    
    __table_args__ = (
        CheckConstraint('question_mark >= 0', name='CHK_QuestionMark'),
    )

class StudentAnswer(Base):
    __tablename__ = "student_answers"
    answer_id = Column(Integer, primary_key=True, index=True)
    sheet_id = Column(Integer, ForeignKey("answer_sheet.sheet_id", ondelete="CASCADE"), nullable=False, index=True)
    question_id = Column(Integer, ForeignKey("questions.question_id"), nullable=False)
    extracted_text = Column(String, nullable=True)
    ai_mark = Column(Numeric(5, 2), nullable=False, default=0)
    teacher_mark = Column(Numeric(5, 2), nullable=True)
    confidence_score = Column(Numeric(5, 2), nullable=True)
    ai_feedback = Column(String, nullable=True)

class Report(Base):
    __tablename__ = "report"
    report_id = Column(Integer, primary_key=True, index=True)
    sheet_id = Column(Integer, ForeignKey("answer_sheet.sheet_id", ondelete="CASCADE"), unique=True, nullable=False)
    strengths = Column(String, nullable=True)
    areas_of_improvement = Column(String, nullable=True)
    academic_description = Column(String, nullable=True)
    generated_at = Column(DateTime, default=datetime.utcnow)

class SheetImage(Base):
    __tablename__ = "sheet_images"
    image_id = Column(Integer, primary_key=True, index=True)
    sheet_id = Column(Integer, ForeignKey("answer_sheet.sheet_id", ondelete="CASCADE"), nullable=False, index=True)
    image_path = Column(String(500), nullable=False)
    page_number = Column(Integer, nullable=False)

class ExpectedAnswer(Base):
    __tablename__ = "expected_answers"
    expected_answer_id = Column(Integer, primary_key=True, index=True)
    question_id = Column(Integer, ForeignKey("questions.question_id", ondelete="CASCADE"), nullable=False)
    answer_text = Column(String, nullable=False)
    is_correct = Column(Boolean, default=False)
    keywords = Column(String, nullable=True)
    match_text = Column(String, nullable=True)