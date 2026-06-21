from fastapi import Depends
from core.security import get_current_user_id
from fastapi import APIRouter, Depends, Response, Query
from sqlalchemy.orm import Session
from db.database import get_db
from crud.reports import get_reports_data
from schemas.reports import FullReportsResponse
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Table, TableStyle, Spacer
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.enums import TA_RIGHT, TA_CENTER, TA_LEFT
import arabic_reshaper
from bidi.algorithm import get_display
import io, os, urllib.request, shutil

router = APIRouter(prefix="/admin/reports", tags=["Reports"], dependencies=[Depends(get_current_user_id)])

# ==========================================
# إعداد arabic_reshaper بشكل صحيح
# ==========================================
_reshaper_config = {
    'delete_harakat': True,
    'support_ligatures': True,
    'RIAL SIGN': True,
    'use_unsupported_chars_reference': False,
    'support_zwj': False,
    'shift_harakat_position': False,
    'delete_tatweel': False,
}
_reshaper = arabic_reshaper.ArabicReshaper(configuration=_reshaper_config)

def ar(text: str) -> str:
    """تحويل النص العربي ليظهر متصلاً وصحيح الاتجاه"""
    reshaped = _reshaper.reshape(str(text))
    return get_display(reshaped)

# ==========================================
# تحميل خط Cairo
# ==========================================
_BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
_FONT_DIR = os.path.join(_BASE_DIR, "assets", "fonts")
_FONT_REGULAR = os.path.join(_FONT_DIR, "Amiri-Regular.ttf")
_FONT_BOLD = os.path.join(_FONT_DIR, "Amiri-Bold.ttf")

_CAIRO_URLS = {
    "regular": "https://github.com/google/fonts/raw/main/ofl/amiri/Amiri-Regular.ttf",
    "bold": "https://github.com/google/fonts/raw/main/ofl/amiri/Amiri-Bold.ttf",
}

_fonts_registered = False

def _register_fonts():
    global _fonts_registered
    if _fonts_registered:
        return True

    os.makedirs(_FONT_DIR, exist_ok=True)

    # تحميل Regular
    if not os.path.exists(_FONT_REGULAR):
        try:
            print("⬇️ تحميل Amiri-Regular.ttf...")
            urllib.request.urlretrieve(_CAIRO_URLS["regular"], _FONT_REGULAR)
        except Exception as e:
            print(f"❌ فشل تحميل الخط: {e}")
            return False

    # تحميل Bold
    if not os.path.exists(_FONT_BOLD):
        try:
            print("⬇️ تحميل Amiri-Bold.ttf...")
            urllib.request.urlretrieve(_CAIRO_URLS["bold"], _FONT_BOLD)
        except Exception as e:
            # استخدام Regular كبديل
            shutil.copy(_FONT_REGULAR, _FONT_BOLD)

    try:
        pdfmetrics.registerFont(TTFont("Amiri", _FONT_REGULAR))
        pdfmetrics.registerFont(TTFont("Amiri-Bold", _FONT_BOLD))
        _fonts_registered = True
        print("✅ تم تسجيل خط Amiri بنجاح")
        return True
    except Exception as e:
        print(f"❌ فشل تسجيل الخط: {e}")
        return False


# ==========================================
# Endpoints
# ==========================================
@router.get("/data", response_model=FullReportsResponse)
def get_reports(active_term: bool = Query(False, description="فلتر الترم النشط"), db: Session = Depends(get_db)):
    return get_reports_data(db, active_term=active_term)


