-- Q1: Revenue per sales channel
SELECT sales_channel, SUM(amount) AS revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;


-- Q2: Top 10 customers
SELECT uid, SUM(amount) AS total_spent
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;


-- Q3: Month-wise revenue, expense, profit
SELECT 
    MONTH(cs.datetime) AS month,
    SUM(cs.amount) AS revenue,
    SUM(e.amount) AS expense,
    SUM(cs.amount) - SUM(e.amount) AS profit,
    CASE 
        WHEN SUM(cs.amount) - SUM(e.amount) > 0 THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM clinic_sales cs
JOIN expenses e ON cs.cid = e.cid 
    AND MONTH(cs.datetime) = MONTH(e.datetime)
GROUP BY MONTH(cs.datetime);


-- Q4: Most profitable clinic per city
WITH profit_calc AS (
    SELECT 
        c.city,
        c.cid,
        SUM(cs.amount) - SUM(e.amount) AS profit,
        RANK() OVER (PARTITION BY c.city ORDER BY SUM(cs.amount) - SUM(e.amount) DESC) AS rnk
    FROM clinics c
    JOIN clinic_sales cs ON c.cid = cs.cid
    JOIN expenses e ON c.cid = e.cid
    GROUP BY c.city, c.cid
)
SELECT *
FROM profit_calc
WHERE rnk = 1;


-- Q5: Second least profitable clinic per state
WITH profit_calc AS (
    SELECT 
        c.state,
        c.cid,
        SUM(cs.amount) - SUM(e.amount) AS profit,
        DENSE_RANK() OVER (PARTITION BY c.state ORDER BY SUM(cs.amount) - SUM(e.amount)) AS rnk
    FROM clinics c
    JOIN clinic_sales cs ON c.cid = cs.cid
    JOIN expenses e ON c.cid = e.cid
    GROUP BY c.state, c.cid
)
SELECT *
FROM profit_calc
WHERE rnk = 2;
