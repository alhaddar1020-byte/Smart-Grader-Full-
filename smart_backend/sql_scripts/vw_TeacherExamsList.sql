
CREATE OR ALTER VIEW vw_TeacherExamsList AS
SELECT 
    e.exam_id,
    tc.teacher_id,
    e.exam_title,
    e.exam_date,
    e.number_of_questions,
    l.level_name,
	c.course_name,
    e.status
FROM exam e
JOIN folder f ON e.folder_id = f.folder_id
JOIN teacher_courses tc ON f.tc_id = tc.tc_id
JOIN courses c ON tc.course_id = c.course_id
JOIN [level] l ON c.level_id = l.level_id;
GO
