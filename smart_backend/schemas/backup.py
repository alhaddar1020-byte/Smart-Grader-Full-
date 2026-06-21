from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime


class BackupItem(BaseModel):
    backup_id: int
    backup_date: datetime
    file_size: Optional[str] = "N/A"
    status: Optional[str] = "مكتمل"
    backup_type: Optional[str] = "كامل"

    class Config:
        from_attributes = True


class BackupCreateResponse(BaseModel):
    success: bool
    message: str
    backup: Optional[BackupItem] = None


class BackupDeleteResponse(BaseModel):
    success: bool
    message: str


class RecentLog(BaseModel):
    log_id: int
    event: str
    log_type: str   # success | error | info
    time_ago: str

    class Config:
        from_attributes = True


class SystemStats(BaseModel):
    uptime: str
    db_size: str
    total_backups: int
    system_status: str


class BackupPageResponse(BaseModel):
    system_stats: SystemStats
    backups: List[BackupItem]
    recent_logs: List[RecentLog]
    last_backup_date: Optional[str] = None