@router.get("/export-pdf")
def export_pdf(active_term: bool = Query(False, description="فلتر الترم النشط"), lang: str = Query("ar", description="اللغة"), db: Session = Depends(get_db)):
    data = get_reports_data(db, active_term=active_term)
    summary = data["summary"]
    subjects = data["subjects_performance"]
    teachers = data["teachers_usage"]

    font_ok = _register_fonts()
    F = "Amiri" if font_ok else "Helvetica"
    FB = "Amiri-Bold" if font_ok else "Helvetica-Bold"

    TEAL = colors.HexColor("#00897B")
    LIGHT_TEAL = colors.HexColor("#E8F8F5")
    LIGHT_GRAY = colors.HexColor("#F5F5F5")
    WHITE = colors.white

    buffer = io.BytesIO()
    doc = SimpleDocTemplate(
        buffer, pagesize=A4,
        rightMargin=50, leftMargin=50,
        topMargin=50, bottomMargin=50
    )

    def make_style(name, font=F, size=11, align=TA_CENTER, **kwargs):
        return ParagraphStyle(name, fontName=font, fontSize=size,
                              alignment=align, leading=size * 1.6, **kwargs)

    align_section = TA_LEFT if lang == "en" else TA_RIGHT
    title_s = make_style("t", FB, 20, TA_CENTER, spaceAfter=10)
    section_s = make_style("s", FB, 13, align_section, spaceBefore=15, spaceAfter=6)

    def t(ar_text, en_text):
        return en_text if lang == "en" else ar_text

    def tbl_style(row_colors=None):
        row_colors = row_colors or [WHITE, LIGHT_TEAL]
        return TableStyle([
            ("BACKGROUND",    (0, 0), (-1,  0), TEAL),
            ("TEXTCOLOR",     (0, 0), (-1,  0), WHITE),
            ("FONTNAME",      (0, 0), (-1, -1), F),
            ("FONTNAME",      (0, 0), (-1,  0), FB),
            ("FONTSIZE",      (0, 0), (-1, -1), 11),
            ("ALIGN",         (0, 0), (-1, -1), "CENTER"),
            ("VALIGN",        (0, 0), (-1, -1), "MIDDLE"),
            ("GRID",          (0, 0), (-1, -1), 0.4, colors.HexColor("#CCCCCC")),
            ("ROWBACKGROUNDS",(0, 1), (-1, -1), row_colors),
            ("TOPPADDING",    (0, 0), (-1, -1), 9),
            ("BOTTOMPADDING", (0, 0), (-1, -1), 9),
            ("LEFTPADDING",   (0, 0), (-1, -1), 10),
            ("RIGHTPADDING",  (0, 0), (-1, -1), 10),
        ])

    elems = []

    # العنوان
    elems.append(Paragraph(ar(t("تقرير نظام المصحح الذكي", "Smart Grader System Report")), title_s))
    elems.append(Spacer(1, 10))

    # ملخص الإحصائيات
    elems.append(Paragraph(ar(t("الإحصائيات العامة:", "General Statistics:")), section_s))
    
    col_1 = t("إجمالي الطلاب", "Total Students")
    col_2 = t("المعدل العام", "General Average")
    col_3 = t("المعلمين النشطين", "Active Teachers")
    
    if lang == "en":
        t1_data = [
            [col_1, col_2, col_3],
            [str(summary["total_students"]), f"{summary['general_average']}%", str(summary["active_teachers"])]
        ]
    else:
        t1_data = [
            [ar(col_3), ar(col_2), ar(col_1)],
            [str(summary["active_teachers"]), f"{summary['general_average']}%", str(summary["total_students"])]
        ]

    t1 = Table(t1_data, colWidths=[160, 160, 160])
    t1.setStyle(tbl_style([WHITE, LIGHT_GRAY]))
    elems += [t1, Spacer(1, 10)]

    # نسب النجاح
    elems.append(Paragraph(ar(t("الأداء الإجمالي:", "Overall Performance:")), section_s))
    if lang == "en":
        t2_data = [
            [t("نسبة النجاح", "Pass Rate"), t("نسبة الرسوب", "Fail Rate")],
            [f"{summary['pass_percentage']}%", f"{summary['fail_percentage']}%"]
        ]
    else:
        t2_data = [
            [ar(t("نسبة الرسوب", "Fail Rate")), ar(t("نسبة النجاح", "Pass Rate"))],
            [f"{summary['fail_percentage']}%", f"{summary['pass_percentage']}%"]
        ]
    
    t2 = Table(t2_data, colWidths=[240, 240])
    t2.setStyle(tbl_style([WHITE, LIGHT_GRAY]))
    elems += [t2, Spacer(1, 10)]

    # أداء المواد
    elems.append(Paragraph(ar(t("تقارير الأداء العام للمواد:", "Subjects Performance Reports:")), section_s))
    
    col_sub1 = t("المادة", "Subject")
    col_sub2 = t("نسبة النجاح", "Pass Rate")
    col_sub3 = t("نسبة الرسوب", "Fail Rate")
    no_data = t("لا توجد بيانات", "No data available")
    
    if lang == "en":
        subj_rows = [[col_sub1, col_sub2, col_sub3]]
    else:
        subj_rows = [[ar(col_sub3), ar(col_sub2), ar(col_sub1)]]
        
    if subjects:
        for s in subjects:
            if lang == "en":
                subj_rows.append([
                    ar(s["subject_name"]), f"{s['success_rate']}%", f"{s['fail_rate']}%"
                ])
            else:
                subj_rows.append([
                    f"{s['fail_rate']}%", f"{s['success_rate']}%", ar(s["subject_name"])
                ])
    else:
        if lang == "en":
            subj_rows.append([no_data, "-", "-"])
        else:
            subj_rows.append(["-", "-", ar(no_data)])

    if lang == "en":
        t3 = Table(subj_rows, colWidths=[220, 140, 120])
    else:
        t3 = Table(subj_rows, colWidths=[120, 140, 220])
        
    t3.setStyle(tbl_style())
    elems += [t3, Spacer(1, 10)]

    # استخدام النظام
    elems.append(Paragraph(ar(t("استخدام النظام (الأكثر نشاطاً):", "System Usage (Most Active):")), section_s))
    
    col_u1 = t("الترتيب", "Rank")
    col_u2 = t("اسم المعلم", "Teacher Name")
    col_u3 = t("عدد المهام", "Tasks Count")
    
    if lang == "en":
        usage_rows = [[col_u1, col_u2, col_u3]]
    else:
        usage_rows = [[ar(col_u3), ar(col_u2), ar(col_u1)]]
        
    if teachers:
        for teacher_data in teachers:
            if lang == "en":
                usage_rows.append([
                    str(teacher_data["rank"]), ar(teacher_data["teacher_name"]), str(teacher_data["tasks_count"])
                ])
            else:
                usage_rows.append([
                    str(teacher_data["tasks_count"]), ar(teacher_data["teacher_name"]), str(teacher_data["rank"])
                ])
    else:
        if lang == "en":
            usage_rows.append(["-", no_data, "-"])
        else:
            usage_rows.append(["-", ar(no_data), "-"])

    if lang == "en":
        t4 = Table(usage_rows, colWidths=[80, 260, 140])
    else:
        t4 = Table(usage_rows, colWidths=[140, 260, 80])
        
    t4.setStyle(tbl_style())
    elems.append(t4)

    doc.build(elems)
    buffer.seek(0)

    return Response(
        content=buffer.read(),
        media_type="application/pdf",
        headers={
            "Content-Disposition": "attachment; filename=SmartGrader_Report.pdf",
            "Access-Control-Expose-Headers": "Content-Disposition"
        }
    )