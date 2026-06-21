# from pydantic import BaseModel, ConfigDict
# from typing import Optional
# from datetime import datetime

# # ==========================================
# # Schemas for AnswerSheet (ورقة إجابة الطالب)
# # ==========================================
# class AnswerSheetBase(BaseModel):
#     exam_id: int
#     student_id: int

# class AnswerSheetCreate(AnswerSheetBase):
#     pass

# class AnswerSheetResponse(AnswerSheetBase):
#     sheet_id: int
#     status: str
#     total_earned_mark: float
#     uploaded_at: datetime
#     model_config = ConfigDict(from_attributes=True)

# # ==========================================
# # Schemas for Report (تقرير الذكاء الاصطناعي النهائي)
# # ==========================================
# class ReportBase(BaseModel):
#     sheet_id: int
#     academic_description: Optional[str] = None
#     strengths: Optional[str] = None
#     areas_of_improvement: Optional[str] = None

# class ReportCreate(ReportBase):
#     pass

# class ReportResponse(ReportBase):
#     report_id: int
#     generated_at: datetime
#     model_config = ConfigDict(from_attributes=True)

from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime

# ==========================================
# Schemas for AnswerSheet (ورقة إجابة الطالب)
# ==========================================
class AnswerSheetBase(BaseModel):
    exam_id: int
    student_id: int

class AnswerSheetCreate(AnswerSheetBase):
    pass

class AnswerSheetResponse(AnswerSheetBase):
    sheet_id: int
    status: str
    total_earned_mark: float
    uploaded_at: datetime
    model_config = ConfigDict(from_attributes=True)

# ==========================================
# Schemas for Report (تقرير الذكاء الاصطناعي النهائي)
# ==========================================
class ReportBase(BaseModel):
    sheet_id: int
    academic_description: Optional[str] = None
    strengths: Optional[str] = None
    areas_of_improvement: Optional[str] = None

class ReportCreate(ReportBase):
    pass

class ReportResponse(ReportBase):
    report_id: int
    generated_at: datetime
    model_config = ConfigDict(from_attributes=True)