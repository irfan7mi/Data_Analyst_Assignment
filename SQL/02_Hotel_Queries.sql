--A. Hotel Management System

--1. Last booked room for every user

SELECT DISTINCT ON (user_id) user_id, room_no
FROM bookings
ORDER BY user_id, booking_date DESC;


--2. November 2021 Bookings & Total Billing

SELECT b.booking_id, SUM(bc.item_quantity * i.item_rate) AS total_billing
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE b.booking_date BETWEEN '2021-11-01' AND '2021-11-30 23:59:59'
GROUP BY b.booking_id;


--3. October 2021 Bills > 1000

SELECT bill_id, SUM(item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bill_date BETWEEN '2021-10-01' AND '2021-10-31'
GROUP BY bill_id
HAVING SUM(item_quantity * i.item_rate) > 1000;


--4. Most/Least Ordered Items per Month (2021)

WITH MonthlyCounts AS (
    SELECT 
        EXTRACT(MONTH FROM bill_date) AS month,
        item_id,
        SUM(item_quantity) AS total_qty,
        RANK() OVER(PARTITION BY EXTRACT(MONTH FROM bill_date) ORDER BY SUM(item_quantity) DESC) as rnk_desc,
        RANK() OVER(PARTITION BY EXTRACT(MONTH FROM bill_date) ORDER BY SUM(item_quantity) ASC) as rnk_asc
    FROM booking_commercials
    WHERE EXTRACT(YEAR FROM bill_date) = 2021
    GROUP BY 1, 2
)
SELECT month, item_id, total_qty,
       CASE WHEN rnk_desc = 1 THEN 'Most Ordered' ELSE 'Least Ordered' END as status
FROM MonthlyCounts
WHERE rnk_desc = 1 OR rnk_asc = 1;


--5. Second Highest Bill per Month (2021)

WITH RankedBills AS (
    SELECT 
        EXTRACT(MONTH FROM bill_date) AS month,
        booking_id,
        SUM(item_quantity * i.item_rate) as total_val,
        DENSE_RANK() OVER(PARTITION BY EXTRACT(MONTH FROM bill_date) ORDER BY SUM(item_quantity * i.item_rate) DESC) as rnk
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE EXTRACT(YEAR FROM bill_date) = 2021
    GROUP BY 1, 2
)
SELECT month, booking_id, total_val
FROM RankedBills
WHERE rnk = 2;