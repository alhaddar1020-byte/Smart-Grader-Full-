from sqlalchemy.orm import Session
from models.users import User
from models.profiles import Admin
from schemas.users import UserCreate, AdminProfileUpdate # تأكدي من مسار الاستيراد حسب مجلداتك

# ==========================================
# 1. عمليات الحسابات الأساسية (Users)
# ==========================================

def get_user_by_email(db: Session, email: str):
    """التحقق من وجود الإيميل مسبقاً في قاعدة البيانات"""
    return db.query(User).filter(User.email == email).first()

def create_user(db: Session, user_data: UserCreate):
    """إنشاء مستخدم جديد (لعملية التسجيل)"""
    new_user = User(
        full_name=user_data.full_name,
        email=user_data.email,
        phone_number=user_data.phone_number,
        password=user_data.password, # (ملاحظة: في المستقبل بنضيف لها تشفير هنا)
        is_active=user_data.is_active
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


# ==========================================
# 2. عمليات الملف الشخصي للمدير (Admin Profile)
# ==========================================

def get_admin_profile(db: Session):
    """جلب بيانات المدير من جدول users باستخدام الربط مع جدول admin"""
    # حالياً نجلب أول مدير في النظام (لاحقاً يتم الجلب حسب التوكن/تسجيل الدخول)
    admin_user = db.query(User).join(Admin, User.user_id == Admin.user_id).first()
    return admin_user

def update_admin_profile(db: Session, profile_data: AdminProfileUpdate):
    """تحديث بيانات المدير في جدول users"""
    admin_user = db.query(User).join(Admin, User.user_id == Admin.user_id).first()
    
    if admin_user:
        # التحديث باستخدام الـ Schema يضمن أمان وصحة البيانات
        admin_user.full_name = profile_data.full_name
        admin_user.email = profile_data.email
        admin_user.phone_number = profile_data.phone_number
        
        db.commit()
        db.refresh(admin_user)
        return admin_user
        
    return None