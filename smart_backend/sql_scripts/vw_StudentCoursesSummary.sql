
CREATE OR ALTER VIEW vw_StudentCoursesSummary AS
SELECT 
    sc.student_id,
    c.course_name,
    u.full_name AS teacher_name,
    
    -- 1. حساب إجمالي عدد الاختبارات المصححة (Graded) للطالب في هذه المادة عند هذا المدرس
    (SELECT COUNT(ans.sheet_id) 
     FROM answer_sheet ans 
     JOIN exam e ON ans.exam_id = e.exam_id 
     JOIN folder f ON e.folder_id = f.folder_id 
     WHERE ans.student_id = sc.student_id 
       AND f.tc_id = tc.tc_id  -- الربط عبر التكليف لضمان دقة البيانات
       AND ans.status = 'Graded') AS total_exams,
    
    -- 2. حساب معدل الطالب في هذه المادة بناءً على الدرجات الموجودة في answer_sheet
    (SELECT ISNULL(AVG(ans.total_earned_mark), 0) 
     FROM answer_sheet ans 
     JOIN exam e ON ans.exam_id = e.exam_id 
     JOIN folder f ON e.folder_id = f.folder_id 
     WHERE ans.student_id = sc.student_id 
       AND f.tc_id = tc.tc_id 
       AND ans.status = 'Graded') AS course_average_mark,
     
    -- 3. جلب عنوان آخر اختبار تم تصحيحه (أحدث تاريخ)
    (SELECT TOP 1 e.exam_title 
     FROM answer_sheet ans4 
     JOIN exam e ON ans4.exam_id = e.exam_id 
     JOIN folder f ON e.folder_id = f.folder_id 
     WHERE ans4.student_id = sc.student_id 
       AND f.tc_id = tc.tc_id 
       AND ans4.status = 'Graded' 
     ORDER BY e.exam_date DESC) AS last_exam_title,
     
    -- 4. جلب تاريخ آخر اختبار تم تصحيحه
    (SELECT TOP 1 e.exam_date 
     FROM answer_sheet ans5 
     JOIN exam e ON ans5.exam_id = e.exam_id 
     JOIN folder f ON e.folder_id = f.folder_id 
     WHERE ans5.student_id = sc.student_id 
       AND f.tc_id = tc.tc_id 
       AND ans5.status = 'Graded' 
     ORDER BY e.exam_date DESC) AS last_exam_date

FROM student_courses sc
JOIN student s ON sc.student_id = s.student_id -- لربط الطالب بقسمه
JOIN courses c ON sc.course_id = c.course_id
-- الربط الجوهري: نربط المدرس بالمادة + القسم + الترم
JOIN teacher_courses tc ON c.course_id = tc.course_id 
                        AND s.department_id = tc.department_id 
                        AND sc.semester_id = tc.semester_id
JOIN teacher th ON tc.teacher_id = th.teacher_id
JOIN users u ON th.user_id = u.user_id;
GO
