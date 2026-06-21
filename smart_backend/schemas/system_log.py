from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class LogItem(BaseModel):
    log_id: int
    user_name: str
    user_role: str
    action_taken: str
    ip_address: Optional[str] = None
    action_date_time: datetime

    class Config:
        from_attributes = True

class LogsResponse(BaseModel):
    total_count: int
    logs: List[LogItem]

class LogsSummary(BaseModel):
    total_actions: int
    login_records: int
    today_count: int