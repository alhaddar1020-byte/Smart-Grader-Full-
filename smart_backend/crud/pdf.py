# from fastapi import APIRouter, Depends, HTTPException, Query
# from fastapi.responses import StreamingResponse
# from sqlalchemy.orm import Session
# from sqlalchemy import text
# import io
# from datetime import date

# from reportlab.pdfgen import canvas as rl_canvas
# from reportlab.lib.pagesizes import A4
# from reportlab.pdfbase import pdfmetrics
# from reportlab.pdfbase.ttfonts import TTFont
# from reportlab.platypus import (
#     SimpleDocTemplate, Table, TableStyle, Paragraph,
#     Spacer, HRFlowable
# )
# from reportlab.lib import colors
# from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
# from reportlab.lib.units import mm, cm
# from reportlab.lib.enums import TA_RIGHT, TA_LEFT, TA_CENTER

# import arabic_reshaper
# from bidi.algorithm import get_display

# from db.database import get_db 

# router = APIRouter()

# # ── Arabic helper ───────────────────────────────────────────────────────────────
# reshaper_config = {
#     'delete_harakat': True,
#     'support_ligatures': False, 
# }
# reshaper = arabic_reshaper.ArabicReshaper(configuration=reshaper_config)

# def prep(txt):
#     if not txt:
#         return "-"
#     reshaped = reshaper.reshape(str(txt))
#     return get_display(reshaped)

# def fmt_num(num):
#     if num is None: return "0"
#     try:
#         val = float(num)
#         return f"{int(val)}" if val.is_integer() else f"{val}"
#     except:
#         return str(num)

# # ── Main endpoint ───────────────────────────────────────────────────────────────
# @router.get("/api/download-exam-report/{student_id}/{exam_id}")
# def download_exam_report(
#     student_id: int,
#     exam_id: int,
#     lang: str = Query("ar"),
#     theme: str = Query("light"), 
#     db: Session = Depends(get_db),
# ):
#     is_ar = (lang == "ar")

#     TEAL = colors.HexColor("#4FB7B5")
#     BG_COLOR = colors.white
#     TEXT_COLOR = colors.HexColor("#1F2937")
#     GRAY_BOX = colors.HexColor("#F3F4F6")
#     GRAY_ROW_EVEN = colors.HexColor("#F9FAFB")
#     GRAY_TEXT = colors.HexColor("#6B7280")
#     LINE_COLOR = colors.HexColor("#E5E7EB")

#     def tr(ar_txt, en_txt): return ar_txt if is_ar else en_txt
#     align_main = TA_RIGHT if is_ar else TA_LEFT

#     # ── 1. Fetch Data ──
#     record = db.execute(
#         text("""
#             SELECT e.exam_title, e.total_marks, 
#                    e.exam_date,
#                    u.full_name AS student_name,
#                    l.level_name, 
#                    dep.department_name,
#                    ans.total_earned_mark,
#                    ans.sheet_id -- 🔴 جلبنا sheet_id عشان نستخدمه في الاستعلام الثاني
#             FROM answer_sheet ans
#             JOIN exam e ON ans.exam_id = e.exam_id
#             JOIN folder f ON e.folder_id = f.folder_id
#             JOIN student s ON ans.student_id = s.student_id
#             LEFT JOIN department dep ON s.department_id = dep.department_id
#             JOIN users u ON s.user_id = u.user_id
#             JOIN teacher_courses tc ON f.tc_id = tc.tc_id
#             JOIN courses c ON tc.course_id = c.course_id
#             JOIN level l ON c.level_id = l.level_id
#             WHERE ans.student_id = :sid AND e.exam_id = :eid
#         """),
#         {"sid": student_id, "eid": exam_id},
#     ).mappings().first()

#     if not record:
#         raise HTTPException(status_code=404, detail="Data not found")

#     sheet_id = record["sheet_id"]

#     # 🔴 استعلام الأسئلة الجديد (مطابق للوجيك حقك بالضبط)
#     questions = db.execute(
#         text("""
#             SELECT 
#                 q.question_order, 
#                 q.question_text,
#                 q.question_mark,
#                 sa.extracted_text AS student_ans,
#                 sa.teacher_mark,
#                 sa.ai_mark,
#                 ea.answer_text AS model_ans
#             FROM questions q
#             LEFT JOIN student_answers sa ON q.question_id = sa.question_id AND sa.sheet_id = :sheet_id
#             LEFT JOIN expected_answers ea ON q.question_id = ea.question_id
#             WHERE q.exam_id = :eid
#             ORDER BY q.question_order ASC
#         """),
#         {"sheet_id": sheet_id, "eid": exam_id},
#     ).mappings().fetchall()

