/* Query 1 */
SELECT s.name rep_name, a.name account_name, r.name region
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r 
ON r.id = s.region_id
WHERE r.name = 'Midwest'
ORDER BY 2;

/* Query 2 */
SELECT s.name rep_name, a.name account_name, r.name region
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r 
ON r.id = s.region_id
WHERE s.name LIKE 'S%' AND r.name = 'Midwest'
ORDER BY 2;

/* Query 3 */
SELECT s.name rep_name, a.name account_name, r.name region
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN region r 
ON r.id = s.region_id
WHERE s.name LIKE '% K%' AND r.name = 'Midwest'
ORDER BY 2;

/*Query 4 */ 
SELECT (o.total_amt_usd / (o.total + 0.01)) unit_price, a.name account_name, r.name region
FROM orders o
JOIN accounts a
On a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE o.standard_qty > 100
ORDER BY 1 DESC;

/*Query 5 */ 
SELECT (o.total_amt_usd / (o.total + 0.01)) unit_price, a.name account_name, r.name region
FROM orders o
JOIN accounts a
On a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY 1 DESC;

/*Query 6 */ 
SELECT DISTINCT w.channel, a.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
WHERE a.id = 1001;

/*Query 7 */ 
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2015-1-1' AND '2016-1-1'
ORDER BY 1;

/*Query 8 */ 
SELECT sales_rep_id, name, primary_poc
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom')

/*Query 9 */ 
SELECT id, account_id, total,
RANK()
OVER(PARTITION BY account_id ORDER BY total desc) total_rank
FROM orders;

/*Query 10 */ 
SELECT *
FROM accounts a1
WHERE name = 'Walmart'
UNION 
SELECT *
FROM accounts a2
WHERE name = 'Disney';