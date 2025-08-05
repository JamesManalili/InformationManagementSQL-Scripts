--  List all customers and whether they made a purchase
SELECT c.custno, c.custname, s.transNo
FROM customer c
LEFT JOIN sales s ON c.custno = s.custNo;

-- Which employees never made a sale?
SELECT e.empno, e.firstname
FROM employee e
LEFT JOIN sales s ON e.empno = s.empNo
WHERE s.transNo IS NULL;

--Total sales made by each employee
SELECT e.empno, e.firstname, COUNT(s.transNo) AS total_sales
FROM employee e
LEFT JOIN sales s ON e.empno = s.empNo
GROUP BY e.empno, e.firstname
ORDER BY total_sales;

-- Show sales with product quantities
SELECT s.transNo, p.description, sd.quantity
FROM sales s
JOIN salesDetail sd ON s.transNo = sd.transNo
JOIN product p ON sd.prodCode = p.prodCode;

-- Department name and number of employees (min 5)
SELECT d.deptName, COUNT(DISTINCT h.empNo) AS num_employees
FROM jobHistory h
JOIN department d ON h.deptCode = d.deptCode
GROUP BY d.deptName
HAVING COUNT(DISTINCT h.empNo) > 5;

-- Employees whose first job was in 2010
SELECT e.empno, e.firstname || ' ' || e.lastname AS full_name,
       MIN(h.effDate) AS first_job_date, j.jobDesc
FROM employee e
JOIN jobHistory h ON e.empno = h.empNo
JOIN job j ON h.jobCode = j.jobCode
GROUP BY e.empno, e.firstname, e.lastname, j.jobDesc
HAVING MIN(h.effDate) BETWEEN '2010-01-01' AND '2010-12-31';

--Top 3 products by total quantity sold
SELECT p.description, SUM(sd.quantity) AS total_quantity
FROM salesDetail sd
JOIN product p ON sd.prodCode = p.prodCode
GROUP BY p.description
ORDER BY total_quantity DESC
LIMIT 3;

-- Transaction info with total quantity
SELECT s.transNo,
       c.custname,
       e.firstname || ' ' || e.lastname AS employee_name,
       SUM(sd.quantity) AS total_quantity
FROM sales s
JOIN customer c ON s.custNo = c.custno
JOIN employee e ON s.empNo = e.empno
JOIN salesDetail sd ON s.transNo = sd.transNo
GROUP BY s.transNo, c.custname, e.firstname, e.lastname;

--Department with highest average salary
SELECT d.deptName, AVG(h.salary) AS avg_salary
FROM jobHistory h
JOIN department d ON h.deptCode = d.deptCode
GROUP BY d.deptName
ORDER BY avg_salary DESC;

-- Rank Employees by Salary within Department
SELECT h.empNo, d.deptName, h.salary,
       RANK() OVER (PARTITION BY h.deptCode ORDER BY h.salary DESC) AS salary_rank
FROM jobHistory h
JOIN department d ON h.deptCode = d.deptCode;

--Running Total of Payments Per Customer
SELECT c.custno, p.payDate, p.amount,
       SUM(p.amount) OVER (PARTITION BY c.custno ORDER BY p.payDate) AS running_total
FROM payment p
JOIN sales s ON p.transno = s.transNo
JOIN customer c ON s.custNo = c.custno;

--Monthly Sales Volume (Total Quantity)
SELECT DATE_FORMAT(s.salesDate, '%Y-%m') AS sale_month,
       SUM(sd.quantity) AS total_quantity
FROM sales s
JOIN salesDetail sd ON s.transNo = sd.transNo
GROUP BY DATE_FORMAT(s.salesDate, '%Y-%m')
ORDER BY DATE_FORMAT(s.salesDate, '%Y-%m');

--Most Recent Job Title per Employee
WITH latest_jobs AS (
  SELECT h.*, j.jobDesc,
         ROW_NUMBER() OVER (PARTITION BY h.empNo ORDER BY h.effDate DESC) AS rn
  FROM jobHistory h
  JOIN job j ON h.jobCode = j.jobCode
)
SELECT empNo, jobDesc, effDate
FROM latest_jobs
WHERE rn = 1;






