#     try:
#         pdfmetrics.registerFont(TTFont("Arial", "ARIAL.TTF"))
#         pdfmetrics.registerFont(TTFont("Arial-Bold", "ARIALBD.TTF"))
#     except Exception as e:
#         print(f"Font Error: {e}")

#     buffer = io.BytesIO()
#     PAGE_W, PAGE_H = A4
#     MARGIN = 10 * mm

#     def on_page(canv, doc):
#         canv.setFillColor(BG_COLOR)
#         canv.rect(0, 0, A4[0], A4[1], fill=1, stroke=0)

#     doc = SimpleDocTemplate(
#         buffer, pagesize=A4, rightMargin=MARGIN, leftMargin=MARGIN,
#         topMargin=10 * mm, bottomMargin=20 * mm,
#     )

#     base = getSampleStyleSheet()
#     def s(name, parent="Normal", **kw):
#         p = ParagraphStyle(name, parent=base[parent])
#         for k, v in kw.items(): setattr(p, k, v)
#         return p

#     st = {
#         "title": s("title", fontName="Arial-Bold", fontSize=22, leading=30, textColor=TEAL, alignment=TA_CENTER, spaceAfter=20),
#         "subtitle": s("subtitle", fontName="Arial", fontSize=12, leading=18, textColor=GRAY_TEXT, alignment=TA_CENTER, spaceAfter=15),
#         "table_header": s("table_header", fontName="Arial-Bold", fontSize=10, leading=16, textColor=colors.white, alignment=TA_CENTER),
#         "table_cell": s("table_cell", fontName="Arial", fontSize=9, leading=16, textColor=TEXT_COLOR, alignment=TA_CENTER),
#         "info_label": s("info_label", fontName="Arial", fontSize=10, leading=16, textColor=GRAY_TEXT, alignment=align_main),
#         "info_value": s("info_value", fontName="Arial", fontSize=11, leading=16, textColor=TEXT_COLOR, alignment=align_main),
#         "section_title": s("section_title", fontName="Arial-Bold", fontSize=12, leading=18, textColor=TEXT_COLOR, alignment=align_main),
#         "badge_text": s("badge_text", fontName="Arial-Bold", fontSize=11, leading=16, textColor=colors.white, alignment=TA_CENTER),
#     }

#     elems = []

#     elems.append(Paragraph(prep(tr("نظام التصحيح الذكي", "Smart Grading System")), st["title"]))
#     elems.append(Paragraph(prep(tr("تقرير نتيجة اختبار تفصيلي", "Detailed Exam Report")), st["subtitle"]))
#     elems.append(HRFlowable(width="100%", thickness=2, color=TEAL, spaceAfter=10))

#     actual_date = record.get('exam_date')
#     date_str = actual_date.strftime("%Y-%m-%d") if actual_date else date.today().strftime("%Y-%m-%d")
#     dept_name = record.get('department_name') or "غير محدد"

#     exam_lbl = tr(f"الاختبار: {record['exam_title']}", f"Exam: {record['exam_title']}")
#     stu_lbl = tr(f"اسم الطالب: {record['student_name']}", f"Student: {record['student_name']}")
#     date_lbl = tr(f"التاريخ: {date_str}", f"Date: {date_str}")
#     lvl_lbl = tr(f"المستوى: {record['level_name']} - {dept_name}", f"Level: {record['level_name']} - {dept_name}")

#     if is_ar:
#         info_data = [
#             [Paragraph(prep(exam_lbl), st["info_value"]), Paragraph(prep(stu_lbl), st["info_value"])],
#             [Paragraph(prep(date_lbl), st["info_label"]), Paragraph(prep(lvl_lbl), st["info_label"])],
#         ]
#     else:
#         info_data = [
#             [Paragraph(prep(stu_lbl), st["info_value"]), Paragraph(prep(exam_lbl), st["info_value"])],
#             [Paragraph(prep(lvl_lbl), st["info_label"]), Paragraph(prep(date_lbl), st["info_label"])],
#         ]

