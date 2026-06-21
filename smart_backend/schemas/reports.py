from pydantic import BaseModel
from typing import List

class SubjectPerformance(BaseModel):
    subject_name: str
    success_rate: float
    fail_rate: float

class TeacherUsage(BaseModel):
    rank: int
    teacher_name: str
    tasks_count: int
    progress: float  # 0.0 - 1.0

class ReportsSummary(BaseModel):
    total_students: int
    general_average: float
    active_teachers: int
    pass_percentage: float
    fail_percentage: float

class FullReportsResponse(BaseModel):
    summary: ReportsSummary
    subjects_performance: List[SubjectPerformance]
    teachers_usage: List[TeacherUsage]

    class Config:
        from_attributes = True