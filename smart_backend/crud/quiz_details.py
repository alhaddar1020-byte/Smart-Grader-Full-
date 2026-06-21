from sqlalchemy.orm import Session
from models.exams import Exam
from models.grading import Question, ExpectedAnswer, QuestionGroup # استدعاء QuestionGroup
from schemas.quiz_details import SaveQuizRequest
from datetime import datetime

def save_quiz_to_db(db: Session, req: SaveQuizRequest):
    try:
        # 1. إنشاء الاختبار في جدول Exam
        new_exam = Exam(
            folder_id=req.folder_id,
            exam_title=req.exam_title,
            number_of_questions=len(req.questions),
            total_marks=req.total_marks,
            passing_mark=req.passing_mark,
            allowed_time=req.allowed_time,
            status="Draft",
            exam_type="AI", # تمييز نوع الاختبار
            exam_date=datetime.strptime(req.exam_date, "%Y-%m-%d").date() if req.exam_date else datetime.utcnow().date(),
        )
        db.add(new_exam)
        db.flush() # للحصول على exam_id

        # 2. إنشاء مجموعة الأسئلة الإجبارية (التي كانت مفقودة)
        new_group = QuestionGroup(
            exam_id=new_exam.exam_id,
            group_title="أسئلة الاختبار (مراجعة الذكاء الاصطناعي)",
            group_type="General",
            group_total_mark=req.total_marks
        )
        db.add(new_group)
        db.flush() # للحصول على group_id

        # 3. حفظ كل سؤال في جدول Questions
        for index, q in enumerate(req.questions):
            new_q = Question(
                exam_id=new_exam.exam_id,
                group_id=new_group.group_id, # ربط السؤال بالمجموعة
                question_text=q.question_text,
                question_mark=q.grade,
                question_order=index + 1,
                question_type=q.question_type,
            )
            db.add(new_q)
            db.flush()

            # 4. حفظ الإجابة النموذجية في جدول ExpectedAnswer
            db.add(ExpectedAnswer(
                question_id=new_q.question_id,
                answer_text=q.model_answer,
                is_correct=True
            ))

            # 5. حفظ خيارات الـ MCQ إذا وجدت
            if q.question_type == 'mcq' and q.options:
                for i, opt in enumerate(q.options):
                    if i != q.correct_option_index:
                        db.add(ExpectedAnswer(
                            question_id=new_q.question_id,
                            answer_text=opt,
                            is_correct=False
                        ))
        
        db.commit()
        return new_exam.exam_id
    except Exception as e:
        db.rollback()
        raise e