#     col_half = (PAGE_W - 2 * MARGIN) / 2
#     info_table = Table(info_data, colWidths=[col_half, col_half])
#     info_table.setStyle(TableStyle([
#         ("BACKGROUND", (0, 0), (-1, -1), GRAY_BOX), ("ROUNDEDCORNERS", [8]),
#         ("TOPPADDING", (0, 0), (-1, -1), 10), ("BOTTOMPADDING", (0, 0), (-1, -1), 10),
#         ("LEFTPADDING", (0, 0), (-1, -1), 12), ("RIGHTPADDING", (0, 0), (-1, -1), 12),
#         ("ALIGN", (0, 0), (-1, -1), "RIGHT" if is_ar else "LEFT"),
#         ("VALIGN", (0, 0), (-1, -1), "MIDDLE"), ("BOX", (0, 0), (-1, -1), 0, GRAY_BOX),
#         ("INNERGRID", (0, 0), (-1, -1), 0, GRAY_BOX),
#     ]))
#     elems.append(info_table)
#     elems.append(Spacer(1, 10))

#     score_label = tr(f"الدرجة النهائية: {fmt_num(record['total_earned_mark'])} / {fmt_num(record['total_marks'])}",
#                      f"Final Score: {fmt_num(record['total_earned_mark'])} / {fmt_num(record['total_marks'])}")
#     sec_title = tr("تفاصيل الإجابات والتقييم:", "Evaluation Details:")

#     if is_ar:
#         badge_data = [[Paragraph(prep(score_label), st["badge_text"]), Paragraph(prep(sec_title), st["section_title"])]]
#         badge_bg = [("BACKGROUND", (0, 0), (0, 0), TEAL), ("ALIGN", (1, 0), (1, 0), "RIGHT")]
#     else:
#         badge_data = [[Paragraph(prep(sec_title), st["section_title"]), Paragraph(prep(score_label), st["badge_text"])]]
#         badge_bg = [("BACKGROUND", (1, 0), (1, 0), TEAL), ("ALIGN", (0, 0), (0, 0), "LEFT")]

#     badge_table = Table(badge_data, colWidths=[col_half * 0.55, col_half * 1.45] if is_ar else [col_half * 1.45, col_half * 0.55])
#     badge_table.setStyle(TableStyle(badge_bg + [
#         ("ROUNDEDCORNERS", [6]), ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
#         ("TOPPADDING", (0, 0), (-1, -1), 8), ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
#         ("LEFTPADDING", (0, 0), (-1, -1), 10), ("RIGHTPADDING", (0, 0), (-1, -1), 10),
#     ]))
#     elems.append(badge_table)
#     elems.append(Spacer(1, 8))

#     # ── QUESTIONS TABLE ──
#     usable_w = PAGE_W - 2 * MARGIN
#     col_num, col_score, col_q = 14 * mm, 20 * mm, 50 * mm
#     col_ans = (usable_w - col_num - col_score - col_q) / 2

#     if is_ar:
#         headers = [tr("الدرجة", "Score"), tr("الإجابة النموذجية", "Model Answer"), tr("إجابة الطالب", "Student Answer"), tr("نص السؤال", "Question"), tr("الرقم", "No.")]
#         col_widths = [col_score, col_ans, col_ans, col_q, col_num]
#     else:
#         headers = [tr("الرقم", "No."), tr("نص السؤال", "Question"), tr("إجابة الطالب", "Student Answer"), tr("الإجابة النموذجية", "Model Answer"), tr("الدرجة", "Score")]
#         col_widths = [col_num, col_q, col_ans, col_ans, col_score]

#     rows = [[Paragraph(prep(h), st["table_header"]) for h in headers]]

#     for i, q in enumerate(questions):
#         # 🔴 تطبيق منطق الدرجات: الأولوية لدرجة المعلم، ثم الـ AI، ثم صفر
#         t_mark = q["teacher_mark"]
#         a_mark = q["ai_mark"]
#         earned_score = float(t_mark) if t_mark is not None else float(a_mark) if a_mark is not None else 0.0

#         mark_str = f"{fmt_num(earned_score)} / {fmt_num(q['question_mark'])}"
#         m_ans = q["model_ans"] or tr("قيد المراجعة", "Under Review")
#         s_ans = q["student_ans"] or tr("لم يتم استخراج الإجابة", "No Answer Extracted")
        
