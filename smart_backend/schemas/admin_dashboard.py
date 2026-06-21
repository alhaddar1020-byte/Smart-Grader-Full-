from pydantic import BaseModel
from typing import List

# 1. الإحصائيات العلوية (المربعات الأربعة)
# class TopStats(BaseModel):
#     total_students: int
#     students_percentage: float  # نسبة التغير للطلاب
#     total_teachers: int
#     teachers_percentage: float   # نسبة التغير للمعلمين
#     total_exams: int
#     exams_percentage: float      # نسبة التغير للاختبارات
#     active_users: int
#     active_users_percentage: float

class TopStats(BaseModel):
    total_students: int
    students_percentage: str  # أضفنا هذا
    total_teachers: int
    teachers_percentage: str   # وهذا
    total_exams: int
    exams_percentage: str      # وهذا
    active_users: int
    active_users_percentage: str # وهذا

# 2. إحصائيات الأداء السفلية (النسب المئوية)
class PerformanceStats(BaseModel):
    exams_completion_rate: float  # نسبة إنجاز الاختبارات
    success_rate: float           # معدل النجاح
    average_score: float          # متوسط الدرجات

# 3. التنبيهات وسجل النظام
class AlertItem(BaseModel):
    title: str
    subtitle: str
    time_ago: str
    icon_type: str  # القيم المتوقعة لتحديد شكل الأيقونة: security, storage, backup

# 4. الطرد النهائي (يجمع كل البيانات في استجابة واحدة مع بيانات الرسم البياني)
class AdminDashboardResponse(BaseModel):
    top_stats: TopStats
    performance_stats: PerformanceStats
    alerts: List[AlertItem]
    system_usage_chart: List[float]  # مصفوفة الأرقام لتغذية مكتبة الشارت في الفلاتر