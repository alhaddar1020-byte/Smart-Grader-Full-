
CREATE OR ALTER VIEW vw_SystemActivityLogs AS
SELECT 
    u.full_name AS user_name,
    r.role_name AS user_role,
    al.action_details AS action_taken,
    al.ip_address,
    al.[timestamp] AS action_date_time
FROM activity_log al
LEFT JOIN users u ON al.user_id = u.user_id
LEFT JOIN user_roles ur ON u.user_id = ur.user_id
LEFT JOIN roles r ON ur.role_id = r.role_id;
GO
