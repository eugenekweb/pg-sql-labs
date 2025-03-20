-- task 2

WITH RECURSIVE
tmp_employee_hierarchy AS (
    -- База рекурсии
    SELECT employeeid, name, managerid, departmentid, roleid
    FROM employees
    -- Начинаем иерархию с сотрудника с корневого сотрудника
    WHERE employeeid = 1
	    UNION ALL
    SELECT e.employeeid, e.name, e.managerid, e.departmentid, e.roleid
    FROM employees e
    -- Рекурсивно добавляем всех подчиненных для каждого уровня иерархии
    JOIN tmp_employee_hierarchy teh ON e.managerid = teh.employeeid
)
SELECT teh.employeeid AS EmployeeID, teh.name AS EmployeeName,
	teh.managerid AS ManagerID, d.departmentname AS DepartmentName,
	r.rolename AS RoleName,
    -- Список уникальных проектов через запятую
    STRING_AGG(DISTINCT p.projectname, ', ') AS ProjectNames,
    -- Список уникальных задач через запятую
    STRING_AGG(DISTINCT t.taskname, ', ') AS TaskNames,
    -- Общее количество уникальных задач, назначенных сотруднику
    COUNT(DISTINCT t.taskid) AS TotalTasks,
    -- Общее количество прямых подчиненных сотрудника
    COUNT(DISTINCT e.employeeid) AS TotalSubordinates
FROM tmp_employee_hierarchy teh
LEFT JOIN departments d USING(departmentid)
LEFT JOIN roles r USING(roleid)
LEFT JOIN projects p USING(departmentid)
-- Связываем задачи с проектами и сотрудниками, чтобы получить только те задачи, которые назначены конкретному сотруднику
LEFT JOIN tasks t ON t.projectid = p.projectid AND t.assignedto = teh.employeeid
-- Находим всех прямых подчиненных для каждого сотрудника
LEFT JOIN employees e ON e.managerid = teh.employeeid
GROUP BY teh.employeeid, teh.name, teh.managerid, d.departmentid, r.rolename
ORDER BY teh.name;