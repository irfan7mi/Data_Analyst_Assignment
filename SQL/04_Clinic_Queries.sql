--B. Clinic Management System

--1. Revenue per Sales Channel (Year 2021)

SELECT sales_channel, SUM(amount) as revenue
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY sales_channel;


--2. Top 10 Most Valuable Customers (Year 2021)

SELECT 
    c.uid, 
    c.name, 
    SUM(s.amount) AS total_spent
FROM customer c
JOIN clinic_sales s ON c.uid = s.uid
WHERE YEAR(s.datetime) = 2021
GROUP BY c.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;


--3. Month-wise Profit/Loss Statement (Year 2021)

WITH MonthlyRevenue AS (
    SELECT MONTH(datetime) AS month, SUM(amount) AS rev
    FROM clinic_sales WHERE YEAR(datetime) = 2021 GROUP BY 1
),
MonthlyExpense AS (
    SELECT MONTH(datetime) AS month, SUM(amount) AS exp
    FROM expenses WHERE YEAR(datetime) = 2021 GROUP BY 1
)
SELECT 
    m.month,
    COALESCE(r.rev, 0) AS revenue,
    COALESCE(e.exp, 0) AS expense,
    (COALESCE(r.rev, 0) - COALESCE(e.exp, 0)) AS profit,
    CASE 
        WHEN (COALESCE(r.rev, 0) - COALESCE(e.exp, 0)) > 0 THEN 'profitable' 
        ELSE 'not-profitable' 
    END AS status
FROM (SELECT DISTINCT MONTH(datetime) AS month FROM clinic_sales WHERE YEAR(datetime) = 2021) m
LEFT JOIN MonthlyRevenue r ON m.month = r.month
LEFT JOIN MonthlyExpense e ON m.month = e.month
ORDER BY m.month;


--4. Most Profitable Clinic per City (Month 09, Year 2021)

WITH ClinicProfit AS (
    SELECT 
        c.city, 
        c.clinic_name,
        (SUM(IFNULL(s.amount, 0)) - (SELECT SUM(amount) FROM expenses e WHERE e.cid = c.cid AND MONTH(datetime) = 9 AND YEAR(datetime) = 2021)) AS net_profit
    FROM clinics c
    LEFT JOIN clinic_sales s ON c.cid = s.cid AND MONTH(s.datetime) = 9 AND YEAR(s.datetime) = 2021
    GROUP BY c.cid
),
RankedClinics AS (
    SELECT *, 
           RANK() OVER(PARTITION BY city ORDER BY net_profit DESC) as rnk
    FROM ClinicProfit
)
SELECT city, clinic_name, net_profit
FROM RankedClinics
WHERE rnk = 1;


--5. Second Least Profitable Clinic per State (Month 09, Year 2021)

WITH StateProfit AS (
    SELECT 
        c.state, 
        c.clinic_name,
        (SUM(IFNULL(s.amount, 0)) - (SELECT SUM(IFNULL(amount, 0)) FROM expenses e WHERE e.cid = c.cid AND MONTH(datetime) = 9 AND YEAR(datetime) = 2021)) AS net_profit
    FROM clinics c
    LEFT JOIN clinic_sales s ON c.cid = s.cid AND MONTH(s.datetime) = 9 AND YEAR(s.datetime) = 2021
    GROUP BY c.cid
),
RankedStateClinics AS (
    SELECT *, 
           DENSE_RANK() OVER(PARTITION BY state ORDER BY net_profit ASC) as rnk
    FROM StateProfit
)
SELECT state, clinic_name, net_profit
FROM RankedStateClinics
WHERE rnk = 2;