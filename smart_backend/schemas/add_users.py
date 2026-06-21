from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

class UserManualCreate(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    academic_id: Optional[str] = None  # رقم القيد (للطالب فقط)
    phone_number: Optional[str] = None
    category: str  # "الطلاب"، "المعلمين"، "الإدارة"

class ImportHistoryResponse(BaseModel):
    id: int
    file_or_name: str
    upload_date: datetime
    records_count: int
    status: str
    is_success: bool

    class Config:
        from_attributes = True