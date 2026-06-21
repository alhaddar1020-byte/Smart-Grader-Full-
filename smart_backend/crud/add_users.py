from sqlalchemy.orm import Session
from sqlalchemy import func
from models.users import User, Role
from models.profiles import Student, Teacher, Admin
from models.settings import ImportHistory
from models.academic import Department, Level
from models.associations import user_roles
from schemas.add_users import UserManualCreate
import pandas as pd
import io

def _get_role_id_by_category(db: Session, category_key: str):
    # نعتمد على المفاتيح الإنجليزية الثابتة
    role_map = {"STUDENT": "Student", "TEACHER": "Teacher", "ADMIN": "Admin"}
    target_name = role_map.get(category_key, "Student")
    role = db.query(Role).filter(func.upper(Role.role_name) == target_name.upper()).first()
    return role.role_id if role else 3

def add_manual_user(db: Session, data: UserManualCreate):
    try:
        user = db.query(User).filter(User.email == data.email).first()
        
        # إذا تمت الإضافة اليدوية وكان المستخدم موجوداً، لن نظهر خطأ بل سنقوم بتحديث اسمه (كمثال على التحديث اليدوي)
        if user:
            user.full_name = f"{data.first_name} {data.last_name}".strip()
            user.phone_number = data.phone_number
            db.commit()
            return True, "KEY_USER_ADDED_SUCCESSFULLY" # نستخدم نفس المفتاح لتظهر رسالة نجاح في الواجهة

        # إذا لم يكن موجوداً، ننشئ حساباً جديداً
        new_user = User(
            full_name=f"{data.first_name} {data.last_name}".strip(),
            email=data.email,
            phone_number=data.phone_number,
            password=data.academic_id if data.category == "STUDENT" else "12345678",
            is_active=True
        )
        db.add(new_user)
        db.flush()

        role_id = _get_role_id_by_category(db, data.category)
        if role_id:
            db.execute(user_roles.insert().values(user_id=new_user.user_id, role_id=role_id))

        if data.category == "STUDENT":
            default_dept = db.query(Department).first()
            default_level = db.query(Level).first()
            new_student = Student(
                user_id=new_user.user_id,
                university_id=data.academic_id,
                department_id=default_dept.department_id if default_dept else 1,
                level_id=default_level.level_id if default_level else 1
            )
            db.add(new_student)
        elif data.category == "TEACHER":
            db.add(Teacher(user_id=new_user.user_id))
        elif data.category == "ADMIN":
            db.add(Admin(user_id=new_user.user_id))

        db.add(ImportHistory(file_name=f"{data.first_name} {data.last_name}", record_count=1, import_type="KEY_MANUAL"))
        db.commit()
        return True, "KEY_USER_ADDED_SUCCESSFULLY"
    except Exception as e:
        db.rollback()
        return False, "KEY_SERVER_ERROR"

def process_excel_upload(db: Session, file_bytes: bytes, file_name: str, category: str):
    try:
        df = pd.read_excel(io.BytesIO(file_bytes))
        
        # تنظيف عناوين الأعمدة وتوحيدها
        df.columns = df.columns.astype(str).str.strip().str.lower()
        
        column_mapping = {
            'first_name': ['first name', 'الاسم الأول', 'الاسم الاول', 'first_name', 'الاسم'],
            'last_name': ['last name', 'الاسم الأخير', 'الاسم الاخير', 'last_name', 'اللقب'],
            'email': ['email', 'البريد الإلكتروني', 'البريد الالكتروني', 'الايميل'],
            'id_number': ['id number', 'رقم الهوية', 'الرقم الجامعي', 'رقم الطالب', 'id_number'],
            'level': ['level', 'المستوى', 'مستوى']
        }
        
        rename_dict = {}
        for std_col, possible_names in column_mapping.items():
            for excel_col in df.columns:
                if excel_col in possible_names:
                    rename_dict[excel_col] = std_col
                    break
        df.rename(columns=rename_dict, inplace=True)
        
        required_columns = ['first_name', 'last_name', 'email']
        if category == "STUDENT": 
            required_columns.append('id_number')
        
        if any(col not in df.columns for col in required_columns):
            return False, "KEY_INVALID_EXCEL_COLUMNS"

        role_id = _get_role_id_by_category(db, category)
        success_count = 0
        
        for _, row in df.iterrows():
            email = str(row['email']).strip().lower()
            user = db.query(User).filter(User.email == email).first()

            id_num = None
            if category == "STUDENT":
                id_num = str(row.get('id_number', '')).strip()
                if not user and id_num:
                    # Attempt to find the user via university_id to prevent duplicates
                    student_profile = db.query(Student).filter(Student.university_id == id_num).first()
                    if student_profile:
                        user = db.query(User).filter(User.user_id == student_profile.user_id).first()

            if user:
                # Check for completely identical data to avoid duplicates/unnecessary updates
                is_updated = False
                
                if category == "STUDENT":
                    student_profile = db.query(Student).filter(Student.user_id == user.user_id).first()
                    if student_profile and 'level' in df.columns:
                        try:
                            new_level_id = int(row['level'])
                            if student_profile.level_id != new_level_id:
                                # Update only level_id as requested
                                student_profile.level_id = new_level_id
                                is_updated = True
                        except ValueError:
                            pass
                
                if is_updated:
                    success_count += 1
                    
                # Skip if no updates were made
                continue 

            new_user = User(
                full_name=f"{row['first_name']} {row['last_name']}".strip(),
                email=email,
                password=str(row.get('id_number', '123456')),
                is_active=True
            )
            db.add(new_user)
            db.flush()

            if role_id:
                db.execute(user_roles.insert().values(user_id=new_user.user_id, role_id=role_id))

            if category == "STUDENT":
                level_id = 1
                if 'level' in df.columns:
                    try:
                        level_id = int(row['level'])
                    except ValueError:
                        pass

                db.add(Student(
                    user_id=new_user.user_id, 
                    university_id=str(row['id_number']), 
                    department_id=1, 
                    level_id=level_id
                ))
                
            elif category == "TEACHER":
                db.add(Teacher(user_id=new_user.user_id))
            elif category == "ADMIN":
                db.add(Admin(user_id=new_user.user_id))
                
            success_count += 1

        db.add(ImportHistory(file_name=file_name, record_count=success_count, import_type="KEY_EXCEL"))
        db.commit()
        return True, f"KEY_USERS_ADDED|{success_count}"
    except Exception as e:
        db.rollback()
        return False, "KEY_SERVER_ERROR"

def get_import_history_from_db(db: Session):
    records = db.query(ImportHistory).order_by(ImportHistory.import_date.desc()).all()
    
    result = []
    for r in records:
        result.append({
            "id": r.import_id,
            "file_or_name": r.file_name,
            "upload_date": r.import_date.isoformat() if r.import_date else None,
            "records_count": r.record_count,
            "status": "مكتمل",
            "is_success": True
        })
    return result

def delete_history_record(db: Session, record_id: int):
    record = db.query(ImportHistory).filter(ImportHistory.import_id == record_id).first()
    if record:
        db.delete(record)
        db.commit()
        return True
    return False