# ==========================================
# ملف: base.py
# وظيفته: يحتوي على المتغير `Base` الذي يعتمد عليه كل جدول في النظام.
# بدونه، لا يمكن لـ SQLAlchemy تحويل كلاسات بايثون إلى جداول حقيقية في قاعدة البيانات.
# ==========================================


from sqlalchemy.orm import declarative_base

Base = declarative_base()

# venv\Scripts\activate
# uvicorn main:app --reload
# Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
# flutter run -d chrome --web-browser-flag="--user-data-dir=C:\Users\G.B\Desktop\flutter_chrome_cache"