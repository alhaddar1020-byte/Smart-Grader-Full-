from fastapi import Depends
from core.security import get_current_user_id
#ذا الرابط اللي بيسمح للطلاب والمدرسين يسوون حسابات جديدة):
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from db.database import get_db
from schemas.users import UserCreate
from models.users import User

router = APIRouter(prefix="/users", tags=["Users (إدارة المستخدمين)"], dependencies=[Depends(get_current_user_id)])

@router.post("/register")
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    # التأكد إذا الإيميل مسجل من قبل في الداتا بيس
    db_user = db.query(User).filter(User.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="الإيميل مسجل مسبقاً!")
    
    # إنشاء المستخدم الجديد
    new_user = User(
        full_name=user.full_name,
        email=user.email,
        phone_number=user.phone_number,
        password=user.password, # (ملاحظة: في المستقبل بنضيف لها تشفير)
        is_active=user.is_active
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    
    return {"message": "تم تسجيل الحساب بنجاح!", "user_id": new_user.user_id}