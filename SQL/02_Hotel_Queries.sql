 --Q1: Last booked room for each user
SELECT user_id, room_no
FROM (
    SELECT user_id, room_no,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
    FROM bookings
) t
WHERE rn = 1;


-- Q2: Booking_id & total billing (Nov 2021)
SELECT bc.booking_id,
       SUM(i.item_rate * bc.item_quantity) AS total_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
JOIN bookings b ON bc.booking_id = b.booking_id
WHERE MONTH(b.booking_date) = 11 AND YEAR(b.booking_date) = 2021
GROUP BY bc.booking_id;


-- Q3: Bills >1000 in Oct 2021
SELECT bill_id,
       SUM(i.item_rate * bc.item_quantity) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bill_date) = 10 AND YEAR(bill_date) = 2021
GROUP BY bill_id
HAVING SUM(i.item_rate * bc.item_quantity) > 1000;


-- Q4: Most & least ordered item each month
WITH item_counts AS (
    SELECT 
        MONTH(bill_date) AS month,
        item_id,
        SUM(item_quantity) AS total_qty,
        RANK() OVER (PARTITION BY MONTH(bill_date) ORDER BY SUM(item_quantity) DESC) AS rnk_desc,
        RANK() OVER (PARTITION BY MONTH(bill_date) ORDER BY SUM(item_quantity) ASC) AS rnk_asc
    FROM booking_commercials
    WHERE YEAR(bill_date) = 2021
    GROUP BY MONTH(bill_date), item_id
)
SELECT *
FROM item_counts
WHERE rnk_desc = 1 OR rnk_asc = 1;


-- Q5: Second highest bill per month
WITH bill_values AS (
    SELECT 
        MONTH(bill_date) AS month,
        b.user_id,
        SUM(i.item_rate * bc.item_quantity) AS total_bill,
        DENSE_RANK() OVER (PARTITION BY MONTH(bill_date) ORDER BY SUM(i.item_rate * bc.item_quantity) DESC) AS rnk
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bill_date) = 2021
    GROUP BY MONTH(bill_date), b.user_id
)
SELECT *
FROM bill_values
WHERE rnk = 2;
