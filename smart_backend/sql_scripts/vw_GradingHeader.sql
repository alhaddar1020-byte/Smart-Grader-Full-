
CREATE OR ALTER VIEW vw_GradingHeader AS
SELECT 
    e.exam_id,
    c.course_name,
    e.exam_title,
    e.exam_date,
    e.number_of_questions,
    e.total_marks
FROM exam e
JOIN folder f ON e.folder_id = f.folder_id
JOIN teacher_courses tc ON f.tc_id = tc.tc_id
JOIN courses c ON tc.course_id = c.course_id;
GO
