-- Create the Database and Schema
CREATE DATABASE Employee_participation_information;
CREATE SCHEMA Employee_participation_information;

-- Connect to the newly created Database
USE Employee_participation_information;

-- Create Employee Table
CREATE TABLE Employee (
    Num_E INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Position VARCHAR(255) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    Department_Num_S INT,
    FOREIGN KEY (Department_Num_S) REFERENCES Department(Num_S) ON DELETE SET NULL
);

-- Create Department Table
CREATE TABLE Department (
    Num_S INT PRIMARY KEY,
    Label VARCHAR(255) NOT NULL,
    Manager_Name VARCHAR(255) NOT NULL
);

-- Create Project Table
CREATE TABLE Project (
    Num_P INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Department_Num_S INT,
    FOREIGN KEY (Department_Num_S) REFERENCES Department(Num_S) ON DELETE CASCADE
);

-- Create Employee_Project Table (Many-to-Many Relationship)
CREATE TABLE Employee_Project (
    Employee_Num_E INT,
    Project_Num_P INT,
    Role VARCHAR(255) NOT NULL,
    PRIMARY KEY (Employee_Num_E, Project_Num_P),
    FOREIGN KEY (Employee_Num_E) REFERENCES Employee(Num_E) ON DELETE CASCADE,
    FOREIGN KEY (Project_Num_P) REFERENCES Project(Num_P) ON DELETE CASCADE
);