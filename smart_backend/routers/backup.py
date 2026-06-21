from fastapi import APIRouter, Depends, HTTPException, Request, Query
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from db.database import get_db

from core.security import get_current_user_id


from crud.backup import (
    get_backup_page_data,
    create_new_backup,
    get_backup_file,
    restore_backup_record,
    delete_backup_record
)
from schemas.backup import (
    BackupPageResponse,
    BackupCreateResponse,
    BackupDeleteResponse,
    BackupItem,
    RecentLog,
    SystemStats
)

router = APIRouter(prefix="/admin/backup", tags=["Backup"], dependencies=[Depends(get_current_user_id)])

@router.get("/page-data", response_model=BackupPageResponse)
def get_page_data(active_term: bool = Query(False, description="فلتر الترم النشط"), db: Session = Depends(get_db)):
    data = get_backup_page_data(db, active_term=active_term)
    return BackupPageResponse(
        system_stats=SystemStats(**data["system_stats"]),
        backups=[BackupItem(**b) for b in data["backups"]],
        recent_logs=[RecentLog(**log) for log in data["recent_logs"]],
        last_backup_date=data["last_backup_date"]
    )

@router.post("/create", response_model=BackupCreateResponse)
def create_backup(
    request: Request,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id) 
):
    ip_address = request.client.host

    result = create_new_backup(db, user_id=user_id, ip_address=ip_address)

    if not result["success"]:
        raise HTTPException(status_code=500, detail=result["message"])

    backup_data = result["backup"]

    return BackupCreateResponse(
        success=True,
        message=result["message"],
        backup=BackupItem(
            backup_id=backup_data["backup_id"],
            backup_date=backup_data["backup_date"],
            file_size=backup_data["file_size"],
            status=backup_data["status"],
            backup_type=backup_data["backup_type"]
        )
    )

@router.get("/download/{backup_id}")
def download_backup(backup_id: int, db: Session = Depends(get_db)):
    result = get_backup_file(db, backup_id)
    if not result["success"]:
        raise HTTPException(status_code=404, detail=result["message"])

    return FileResponse(
        path=result["path"],
        filename=result["filename"],
        media_type="application/octet-stream",
        headers={
            "Content-Disposition": f"attachment; filename={result['filename']}",
            "Access-Control-Expose-Headers": "Content-Disposition"
        }
    )

@router.post("/restore/{backup_id}")
def restore_backup(
    backup_id: int, 
    request: Request, 
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id) 
):
    ip_address = request.client.host

    result = restore_backup_record(db, backup_id, user_id=user_id, ip_address=ip_address)
    if not result["success"]:
        raise HTTPException(status_code=500, detail=result["message"])
    return {"success": True, "message": result["message"]}

@router.delete("/delete/{backup_id}", response_model=BackupDeleteResponse)
def delete_backup(backup_id: int, db: Session = Depends(get_db)):
    result = delete_backup_record(db, backup_id)
    if not result["success"]:
        raise HTTPException(status_code=404, detail=result["message"])
    return BackupDeleteResponse(success=True, message=result["message"])