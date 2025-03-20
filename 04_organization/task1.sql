-- task 1

WITH RECURSIVE
tmp_employee_hierarchy AS (
    SELECT employeeid, name, managerid, departmentid, roleid
    FROM employees
    WHERE employeeid = 1
	    UNION ALL
    SELECT e.employeeid, e.name, e.managerid, e.departmentid, e.roleid
    FROM employees e
    JOIN tmp_employee_hierarchy teh ON e.managerid = teh.employeeid
)
SELECT teh.employeeid AS EmployeeID, teh.name AS EmployeeName,
	teh.managerid AS ManagerID, d.departmentname AS DepartmentName,
	r.rolename AS RoleName,
    STRING_AGG(DISTINCT p.projectname, ', ') AS ProjectNames,
    STRING_AGG(DISTINCT t.taskname, ', ') AS TaskNames
FROM tmp_employee_hierarchy teh
LEFT JOIN departments d USING(departmentid)
LEFT JOIN roles r USING(roleid)
LEFT JOIN projects p USING(departmentid)
LEFT JOIN tasks t ON t.projectid = p.projectid AND t.assignedto = teh.employeeid
GROUP BY teh.employeeid, teh.name, teh.managerid, d.departmentid, r.rolename
ORDER BY teh.name;