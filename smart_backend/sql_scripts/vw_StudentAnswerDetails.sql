
CREATE OR ALTER VIEW vw_StudentAnswerDetails AS
SELECT 
    sa.sheet_id,
    q.question_text,
    sa.extracted_text AS student_answer,
    ea.answer_text AS model_answer,
    sa.ai_mark,
    q.question_mark AS max_mark,
    sa.ai_feedback AS ai_evaluation
FROM student_answers sa
JOIN questions q ON sa.question_id = q.question_id
LEFT JOIN expected_answers ea ON q.question_id = ea.question_id
WHERE ea.is_correct = 1 OR q.question_type != 'MCQ';
GO
