from fastapi import Depends
from core.security import get_current_user_id
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List
from db.database import get_db
from schemas.users_management import UserListResponse, UserUpdateRequest
from crud.users_management import get_all_users_from_db, update_user_in_db, delete_user_from_db

router = APIRouter(prefix="/admin/users", tags=["Users Management"], dependencies=[Depends(get_current_user_id)])

@router.get("/list", response_model=List[UserListResponse])
def get_users_list(active_only: bool = Query(False), db: Session = Depends(get_db)):
    try:
        # تمرير المتغير للدالة
        return get_all_users_from_db(db, active_only=active_only)
    except Exception as e:
        raise HTTPException(status_code=500, detail="error_server_failed")

@router.put("/update/{target_id}")
def update_user(target_id: str, data: UserUpdateRequest, db: Session = Depends(get_db)):
    success = update_user_in_db(db, target_id, data)
    if not success:
        raise HTTPException(status_code=404, detail="error_user_not_found")
    return {"message": "update_success"}

@router.delete("/delete/{target_id}")
def delete_user(target_id: str, db: Session = Depends(get_db)):
    success = delete_user_from_db(db, target_id)
    if not success:
        raise HTTPException(status_code=404, detail="error_user_not_found")
    return {"message": "delete_success"}