#         if is_ar:
#             row_data = [mark_str, m_ans, s_ans, q["question_text"], str(q["question_order"])]
#         else:
#             row_data = [str(q["question_order"]), q["question_text"], s_ans, m_ans, mark_str]
            
#         rows.append([Paragraph(prep(str(cell)), st["table_cell"]) for cell in row_data])

#     q_table = Table(rows, colWidths=col_widths, repeatRows=1) 
#     row_styles = [
#         ("BACKGROUND", (0, 0), (-1, 0), TEAL), ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
#         ("TOPPADDING", (0, 0), (-1, -1), 6), ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
#         ("LEFTPADDING", (0, 0), (-1, -1), 5), ("RIGHTPADDING", (0, 0), (-1, -1), 5),
#         ("BOX", (0, 0), (-1, -1), 0.5, TEAL), ("LINEBELOW", (0, 0), (-1, -1), 0.3, LINE_COLOR),
#     ]

#     for idx in range(1, len(rows)):
#         bg = GRAY_ROW_EVEN if idx % 2 == 0 else BG_COLOR
#         row_styles.append(("BACKGROUND", (0, idx), (-1, idx), bg))

#     q_table.setStyle(TableStyle(row_styles))
#     elems.append(q_table)
#     elems.append(Spacer(1, 8))

#     # ── Footer ──
#     elems.append(HRFlowable(width="100%", thickness=1, color=TEAL, spaceBefore=4))
    
#     footer_text = tr("نظام التصحيح الذكي – تقرير مُولَّد تلقائياً", "Smart Grading System – Auto-generated Report")
#     elems.append(Paragraph(
#         prep(footer_text),
#         ParagraphStyle("footer", fontName="Arial-Bold", fontSize=9, textColor=TEAL, alignment=TA_CENTER)
#     ))

#     doc.build(elems, onFirstPage=on_page, onLaterPages=on_page)
#     buffer.seek(0)

#     return StreamingResponse(
#         buffer, media_type="application/pdf",
#         headers={"Content-Disposition": f"attachment; filename=exam_report_{student_id}.pdf"}
#     )


from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from sqlalchemy import text
import io
from datetime import date

from reportlab.pdfgen import canvas as rl_canvas
from reportlab.lib.pagesizes import A4
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    SimpleDocTemplate, Table, TableStyle, Paragraph,
    Spacer, HRFlowable
)
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import mm, cm
from reportlab.lib.enums import TA_RIGHT, TA_LEFT, TA_CENTER

import arabic_reshaper
from bidi.algorithm import get_display

from db.database import get_db 

router = APIRouter()

# ── Arabic helper ───────────────────────────────────────────────────────────────
reshaper_config = {
    'delete_harakat': True,
    'support_ligatures': False, 
}
reshaper = arabic_reshaper.ArabicReshaper(configuration=reshaper_config)

def prep(txt):
    if not txt: return "-"
    
    # 🌟 سطر سطر: عشان لو النص طويل ونزل سطر جديد، ما ينقلب من تحت لفوق!
    lines = str(txt).split('\n')
    final_lines = []
    
    for line in lines:
        # 1. ربط الحروف
        reshaped = reshaper.reshape(line)
        # 2. السحر هنا: (base_dir='R') تجبر المكتبة تعتبر الجملة عربية وما تلخبط الإنجليزي!
        bidi_line = get_display(reshaped, base_dir='R')
        final_lines.append(bidi_line)
        
    # ندمجهم بـ <br/> عشان ReportLab يفهم إن فيه سطر جديد
    return "<br/>".join(final_lines)

def fmt_num(num):
    if num is None: return "0"
    try:
        val = float(num)
        return f"{int(val)}" if val.is_integer() else f"{val}"
    except:
        return str(num)

def resolve_student_id(db, student_id):
    real = db.execute(
        text("SELECT student_id FROM student WHERE user_id = :id OR student_id = :id LIMIT 1"),
        {"id": student_id}
    ).scalar()
    return real if real else student_id


