from sqlalchemy.orm import Session
from models.exams import Exam
from datetime import date

def create_exam(db: Session, folder_id: int, title: str, num_questions: int, total_marks: float, passing_mark: float, allowed_time: str):
    # إنشاء الاختبار (يكافئ INSERT في الوورد)
    new_exam = Exam(
        folder_id=folder_id,
        exam_title=title,
        number_of_questions=num_questions,
        total_marks=total_marks,
        passing_mark=passing_mark,
        allowed_time=allowed_time,
        status="Draft",
        exam_date=date.today()
    )
    db.add(new_exam)
    db.commit()
    db.refresh(new_exam) # (يكافئ SCOPE_IDENTITY في الوورد لإرجاع الـ ID الجديد)
    
    return new_exam.exam_id