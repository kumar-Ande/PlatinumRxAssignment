
-- A1
SELECT user_id, room_no
FROM (
    SELECT user_id, room_no,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) rn
    FROM bookings
) t WHERE rn=1;

-- A2
SELECT b.booking_id, SUM(bc.item_quantity*i.item_rate) total_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id=bc.booking_id
JOIN items i ON bc.item_id=i.item_id
WHERE MONTH(b.booking_date)=11 AND YEAR(b.booking_date)=2021
GROUP BY b.booking_id;

-- A3
SELECT bc.bill_id, SUM(bc.item_quantity*i.item_rate) bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id=i.item_id
WHERE MONTH(bc.bill_date)=10 AND YEAR(bc.bill_date)=2021
GROUP BY bc.bill_id
HAVING bill_amount>1000;

-- A4
WITH t AS (
SELECT MONTH(bill_date) m, item_id,
SUM(item_quantity) qty,
RANK() OVER(PARTITION BY MONTH(bill_date) ORDER BY SUM(item_quantity) DESC) r1,
RANK() OVER(PARTITION BY MONTH(bill_date) ORDER BY SUM(item_quantity)) r2
FROM booking_commercials
GROUP BY MONTH(bill_date), item_id)
SELECT * FROM t WHERE r1=1 OR r2=1;

-- A5
WITH t AS (
SELECT MONTH(bc.bill_date) m, b.user_id,
SUM(bc.item_quantity*i.item_rate) amt,
RANK() OVER(PARTITION BY MONTH(bc.bill_date) ORDER BY SUM(bc.item_quantity*i.item_rate) DESC) r
FROM booking_commercials bc
JOIN bookings b ON bc.booking_id=b.booking_id
JOIN items i ON bc.item_id=i.item_id
GROUP BY MONTH(bc.bill_date), b.user_id)
SELECT * FROM t WHERE r=2;
