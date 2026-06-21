from fastapi import Depends
from core.security import get_current_user_id
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session
from typing import List
from db.database import get_db
from schemas.add_users import UserManualCreate, ImportHistoryResponse
from crud.add_users import add_manual_user, process_excel_upload, get_import_history_from_db, delete_history_record

router = APIRouter(prefix="/admin/import", tags=["Users Import & Addition"], dependencies=[Depends(get_current_user_id)])

@router.post("/manual")
def add_user_manually(data: UserManualCreate, db: Session = Depends(get_db)):
    success, message = add_manual_user(db, data)
    if not success:
        raise HTTPException(status_code=400, detail=message)
    return {"message": message}

@router.post("/excel")
async def upload_users_excel(
    file: UploadFile = File(...), 
    category: str = Form(...), 
    db: Session = Depends(get_db)
):
    if not file.filename.endswith(('.xls', '.xlsx', '.csv')):
        raise HTTPException(status_code=400, detail="error_unsupported_file_format")
    
    file_bytes = await file.read()
    success, message = process_excel_upload(db, file_bytes, file.filename, category)
    
    if not success:
        raise HTTPException(status_code=400, detail=message)
    return {"message": message}

@router.get("/history")
def get_import_history(db: Session = Depends(get_db)):
    return get_import_history_from_db(db)

@router.delete("/history/{record_id}")
def delete_history(record_id: int, db: Session = Depends(get_db)):
    success = delete_history_record(db, record_id)
    if not success:
        raise HTTPException(status_code=404, detail="error_record_not_found")
    return {"message": "KEY_DELETED_SUCCESSFULLY"}