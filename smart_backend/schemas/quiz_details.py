from pydantic import BaseModel
from typing import List, Optional

# السكيما الأساسية للسؤال
class QuizQuestionRequest(BaseModel):
    question_type: str
    question_text: str
    model_answer: str
    options: Optional[List[str]] = None
    correct_option_index: Optional[int] = None
    grade: float

# طلب حفظ الاختبار بالكامل
class SaveQuizRequest(BaseModel):
    folder_id: int
    exam_title: str
    exam_date: Optional[str] = None
    total_marks: float
    passing_mark: float               # تم إضافتها للتطابق مع الداتابيس وفلاتر
    allowed_time: Optional[str] = "ساعة واحدة" # تم إضافتها للتطابق مع الداتابيس
    questions: List[QuizQuestionRequest]