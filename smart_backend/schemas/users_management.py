from pydantic import BaseModel

# نموذج إرسال البيانات للفرونت إند
class UserListResponse(BaseModel):
    id: str        # الرقم الأكاديمي
    name: str      # الاسم الكامل
    role: str      # 'ADMIN', 'TEACHER', 'STUDENT'
    status: str    # 'ACTIVE', 'INACTIVE'

    class Config:
        from_attributes = True

# نموذج استقبال التعديلات من الفرونت إند
class UserUpdateRequest(BaseModel):
    id: str        # الرقم الأكاديمي
    name: str
    role: str
    status: str