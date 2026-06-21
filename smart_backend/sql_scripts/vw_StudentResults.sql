
CREATE OR ALTER VIEW vw_StudentResults AS
SELECT 
    ans.student_id,
    e.exam_title,
    c.course_name,
    e.exam_date,
    ans.total_earned_mark,
    e.total_marks,
    e.number_of_questions,
    CASE 
        WHEN (ans.total_earned_mark / e.total_marks) * 100 >= 90 THEN N'ممتاز'
        WHEN (ans.total_earned_mark / e.total_marks) * 100 >= 80 THEN N'جيد جداً'
        WHEN (ans.total_earned_mark / e.total_marks) * 100 >= 70 THEN N'جيد'
        WHEN (ans.total_earned_mark / e.total_marks) * 100 >= 50 THEN N'مقبول'
        ELSE N'ضعيف'
    END AS grade_text
FROM answer_sheet ans
JOIN exam e ON ans.exam_id = e.exam_id
JOIN folder f ON e.folder_id = f.folder_id
JOIN teacher_courses tc ON f.tc_id = tc.tc_id
JOIN courses c ON tc.course_id = c.course_id
WHERE ans.status = 'Graded';
GO
