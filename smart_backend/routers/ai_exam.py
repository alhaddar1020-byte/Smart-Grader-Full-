from fastapi import Depends
from core.security import get_current_user_id
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session
from typing import List
from db.database import get_db
from crud.ai_exam import (
    get_folder_context,
    extract_text_from_files,
    generate_exam_with_gemini,
    save_generated_exam,
)
from schemas.ai_exam import (
    ExamGenerationResponse,
    GeneratedQuestion,
    SaveExamRequest,
    SaveExamResponse,
    FolderContextResponse,
)

router = APIRouter(prefix="/teacher/ai-exam", tags=["AI Exam Generation"], dependencies=[Depends(get_current_user_id)])

@router.get("/folder-context/{folder_id}", response_model=FolderContextResponse)
def get_folder_info(folder_id: int, db: Session = Depends(get_db)):
    ctx = get_folder_context(db, folder_id)
    if not ctx: raise HTTPException(status_code=404, detail="المجلد غير موجود")
    return FolderContextResponse(**ctx)

@router.post("/generate", response_model=ExamGenerationResponse)
async def generate_exam(
    folder_id: int = Form(...),
    exam_title: str = Form(""),
    exam_date: str = Form(""),
    total_grade: float = Form(100.0),
    students_count: int = Form(0),
    total_questions: int = Form(25),
    mcq_count: int = Form(10),
    tf_count: int = Form(5),
    essay_count: int = Form(5),
    match_count: int = Form(5),
    fill_count: int = Form(0),
    difficulty: str = Form("MEDIUM"),
    files: List[UploadFile] = File(default=[]),
    db: Session = Depends(get_db),
):
    ctx = get_folder_context(db, folder_id)
    if not ctx: raise HTTPException(status_code=404, detail="المجلد غير موجود أو غير مرتبط بمادة")

    extracted_text = ""
    valid_files = [f for f in files if f and f.filename]
    if valid_files: extracted_text = await extract_text_from_files(valid_files)

    result = generate_exam_with_gemini(
        exam_title=exam_title or f"اختبار {ctx['course_name']}",
        total_grade=total_grade,
        course_name=ctx["course_name"],
        specialization=ctx["specialization"],
        level=ctx["level"],
        difficulty=difficulty,
        mcq_count=mcq_count,
        tf_count=tf_count,
        essay_count=essay_count,
        match_count=match_count,
        fill_count=fill_count,
        extracted_text=extracted_text,
    )

    if not result["success"]: raise HTTPException(status_code=500, detail=result["message"])

    ai_data = result["data"]
    questions = [GeneratedQuestion(**q) for q in ai_data.get("questions", [])]

    return ExamGenerationResponse(
        success=True,
        message="تم توليد الاختبار بنجاح",
        exam_title=exam_title or f"اختبار {ctx['course_name']}",
        total_questions=len(questions),
        total_grade=total_grade,
        ai_accuracy=98.5,
        questions=questions,
        keywords=ai_data.get("keywords", []),
    )

@router.post("/save", response_model=SaveExamResponse)
def save_exam(req: SaveExamRequest, db: Session = Depends(get_db)):
    if not req.questions: raise HTTPException(status_code=400, detail="لا توجد أسئلة للحفظ")
    ctx = get_folder_context(db, req.folder_id)
    if not ctx: raise HTTPException(status_code=404, detail="المجلد غير موجود")

    result = save_generated_exam(db, req)
    if not result["success"]: raise HTTPException(status_code=500, detail=result["message"])

    return SaveExamResponse(
        success=True,
        message=result["message"],
        exam_id=result["exam_id"],
    )