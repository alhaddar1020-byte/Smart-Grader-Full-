from pydantic import BaseModel
from typing import List, Optional

class GeneratedQuestion(BaseModel):
    question_id: int
    question_type: str       # mcq / tf / essay / match / fill
    question_text: str
    model_answer: str
    options: Optional[List[str]] = None
    correct_option_index: Optional[int] = None
    grade: float = 10.0
    keywords: Optional[List[str]] = []

class ExamGenerationResponse(BaseModel):
    success: bool
    message: str
    exam_title: str
    total_questions: int
    total_grade: float
    ai_accuracy: float = 98.5
    questions: List[GeneratedQuestion]
    keywords: List[str]

class SaveExamRequest(BaseModel):
    exam_title: str
    exam_date: Optional[str] = None
    folder_id: int
    total_marks: float
    passing_mark: float
    allowed_time: Optional[str] = "ساعة واحدة"
    questions: List[GeneratedQuestion]

class SaveExamResponse(BaseModel):
    success: bool
    message: str
    exam_id: Optional[int] = None

class FolderContextResponse(BaseModel):
    folder_id: int
    folder_name: str
    course_name: str
    specialization: str
    level: str
    teacher_name: str