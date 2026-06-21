from sqlalchemy import Column, Integer, String, Date
from .base import Base

class VwTeacherExamsList(Base):
    __tablename__ = "vw_teacherexamslist"
    exam_id = Column(Integer, primary_key=True)
    teacher_id = Column(Integer)
    exam_title = Column(String)
    exam_date = Column(Date)
    number_of_questions = Column(Integer)
    level_name = Column(String)
    course_name = Column(String)
    status = Column(String)
    exam_type = Column(String)