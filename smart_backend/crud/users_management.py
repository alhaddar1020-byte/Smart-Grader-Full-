from sqlalchemy.orm import Session
from sqlalchemy import text
from models.users import User
from models.profiles import Student
from schemas.users_management import UserUpdateRequest
# from models.academic import Semester, StudentCourse # 👈 استدعي جداول التسجيل الخاصة بكِ هنا

def get_all_users_from_db(db: Session, active_only: bool = False):
    # 1. الاستعلام الأساسي من الفيو
    query = text("""
        SELECT 
            display_id AS id, 
            full_name AS name, 
            role_name AS role, 
            status_key AS status 
        FROM vw_AdminManageUsers
    """)
    result = db.execute(query).mappings().all()
    
    # 2. تجهيز البيانات للواجهة
    users_list = []
    for row in result:
        users_list.append({
            "id": str(row["id"]),
            "name": row["name"] if row["name"] else "",
            "role": row["role"],
            "status": row["status"]
        })
        
    # 3. ⭐️ تطبيق فلتر الترم النشط (التعديل الجديد) ⭐️
    if active_only:
        # أ) نجلب رقم الترم النشط (من صورتك عمود is_current هو المسؤول)
        current_sem_query = text("SELECT semester_id FROM semesters WHERE is_current = TRUE LIMIT 1")
        current_sem_result = db.execute(current_sem_query).scalar()
        
        if current_sem_result:
            # ب) نجلب الأرقام الأكاديمية للطلاب المسجلين في هذا الترم، بالإضافة للطلاب الجدد الذين لم يسجلوا أي مواد بعد
            active_students_query = text(f"""
                SELECT s.university_id 
                FROM student s
                WHERE s.student_id IN (
                    SELECT sc.student_id FROM student_courses sc WHERE sc.semester_id = {current_sem_result}
                )
                OR s.student_id NOT IN (
                    SELECT sc.student_id FROM student_courses sc
                )
            """)
            active_students = db.execute(active_students_query).scalars().all()
            
            # نحول النتيجة إلى قائمة من النصوص لتسهيل المقارنة
            active_student_ids = [str(sid) for sid in active_students]
            
            # ج) تصفية القائمة النهائية
            filtered_users = []
            for u in users_list:
                # نبقي الإداريين والمعلمين ظاهرين دائماً
                if u['role'] != 'STUDENT':
                    filtered_users.append(u)
                # ونبقي الطلاب المتواجدين في قائمة الترم النشط فقط
                elif u['id'] in active_student_ids:
                    filtered_users.append(u)
                    
            # تحديث القائمة بالقائمة المفلترة
            users_list = filtered_users

    return users_list

def update_user_in_db(db: Session, target_id: str, update_data: UserUpdateRequest):
    user = None
    student = db.query(Student).filter(Student.university_id == target_id).first()
    if student:
        user = db.query(User).filter(User.user_id == student.user_id).first()
    
    if not user:
        try:
            user = db.query(User).filter(User.user_id == int(target_id)).first()
        except (ValueError, TypeError):
            pass
    
    if not user:
        return False
    
    user.full_name = update_data.name
    user.is_active = True if update_data.status == 'ACTIVE' else False
    db.commit()
    return True

def delete_user_from_db(db: Session, target_id: str):
    user = None
    student = db.query(Student).filter(Student.university_id == target_id).first()
    if student:
        user = db.query(User).filter(User.user_id == student.user_id).first()
    
    if not user:
        try:
            user = db.query(User).filter(User.user_id == int(target_id)).first()
        except (ValueError, TypeError):
            pass
    
    if not user:
        return False
    
    db.delete(user)
    db.commit()
    return True