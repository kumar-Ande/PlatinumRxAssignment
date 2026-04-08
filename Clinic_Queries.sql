
-- B1
SELECT sales_channel, SUM(amount) revenue
FROM clinic_sales
WHERE YEAR(datetime)=2021
GROUP BY sales_channel;

-- B2
SELECT uid, SUM(amount) total_spent
FROM clinic_sales
WHERE YEAR(datetime)=2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

-- B3
WITH r AS (
SELECT MONTH(datetime) m, SUM(amount) rev FROM clinic_sales GROUP BY MONTH(datetime)),
e AS (
SELECT MONTH(datetime) m, SUM(amount) exp FROM expenses GROUP BY MONTH(datetime))
SELECT r.m, r.rev, e.exp, (r.rev-e.exp) profit,
CASE WHEN (r.rev-e.exp)>0 THEN 'Profitable' ELSE 'Not Profitable' END status
FROM r JOIN e ON r.m=e.m;

-- B4
WITH t AS (
SELECT c.city, cs.cid,
SUM(cs.amount)-COALESCE(SUM(e.amount),0) profit,
RANK() OVER(PARTITION BY c.city ORDER BY SUM(cs.amount)-COALESCE(SUM(e.amount),0) DESC) r
FROM clinics c
JOIN clinic_sales cs ON c.cid=cs.cid
LEFT JOIN expenses e ON c.cid=e.cid
GROUP BY c.city, cs.cid)
SELECT * FROM t WHERE r=1;

-- B5
WITH t AS (
SELECT c.state, cs.cid,
SUM(cs.amount)-COALESCE(SUM(e.amount),0) profit,
RANK() OVER(PARTITION BY c.state ORDER BY SUM(cs.amount)-COALESCE(SUM(e.amount),0)) r
FROM clinics c
JOIN clinic_sales cs ON c.cid=cs.cid
LEFT JOIN expenses e ON c.cid=e.cid
GROUP BY c.state, cs.cid)
SELECT * FROM t WHERE r=2;
