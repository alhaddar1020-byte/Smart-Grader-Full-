# ==========================================
# ملف: __init__.py
# وظيفته: المدير العام لمجلد models. يقوم بتجميع كل الملفات (الجداول) في نقطة استيراد واحدة.
# يضمن أن FastAPI يتعرف على جميع الجداول دفعة واحدة عند تشغيل السيرفر وإنشائها في قاعدة البيانات.
# ==========================================

from .base import Base

from .associations import user_roles, course_departments, exam_departments
from .users import User, Role, VerificationCode
from .academic import Department, Level, StudentCourse
from .profiles import Student, Teacher, Admin, Course
from .exams import Semester, TeacherCourse, Folder, Exam
from .grading import AnswerSheet, Question, StudentAnswer, Report, SheetImage, ExpectedAnswer
from .settings import SystemSetting, ActivityLog, BackupHistory, ImportHistory