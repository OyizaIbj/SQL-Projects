-- Write a query to retrieve the names of employees who are assigned to more than one project, 
-- including the total number of projects for each employee.
SELECT e.Name, COUNT(ep.Project_Num_P) AS Total_Projects
FROM Employee AS e
JOIN Employee_Project AS ep 
	ON e.Num_E = ep.Employee_Num_E
GROUP BY e.Name
HAVING COUNT(ep.Project_Num_P) > 1;

-- Write a query to retrieve the list of projects managed by each department, 
-- including the department label and manager’s name.
SELECT d.Label AS Department, d.Manager_Name, p.Title AS Project
FROM Department AS d
JOIN Project AS p 
	ON d.Num_S = p.Department_Num_S;

-- Write a query to retrieve the names of employees working on the project "Website Redesign," 
-- including their roles in the project.
SELECT e.Name, ep.Role
FROM Employee AS e
JOIN Employee_Project AS ep 
	ON e.Num_E = ep.Employee_Num_E
JOIN Project AS p 
	ON ep.Project_Num_P = p.Num_P
WHERE p.Title = 'Website Redesign';

-- Write a query to retrieve the department with the highest number of employees, 
-- including the department label, manager name, and the total number of employees.
SELECT TOP 1 d.Label, d.Manager_Name, COUNT(e.Num_E) AS Total_Employees
FROM Department AS d
JOIN Employee AS e 
	ON d.Num_S = e.Department_Num_S
GROUP BY d.Label, d.Manager_Name
ORDER BY Total_Employees DESC;

-- Write a query to retrieve the names and positions of employees earning a salary greater than 60,000, 
-- including their department names.
SELECT e.Name, e.Position, d.Label AS Department
FROM Employee AS e
JOIN Department AS d 
	ON e.Department_Num_S = d.Num_S
WHERE e.Salary > 60000;

-- Write a query to retrieve the number of employees assigned to each project, including the project title.
SELECT p.Title AS Project, COUNT(ep.Employee_Num_E) AS Total_Employees
FROM Project AS p
LEFT JOIN Employee_Project AS ep 
	ON p.Num_P = ep.Project_Num_P
GROUP BY p.Title;

-- Write a query to retrieve a summary of roles employees have across different projects, 
-- including the employee name, project title, and role.
SELECT e.Name, p.Title AS Project, ep.Role
FROM Employee AS e
JOIN Employee_Project AS ep 
	ON e.Num_E = ep.Employee_Num_E
JOIN Project AS p 
	ON ep.Project_Num_P = p.Num_P;

-- Write a query to retrieve the total salary expenditure for each department, 
-- including the department label and manager name.
SELECT d.Label AS Department, d.Manager_Name, SUM(e.Salary) AS Total_Salary_Expenditure
FROM Department AS d
JOIN Employee AS e 
	ON d.Num_S = e.Department_Num_S
GROUP BY d.Label, d.Manager_Name;
