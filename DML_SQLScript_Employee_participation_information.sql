-- Insert data into Department Table
INSERT INTO Department (Num_S, Label, Manager_Name) VALUES
(1, 'IT', 'Alice Johnson'),
(2, 'HR', 'Bob Smith'),
(3, 'Marketing', 'Clara Bennett');

-- Insert data into Employee Table
INSERT INTO Employee (Num_E, Name, Position, Salary, Department_Num_S) VALUES
(101, 'John Doe', 'Developer', 60000.00, 1),
(102, 'Jane Smith', 'Analyst', 55000.00, 2),
(103, 'Mike Brown', 'Designer', 50000.00, 3),
(104, 'Sarah Johnson', 'Data Scientist', 70000.00, 1),
(105, 'Emma Wilson', 'HR Specialist', 52000.00, 2);

-- Insert data into Project Table
INSERT INTO Project (Num_P, Title, Start_Date, End_Date, Department_Num_S) VALUES
(201, 'Website Redesign', '2024-01-15', '2024-06-30', 1),
(202, 'Employee Onboarding', '2024-03-01', '2024-09-01', 2),
(203, 'Market Research', '2024-02-01', '2024-07-31', 3),
(204, 'IT Infrastructure Setup', '2024-04-01', '2024-12-31', 1);

-- Insert data into Employee_Project Table
INSERT INTO Employee_Project (Employee_Num_E, Project_Num_P, Role) VALUES
(101, 201, 'Frontend Developer'),
(104, 201, 'Backend Developer'),
(102, 202, 'Trainer'),
(105, 202, 'Coordinator'),
(103, 203, 'Research Lead'),
(101, 204, 'Network Specialist');

-- Update Role of Employee_Num_E = 101 in Employee_Project Table
UPDATE Employee_Project
SET Role = 'Full Stack Developer'
WHERE Employee_Num_E = 101;

-- Delete Employee with Num_E = 103 and remove related records in Employee_Project Table
DELETE FROM Employee_Project WHERE Employee_Num_E = 103;
DELETE FROM Employee WHERE Num_E = 103;