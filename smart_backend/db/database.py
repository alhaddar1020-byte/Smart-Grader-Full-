# from sqlalchemy import create_engine
# from sqlalchemy.orm import sessionmaker, declarative_base

# # ضعي رابط Supabase الخاص بك هنا
# SQLALCHEMY_DATABASE_URL = "postgresql://postgres.jfunoebwsfrhhmxxvssq:353179mn%40hu@aws-0-eu-west-1.pooler.supabase.com:6543/postgres"

# # إنشاء المحرك الذي يرسل الأوامر للسحابة
# engine = create_engine(
#     SQLALCHEMY_DATABASE_URL,
#     pool_pre_ping=True,     # يتأكد إن السلك مو مقطوع قبل أي طلب
#     pool_recycle=3600       # يجدد الاتصال تلقائياً كل ساعة
# )

# # هذي هي اللي كان تحتها خط، الحين تعرف عليها لأننا استدعيناها فوق!
# Base = declarative_base()

# # إنشاء جلسة الاتصال
# SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# # دالة توزيع الاتصالات (تُستخدم في الروابط Routers)
# def get_db():
#     db = SessionLocal()
#     try:
#         yield db
#     finally:
#         db.close()

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from supabase import create_client

import os
from dotenv import load_dotenv

load_dotenv()

# 1. بيانات Supabase
# من أين تحضرين هذه البيانات؟ 
# افتحي موقع Supabase -> مشروعك -> Project Settings -> API
SUPABASE_URL = os.environ.get("SUPABASE_URL", "") 
SUPABASE_KEY = os.environ.get("SUPABASE_KEY", "")

# إنشاء الاتصال
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# 2. بيانات SQL (كما هي عندك)
SQLALCHEMY_DATABASE_URL = os.environ.get("SQLALCHEMY_DATABASE_URL", "")


engine = create_engine(SQLALCHEMY_DATABASE_URL, pool_pre_ping=True, pool_recycle=3600)
Base = declarative_base()
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()