# ── Main endpoint ───────────────────────────────────────────────────────────────
@router.get("/api/download-exam-report/{student_id}/{exam_id}")
def download_exam_report(
    student_id: int,
    exam_id: int,
    lang: str = Query("ar"),
    theme: str = Query("light"), 
    db: Session = Depends(get_db),
):
    student_id = resolve_student_id(db, student_id)
    is_ar = (lang == "ar")

    TEAL = colors.HexColor("#4FB7B5")
    BG_COLOR = colors.white
    TEXT_COLOR = colors.HexColor("#1F2937")
    GRAY_BOX = colors.HexColor("#F3F4F6")
    GRAY_ROW_EVEN = colors.HexColor("#F9FAFB")
    GRAY_TEXT = colors.HexColor("#6B7280")
    LINE_COLOR = colors.HexColor("#E5E7EB")

    def tr(ar_txt, en_txt): return ar_txt if is_ar else en_txt
    align_main = TA_RIGHT if is_ar else TA_LEFT

    # ── 1. Fetch Data ──
    record = db.execute(
        text("""
            SELECT e.exam_title, e.total_marks, 
                   e.exam_date,
                   u.full_name AS student_name,
                   l.level_name, 
                   dep.department_name,
                   ans.total_earned_mark,
                   ans.sheet_id -- 🔴 جلبنا sheet_id عشان نستخدمه في الاستعلام الثاني
            FROM answer_sheet ans
            JOIN exam e ON ans.exam_id = e.exam_id
            JOIN folder f ON e.folder_id = f.folder_id
            JOIN student s ON ans.student_id = s.student_id
            LEFT JOIN department dep ON s.department_id = dep.department_id
            JOIN users u ON s.user_id = u.user_id
            JOIN teacher_courses tc ON f.tc_id = tc.tc_id
            JOIN courses c ON tc.course_id = c.course_id
            LEFT JOIN level l ON c.level_id = l.level_id -- 👈 التعديل هنا (إضافة LEFT)
            WHERE ans.student_id = :sid AND e.exam_id = :eid
        """),
        {"sid": student_id, "eid": exam_id},
    ).mappings().first()

    if not record:
        raise HTTPException(status_code=404, detail="Data not found")

    sheet_id = record["sheet_id"]

    # 🔴 استعلام الأسئلة الجديد (مطابق للوجيك حقك بالضبط)
    questions = db.execute(
        text("""
            SELECT 
                q.question_order, 
                q.question_text,
                q.question_mark,
                sa.extracted_text AS student_ans,
                sa.teacher_mark,
                sa.ai_mark,
                ea.answer_text AS model_ans
            FROM questions q
            LEFT JOIN student_answers sa ON q.question_id = sa.question_id AND sa.sheet_id = :sheet_id
            LEFT JOIN expected_answers ea ON q.question_id = ea.question_id
            WHERE q.exam_id = :eid
            ORDER BY q.question_order ASC
        """),
        {"sheet_id": sheet_id, "eid": exam_id},
    ).mappings().fetchall()

    try:
        pdfmetrics.registerFont(TTFont("Arial", "ARIAL.TTF"))
        pdfmetrics.registerFont(TTFont("Arial-Bold", "ARIALBD.TTF"))
    except Exception as e:
        print(f"Font Error: {e}")

    buffer = io.BytesIO()
    PAGE_W, PAGE_H = A4
    MARGIN = 10 * mm

    def on_page(canv, doc):
        canv.setFillColor(BG_COLOR)
        canv.rect(0, 0, A4[0], A4[1], fill=1, stroke=0)

    doc = SimpleDocTemplate(
        buffer, pagesize=A4, rightMargin=MARGIN, leftMargin=MARGIN,
        topMargin=10 * mm, bottomMargin=20 * mm,
    )

    base = getSampleStyleSheet()
    def s(name, parent="Normal", **kw):
        p = ParagraphStyle(name, parent=base[parent])
        for k, v in kw.items(): setattr(p, k, v)
        return p

    st = {
        "title": s("title", fontName="Arial-Bold", fontSize=22, leading=30, textColor=TEAL, alignment=TA_CENTER, spaceAfter=20),
        "subtitle": s("subtitle", fontName="Arial", fontSize=12, leading=18, textColor=GRAY_TEXT, alignment=TA_CENTER, spaceAfter=15),
        "table_header": s("table_header", fontName="Arial-Bold", fontSize=10, leading=16, textColor=colors.white, alignment=TA_CENTER),
        "table_cell": s("table_cell", fontName="Arial", fontSize=9, leading=16, textColor=TEXT_COLOR, alignment=TA_CENTER),
        "info_label": s("info_label", fontName="Arial", fontSize=10, leading=16, textColor=GRAY_TEXT, alignment=align_main),
        "info_value": s("info_value", fontName="Arial", fontSize=11, leading=16, textColor=TEXT_COLOR, alignment=align_main),
        "section_title": s("section_title", fontName="Arial-Bold", fontSize=12, leading=18, textColor=TEXT_COLOR, alignment=align_main),
        "badge_text": s("badge_text", fontName="Arial-Bold", fontSize=11, leading=16, textColor=colors.white, alignment=TA_CENTER),
    }

    elems = []

    elems.append(Paragraph(prep(tr("نظام التصحيح الذكي", "Smart Grading System")), st["title"]))
    elems.append(Paragraph(prep(tr("تقرير نتيجة اختبار تفصيلي", "Detailed Exam Report")), st["subtitle"]))
    elems.append(HRFlowable(width="100%", thickness=2, color=TEAL, spaceAfter=10))

    actual_date = record.get('exam_date')
    date_str = actual_date.strftime("%Y-%m-%d") if actual_date else tr("غير مسجل", "Not recorded")
    dept_name = record.get('department_name') or "غير محدد"

    exam_lbl = tr(f"الاختبار: {record['exam_title']}", f"Exam: {record['exam_title']}")
    stu_lbl = tr(f"اسم الطالب: {record['student_name']}", f"Student: {record['student_name']}")
    date_lbl = tr(f"التاريخ: {date_str}", f"Date: {date_str}")
    lvl_lbl = tr(f"المستوى: {record['level_name']} - {dept_name}", f"Level: {record['level_name']} - {dept_name}")

    if is_ar:
        info_data = [
            [Paragraph(prep(exam_lbl), st["info_value"]), Paragraph(prep(stu_lbl), st["info_value"])],
            [Paragraph(prep(date_lbl), st["info_label"]), Paragraph(prep(lvl_lbl), st["info_label"])],
        ]
    else:
        info_data = [
            [Paragraph(prep(stu_lbl), st["info_value"]), Paragraph(prep(exam_lbl), st["info_value"])],
            [Paragraph(prep(lvl_lbl), st["info_label"]), Paragraph(prep(date_lbl), st["info_label"])],
        ]

    col_half = (PAGE_W - 2 * MARGIN) / 2
    info_table = Table(info_data, colWidths=[col_half, col_half])
    info_table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, -1), GRAY_BOX), ("ROUNDEDCORNERS", [8]),
        ("TOPPADDING", (0, 0), (-1, -1), 10), ("BOTTOMPADDING", (0, 0), (-1, -1), 10),
        ("LEFTPADDING", (0, 0), (-1, -1), 12), ("RIGHTPADDING", (0, 0), (-1, -1), 12),
        ("ALIGN", (0, 0), (-1, -1), "RIGHT" if is_ar else "LEFT"),
        ("VALIGN", (0, 0), (-1, -1), "MIDDLE"), ("BOX", (0, 0), (-1, -1), 0, GRAY_BOX),
        ("INNERGRID", (0, 0), (-1, -1), 0, GRAY_BOX),
    ]))
    elems.append(info_table)
    elems.append(Spacer(1, 10))

    score_label = tr(f"الدرجة النهائية: {fmt_num(record['total_earned_mark'])} / {fmt_num(record['total_marks'])}",
                     f"Final Score: {fmt_num(record['total_earned_mark'])} / {fmt_num(record['total_marks'])}")
    sec_title = tr("تفاصيل الإجابات والتقييم:", "Evaluation Details:")

    if is_ar:
        badge_data = [[Paragraph(prep(score_label), st["badge_text"]), Paragraph(prep(sec_title), st["section_title"])]]
        badge_bg = [("BACKGROUND", (0, 0), (0, 0), TEAL), ("ALIGN", (1, 0), (1, 0), "RIGHT")]
    else:
        badge_data = [[Paragraph(prep(sec_title), st["section_title"]), Paragraph(prep(score_label), st["badge_text"])]]
        badge_bg = [("BACKGROUND", (1, 0), (1, 0), TEAL), ("ALIGN", (0, 0), (0, 0), "LEFT")]

    badge_table = Table(badge_data, colWidths=[col_half * 0.55, col_half * 1.45] if is_ar else [col_half * 1.45, col_half * 0.55])
    badge_table.setStyle(TableStyle(badge_bg + [
        ("ROUNDEDCORNERS", [6]), ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ("TOPPADDING", (0, 0), (-1, -1), 8), ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
        ("LEFTPADDING", (0, 0), (-1, -1), 10), ("RIGHTPADDING", (0, 0), (-1, -1), 10),
    ]))
    elems.append(badge_table)
    elems.append(Spacer(1, 8))

    # ── QUESTIONS TABLE ──
    usable_w = PAGE_W - 2 * MARGIN
    col_num, col_score, col_q = 14 * mm, 20 * mm, 50 * mm
    col_ans = (usable_w - col_num - col_score - col_q) / 2

    if is_ar:
        headers = [tr("الدرجة", "Score"), tr("الإجابة النموذجية", "Model Answer"), tr("إجابة الطالب", "Student Answer"), tr("نص السؤال", "Question"), tr("الرقم", "No.")]
        col_widths = [col_score, col_ans, col_ans, col_q, col_num]
    else:
        headers = [tr("الرقم", "No."), tr("نص السؤال", "Question"), tr("إجابة الطالب", "Student Answer"), tr("الإجابة النموذجية", "Model Answer"), tr("الدرجة", "Score")]
        col_widths = [col_num, col_q, col_ans, col_ans, col_score]

    rows = [[Paragraph(prep(h), st["table_header"]) for h in headers]]

    for i, q in enumerate(questions):
        # 🔴 تطبيق منطق الدرجات: الأولوية لدرجة المعلم، ثم الـ AI، ثم صفر
        t_mark = q["teacher_mark"]
        a_mark = q["ai_mark"]
        earned_score = float(t_mark) if t_mark is not None else float(a_mark) if a_mark is not None else 0.0

        mark_str = f"{fmt_num(earned_score)} / {fmt_num(q['question_mark'])}"
        m_ans = q["model_ans"] or tr("قيد المراجعة", "Under Review")
        s_ans = q["student_ans"] or tr("لم يتم استخراج الإجابة", "No Answer Extracted")
        
        if is_ar:
            row_data = [mark_str, m_ans, s_ans, q["question_text"], str(q["question_order"])]
        else:
            row_data = [str(q["question_order"]), q["question_text"], s_ans, m_ans, mark_str]
            
        rows.append([Paragraph(prep(str(cell)), st["table_cell"]) for cell in row_data])

    q_table = Table(rows, colWidths=col_widths, repeatRows=1) 
    row_styles = [
        ("BACKGROUND", (0, 0), (-1, 0), TEAL), ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ("TOPPADDING", (0, 0), (-1, -1), 6), ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
        ("LEFTPADDING", (0, 0), (-1, -1), 5), ("RIGHTPADDING", (0, 0), (-1, -1), 5),
        ("BOX", (0, 0), (-1, -1), 0.5, TEAL), ("LINEBELOW", (0, 0), (-1, -1), 0.3, LINE_COLOR),
    ]

    for idx in range(1, len(rows)):
        bg = GRAY_ROW_EVEN if idx % 2 == 0 else BG_COLOR
        row_styles.append(("BACKGROUND", (0, idx), (-1, idx), bg))

    q_table.setStyle(TableStyle(row_styles))
    elems.append(q_table)
    elems.append(Spacer(1, 8))

    # ── Footer ──
    elems.append(HRFlowable(width="100%", thickness=1, color=TEAL, spaceBefore=4))
    
    footer_text = tr("نظام التصحيح الذكي – تقرير مُولَّد تلقائياً", "Smart Grading System – Auto-generated Report")
    elems.append(Paragraph(
        prep(footer_text),
        ParagraphStyle("footer", fontName="Arial-Bold", fontSize=9, textColor=TEAL, alignment=TA_CENTER)
    ))

    doc.build(elems, onFirstPage=on_page, onLaterPages=on_page)
    buffer.seek(0)

    return StreamingResponse(
        buffer, media_type="application/pdf",
        headers={"Content-Disposition": f"attachment; filename=exam_report_{student_id}.pdf"}
    )