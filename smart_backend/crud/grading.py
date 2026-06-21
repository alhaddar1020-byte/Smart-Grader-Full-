# from sqlalchemy.orm import Session
# from models.grading import AnswerSheet, Report
# from datetime import datetime

# def save_ai_grading(db: Session, sheet_id: int, total_score: float, description: str, strengths: str = None, weaknesses: str = None):
#     try:
#         # 1. تحديث حالة الورقة والدرجة (سطر 305 في الوورد)
#         sheet = db.query(AnswerSheet).filter(AnswerSheet.sheet_id == sheet_id).first()
#         if sheet:
#             sheet.status = 'Graded'
#             sheet.total_earned_mark = total_score
            
#             # 2. تحديث أو إدخال التقرير الذكي (سطر 308 في الوورد)
#             report = db.query(Report).filter(Report.sheet_id == sheet_id).first()
#             if report:
#                 report.academic_description = description
#                 report.strengths = strengths
#                 report.areas_of_improvement = weaknesses
#                 report.generated_at = datetime.utcnow()
#             else:
#                 new_report = Report(
#                     sheet_id=sheet_id,
#                     academic_description=description,
#                     strengths=strengths,
#                     areas_of_improvement=weaknesses
#                 )
#                 db.add(new_report)
                
#             db.commit() # تأكيد الحفظ
#             return True
#         return False
#     except Exception as e:
#         db.rollback() # التراجع فوراً لو صار خطأ مثل الوورد
#         raise e
from sqlalchemy.orm import Session
from models.grading import AnswerSheet, Report
from datetime import datetime

def save_ai_grading(db: Session, sheet_id: int, total_score: float, description: str, strengths: str = None, weaknesses: str = None):
    try:
        # 1. تحديث حالة الورقة والدرجة (سطر 305 في الوورد)
        sheet = db.query(AnswerSheet).filter(AnswerSheet.sheet_id == sheet_id).first()
        if sheet:
            sheet.status = 'Graded'
            sheet.total_earned_mark = total_score
            
            # 2. تحديث أو إدخال التقرير الذكي (سطر 308 في الوورد)
            report = db.query(Report).filter(Report.sheet_id == sheet_id).first()
            if report:
                report.academic_description = description
                report.strengths = strengths
                report.areas_of_improvement = weaknesses
                report.generated_at = datetime.utcnow()
            else:
                new_report = Report(
                    sheet_id=sheet_id,
                    academic_description=description,
                    strengths=strengths,
                    areas_of_improvement=weaknesses
                )
                db.add(new_report)
                
            db.commit() # تأكيد الحفظ
            return True
        return False
    except Exception as e:
        db.rollback() # التراجع فوراً لو صار خطأ مثل الوورد
        raise e