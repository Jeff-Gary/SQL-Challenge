
-- Data Engineering 

-- Drop all tables (start fresh)
DROP TABLE IF EXISTS dept_manager CASCADE;
DROP TABLE IF EXISTS dept_emp CASCADE;
DROP TABLE IF EXISTS salaries CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS titles CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- Create the `departments` table
CREATE TABLE departments (
    dept_no VARCHAR(4) PRIMARY KEY,
    dept_name VARCHAR(40) NOT NULL
);

-- Create the `titles` table
CREATE TABLE titles (
    title_id VARCHAR(5) PRIMARY KEY,
    title VARCHAR(50) NOT NULL
);

-- Create the `employees` table
CREATE TABLE employees (
    emp_no INT PRIMARY KEY,
    emp_title_id VARCHAR(5) NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    sex CHAR(1) NOT NULL CHECK (sex IN ('M', 'F')),
    hire_date DATE NOT NULL,
    FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

-- Create the `dept_emp` table
CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
    dept_no VARCHAR(4) NOT NULL,
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

-- Create the `dept_manager` table
CREATE TABLE dept_manager (
    emp_no INT NOT NULL,
    dept_no VARCHAR(4) NOT NULL,
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

-- Create the `salaries` table
CREATE TABLE salaries (
    emp_no INT PRIMARY KEY,
    salary INT NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);



-- Data Analysis 


-- Employee Number/First,Last Name/Sex/ and Salary 
SELECT 
    e.emp_no,
    e.last_name,
    e.first_name,
    e.sex,
    s.salary
FROM 
    employees e
JOIN 
    salaries s ON e.emp_no = s.emp_no;

-- First,Last Name/Hire date/ employees who were hired in 1986

SELECT 
    first_name,
    last_name,
    hire_date
FROM 
    employees
WHERE 
    EXTRACT(YEAR FROM hire_date) = 1986;


-- Manager of Each Department/ Department #, name, employee number , first and last name 

SELECT 
    dm.dept_no,
    d.dept_name,
    e.emp_no,
    e.last_name,
    e.first_name
FROM 
    dept_manager dm
JOIN 
    departments d ON dm.dept_no = d.dept_no
JOIN 
    employees e ON dm.emp_no = e.emp_no;


-- Department # for each employee, first and last name, & department name

SELECT 
    de.dept_no,
    e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
FROM 
    dept_emp de
JOIN 
    departments d ON de.dept_no = d.dept_no
JOIN 
    employees e ON de.emp_no = e.emp_no;

-- First,Last Name/ Sex/ employees whose first name is Hercules and last name starts with a B. 

SELECT 
    first_name,
    last_name,
    sex
FROM 
    employees
WHERE 
    first_name = 'Hercules'
    AND last_name LIKE 'B%';


-- Employees in the Sales Department, employee #, first and last name 

SELECT 
    e.emp_no,
    e.last_name,
    e.first_name
FROM 
    dept_emp de
JOIN 
    departments d ON de.dept_no = d.dept_no
JOIN 
    employees e ON de.emp_no = e.emp_no
WHERE 
    d.dept_name = 'Sales';


-- Employees in the Sales and Development departments, employee #, first and last name, and department name 

SELECT 
    e.emp_no,
    e.last_name,
    e.first_name,
    d.dept_name
FROM 
    dept_emp de
JOIN 
    departments d ON de.dept_no = d.dept_no
JOIN 
    employees e ON de.emp_no = e.emp_no
WHERE 
    d.dept_name IN ('Sales', 'Development');


-- Frequency Counts, in descending order, of all of the employee names

SELECT 
    last_name,
    COUNT(*) AS frequency
FROM 
    employees
GROUP BY 
    last_name
ORDER BY 
    frequency DESC;



