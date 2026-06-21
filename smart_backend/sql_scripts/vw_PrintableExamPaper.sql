
CREATE OR ALTER VIEW vw_PrintableExamPaper AS
SELECT 
    e.exam_id,
    e.exam_title,
    e.exam_date,
    DATENAME(weekday, e.exam_date) AS exam_day, 
    e.total_marks,
    e.allowed_time,                                 
    c.course_name AS subject_name,              
    u.full_name AS teacher_name,                
    l.level_name,                               
    s.semester_name,                            
    s.academic_year,
    (SELECT STRING_AGG(d.department_name, N' - ') 
     FROM exam_departments ed 
     JOIN department d ON ed.department_id = d.department_id 
     WHERE ed.exam_id = e.exam_id) AS target_departments
FROM exam e
INNER JOIN folder f ON e.folder_id = f.folder_id
INNER JOIN teacher_courses tc ON f.tc_id = tc.tc_id
INNER JOIN courses c ON tc.course_id = c.course_id
INNER JOIN [level] l ON c.level_id = l.level_id
INNER JOIN teacher th ON tc.teacher_id = th.teacher_id
INNER JOIN users u ON th.user_id = u.user_id
INNER JOIN semesters s ON tc.semester_id = s.semester_id;
GO
