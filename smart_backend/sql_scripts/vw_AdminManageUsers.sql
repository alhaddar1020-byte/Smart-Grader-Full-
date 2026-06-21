
CREATE OR ALTER VIEW vw_AdminManageUsers AS
SELECT 
    u.user_id,
    u.full_name,
    u.email,
    CASE WHEN u.is_active = 1 THEN N'نشط' ELSE N'موقوف' END AS status_text,
    r.role_name
FROM users u
JOIN user_roles ur ON u.user_id = ur.user_id
JOIN roles r ON ur.role_id = r.role_id;
GO

