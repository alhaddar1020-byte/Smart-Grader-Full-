
CREATE OR ALTER VIEW vw_TeacherSubjects AS
SELECT 
    tc.tc_id,              -- معرف التكليف (عشان نفتح المجلدات بناء عليه)
    tc.teacher_id,
    c.course_name,
    l.level_name,
    d.department_name,     -- إظهار اسم القسم في المربع
    
    -- عدد طلاب هذا القسم فقط في هذه المادة
    (SELECT COUNT(student_id) 
     FROM student_courses sc 
     JOIN student s ON sc.student_id = s.student_id
     WHERE sc.course_id = c.course_id 
       AND sc.semester_id = tc.semester_id 
       AND s.department_id = d.department_id) AS student_count,
    
    -- عدد الاختبارات اللي سواها المدرس لهذا القسم تحديداً
    (SELECT COUNT(e.exam_id) 
     FROM exam e 
     JOIN folder f ON e.folder_id = f.folder_id 
     WHERE f.tc_id = tc.tc_id) AS exam_count

FROM teacher_courses tc
JOIN courses c ON tc.course_id = c.course_id
JOIN [level] l ON c.level_id = l.level_id
JOIN department d ON tc.department_id = d.department_id; -- الربط هنا يخلي كل قسم يظهر في صف مستقل
GO
