from fastapi import Depends
from core.security import get_current_user_id
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db.database import get_db
from schemas.quiz_details import SaveQuizRequest
from crud.quiz_details import save_quiz_to_db

router = APIRouter(prefix="/teacher/quiz", tags=["Quiz Details"], dependencies=[Depends(get_current_user_id)])

@router.post("/save")
def save_quiz(req: SaveQuizRequest, db: Session = Depends(get_db)):
    try:
        exam_id = save_quiz_to_db(db, req)
        return {"success": True, "message": "تم حفظ الاختبار بنجاح", "exam_id": exam_id}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"حدث خطأ أثناء الحفظ: {str(e)}")