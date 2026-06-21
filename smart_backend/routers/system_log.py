from fastapi import Depends
from core.security import get_current_user_id
from fastapi import APIRouter, Depends, Query, Response
from sqlalchemy.orm import Session
from typing import Optional
from db.database import get_db
from crud.system_log import get_logs, get_logs_summary, export_logs_csv
from schemas.system_log import LogsResponse, LogsSummary

router = APIRouter(prefix="/admin/logs", tags=["System Logs"], dependencies=[Depends(get_current_user_id)])


@router.get("/summary", response_model=LogsSummary)
def fetch_logs_summary(active_term: bool = Query(False, description="فلتر الترم النشط"), db: Session = Depends(get_db)):
    """إحصائيات السجل: الإجمالي، تسجيلات الدخول، اليوم"""
    data = get_logs_summary(db, active_term=active_term)
    return LogsSummary(
        total_actions=data["total_actions"],
        login_records=data["login_records"],
        today_count=data["today_count"]
    )


@router.get("/list", response_model=LogsResponse)
def fetch_logs(
    search: Optional[str] = Query(None, description="البحث باسم المستخدم"),
    role: Optional[str] = Query(None, description="فلتر الدور: ADMIN, TEACHER, STUDENT, ALL"),
    selected_date: Optional[str] = Query(None, description="فلتر التاريخ: YYYY-MM-DD"),
    active_term: bool = Query(False, description="فلتر الترم النشط"),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=500),
    db: Session = Depends(get_db)
):
    """جلب السجلات مع الفلاتر والـ Pagination"""
    result = get_logs(
        db=db,
        search=search,
        role=role,
        selected_date=selected_date,
        skip=skip,
        limit=limit,
        active_term=active_term
    )
    return LogsResponse(
        total_count=result["total_count"],
        logs=result["logs"]
    )


@router.get("/export-csv")
def export_logs(
    search: Optional[str] = Query(None),
    role: Optional[str] = Query(None),
    selected_date: Optional[str] = Query(None),
    active_term: bool = Query(False),
    db: Session = Depends(get_db)
):
    """تصدير السجلات المفلترة كملف CSV"""
    csv_bytes = export_logs_csv(
        db=db,
        search=search,
        role=role,
        selected_date=selected_date,
        active_term=active_term
    )

    filename = f"System_Logs_{__import__('datetime').datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"

    return Response(
        content=csv_bytes,
        media_type="text/csv; charset=utf-8-sig",
        headers={
            "Content-Disposition": f"attachment; filename={filename}",
            "Access-Control-Expose-Headers": "Content-Disposition"
        }
    )