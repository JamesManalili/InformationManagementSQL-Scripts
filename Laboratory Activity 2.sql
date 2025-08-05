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

-- Employees and their job titles
SELECT e.empno, e.firstname, e.lastname, j.jobDesc
FROM employee e
JOIN jobHistory h ON e.empno = h.empNo
JOIN job j ON h.jobCode = j.jobCode;

-- Employees and their latest job titles -Window Function
WITH LatestJobs AS (
    SELECT empNo, jobCode,
        ROW_NUMBER() OVER (PARTITION BY empNo ORDER BY effDate DESC) AS rn
    FROM jobHistory
)
SELECT e.empno, e.firstname, e.lastname, j.jobDesc
FROM employee e
JOIN LatestJobs lj ON e.empno = lj.empNo AND lj.rn = 1
JOIN job j ON lj.jobCode = j.jobCode;

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

-- All employees and their job history (if any) LEFT JOIN – All rows from the left table + matches from the right
SELECT e.empno, e.firstname, h.jobCode
FROM employee e
LEFT JOIN jobHistory h ON e.empno = h.empNo;

-- All job history records and employee names (even if employee was deleted)
SELECT h.empNo, e.firstname, h.jobCode
FROM jobHistory h
RIGHT JOIN employee e ON h.empNo = e.empno;

-- Simulate FULL OUTER JOIN (use UNION)
SELECT e.empno, e.firstname, h.jobCode
FROM employee e
LEFT JOIN jobHistory h ON e.empno = h.empNo

UNION

SELECT h.empNo, e.firstname, h.jobCode
FROM jobHistory h
RIGHT JOIN employee e ON h.empNo = e.empno;

-- SCRIPT 4 --
SELECT YEAR (payDate) "YEAR", transNo, SUM(amount) "TOTAL PAYMENT"
FROM payment
WHERE amount >= 1000
GROUP BY YEAR (payDate), transNo
ORDER BY YEAR(payDate) DESC, SUM(amount) DESC;

-- SCRIPT 3
SELECT transNo, SUM(quantity) "TOTAL QUANTITY"
FROM receiptDetail
GROUP BY transNo
ORDER BY SUM(quantity) DESC;

-- SCRIPT 5 --
SELECT prodCode, COUNT(unitPrice) "MULTIPLE CHANGES"
FROM priceHist
GROUP BY prodCode
HAVING COUNT (unitPrice) > 1
ORDER BY COUNT(unitPrice) DESC;

-- SQL SCRIPT 1: List the transaction number, sales date,
-- product code, description, unit and quantity from the hope database.
-- Sort according to transaction number and product code. Use LEFT JOIN in your solution

SELECT s.transNo, s.salesDate, p.prodCode, p.description, p.unit, sd.quantity
FROM sales s
LEFT JOIN salesDetail sd
ON s.transNo = sd.transNo
LEFT JOIN product p
ON sd.prodCode = p.prodCode
ORDER BY 1, 3;

-- SQL SCRIPT 2: Display the employee number, last name, first name,
-- job description, and effectivity date from the job history of the employee.
-- Sort last name and effectivity date (last date first). Use LEFT JOIN.

SELECT e.empNo, e.lastName, e.firstName, j.jobDesc, jh.effDate
FROM employee e
LEFT JOIN jobHistory jh
ON e.empNo = jh.empNo
LEFT JOIN job j
ON jh. jobCode = j. jobCode
ORDER BY 2, 5 DESC;

-- SQL SCRIPT 3: Show total quantity sold from product table.
-- Display product code, description, unit, quantity. Use RIGHT JOIN.
-- Sort according to the most product sold.

SELECT p.prodCode, p.description, p.unit, SUM(sd.quantity) "TOTAL QUANTITY"
FROM salesDetail sd
RIGHT JOIN product p
ON sd. prodCode = p. prodCode
GROUP BY p.prodCode, p.description, p.unit
ORDER BY 4 DESC;

-- SQL SCRIPT 4: Generate the detailed payments made by
-- customers for specific transactions. Display customer number,
-- customer name, payment date, official receipt no, transaction number
-- and payment amount. Sort according to the customer name. Use LEFT JOIN.

SELECT c.custNo, c.custName, p.payDate, p.ORNo, s.transNo, p.amount
FROM customer c
LEFT JOIN sales s
ON c.custNo = s.custNo
LEFT JOIN payment p
ON s.transNo = p.transNo
ORDER BY 2;

-- SQL SCRIPT 5: What is the current price of each product?
-- Display product code, product description, unit, and its current price.
-- Always assume that NOT ALL products HAVE unit price BUT you need to display
-- it even if it has no unit price on it. DO NOT USE INNER JOIN.
SELECT p.prodCode, p.description, p.unit, ph.unitPrice "CURRENT PRICE"
FROM product p
LEFT JOIN priceHist ph
ON p. prodCode = ph. prodCode
RIGHT JOIN (SELECT prodCode, MAX(effDate) recentUpdate
    FROM priceHist
    GROUP BY prodCode) ph2
ON p.prodCode = ph2.prodCode AND ph.effdate = ph2.recentUpdate;

