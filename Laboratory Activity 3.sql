-- SCRIPT 1
SELECT payterm, COUNT (custname) "CUSTOMER COUNT"
FROM customer
WHERE address LIKE '%CA%'
GROUP BY payterm;

-- Select all employee records
SELECT * FROM employee;

-- Select specific columns
SELECT empno, firstname, lastname FROM employee;

-- Add filtering
SELECT * FROM employee WHERE gender = 'M';

-- Count total employees
SELECT COUNT(*) AS total_employees FROM employee;

-- Average salary of current jobs
SELECT AVG(salary) AS avg_salary FROM jobHistory;

-- Max and Min salary per job
SELECT jobCode, MAX(salary), MIN(salary)
FROM jobHistory
GROUP BY jobCode;

-- GROUP BY: Average salary per department
SELECT deptCode, AVG(salary) AS avg_salary
FROM jobHistory
GROUP BY deptCode;

-- HAVING: Departments with average salary > 50,000
SELECT deptCode, AVG(salary) AS avg_salary
FROM jobHistory
GROUP BY deptCode
HAVING AVG(salary) > 50000;

-- Employees and their latest job titles
SELECT e.empno, e.firstname, e.lastname, j.jobDesc
FROM employee e
JOIN jobHistory h ON e.empno = h.empNo
JOIN job j ON h.jobCode = j.jobCode;

-- Sales transactions with customer and employee info
SELECT s.transNo, s.salesDate, c.custname, e.firstname || ' ' || e.lastname AS employee
FROM sales s
JOIN customer c ON s.custNo = c.custno
JOIN employee e ON s.empNo = e.empno;

-- Employees and their job descriptions INNER JOIN – Returns only matching rows
SELECT e.empno, e.firstname, j.jobDesc
FROM employee e
INNER JOIN jobHistory h ON e.empno = h.empNo
INNER JOIN job j ON h.jobCode = j.jobCode;










