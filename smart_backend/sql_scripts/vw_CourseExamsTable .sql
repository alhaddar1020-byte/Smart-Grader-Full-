CREATE OR ALTER VIEW vw_CourseExamsTable AS
SELECT 
    e.exam_id,
    tc.course_id,
    e.exam_title,
    e.exam_date AS creation_date,
    -- عدد الطلاب الذين تم رفع أوراقهم لهذا الاختبار
    (SELECT COUNT(sheet_id) FROM answer_sheet WHERE exam_id = e.exam_id) AS student_count,
    e.status
FROM exam e
JOIN folder f ON e.folder_id = f.folder_id
JOIN teacher_courses tc ON f.tc_id = tc.tc_id;
GO
