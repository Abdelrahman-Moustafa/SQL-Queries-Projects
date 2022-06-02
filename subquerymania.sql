/* Query 1 - Region wise top sales performers (sales_reps)*/
SELECT t3.region_name, t3.rep_name
FROM (
	SELECT r.name region_name, s.name rep_name, SUM(o.total_amt_usd) sales_made
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s
	ON s.id = a.sales_rep_id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY r.name, s.name) t3
JOIN (
SELECT t1.region_name, MAX(t1.sales_made) max_sales
FROM (
	SELECT r.name region_name,s.name rep_name,  SUM(o.total_amt_usd) Sales_made
	FROM orders o 
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s
	ON s.id = a.sales_rep_id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY r.name,s.name) t1
	GROUP BY t1.region_name) t2
ON t3.sales_made = t2.max_sales;


/* Query 2 - 2357 number of orders in the region with maximum amount of sales*/
SELECT COUNT(*) AS number_of_orders
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE r.name = (SELECT TOP 1 r.name region_name
				FROM orders o
				JOIN accounts a
				ON a.id = o.account_id
				JOIN sales_reps s
				ON s.id = a.sales_rep_id
				JOIN region r
				On r.id = s.region_id
				GROUP BY r.name
				ORDER BY SUM(o.total_amt_usd) DESC)

/* Query 3 - Count the accounts which have total_qty greater than the accounts with max standard_qty purchased */
SELECT COUNT(*) AS total_accounts
FROM (
	SELECT a.name, SUM(o.total) total_qty, SUM(o.standard_qty) standard_qty
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY a.name) t1
WHERE total_qty > (SELECT TOP 1 SUM(o.total)
					FROM orders o
					JOIN accounts a
					ON a.id = o.account_id
					GROUP BY a.name
					ORDER BY SUM(o.standard_qty) DESC);

/*Query 4  - EOG Resources - 12,4,44,11,13,5 - a,b,d,f,o,t*/
SELECT a.name, w.channel, COUNT(*) AS records
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
WHERE a.name = (SELECT TOP 1 a.name account_name
				FROM accounts a
				JOIN orders o
				ON a.id = o.account_id
				JOIN sales_reps s
				ON s.id = a.sales_rep_id
				JOIN region r
				ON r.id = s.region_id
				GROUP BY a.name
				ORDER BY SUM(o.total_amt_usd) DESC)
GROUP BY a.name, w.channel
ORDER BY 3 DESC;


/* Query 5 - Life time avg. amount spent for the top 1- spending amounts */
SELECT t2.account_name, (t2.total_spent / t2.number_of_orders) life_avg_spent
FROM (
	SELECT a.name account_name, sum(o.total_amt_usd) total_spent, count(*) number_of_orders 
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY a.name) t2
JOIN (
SELECT TOP 10 a.name account_name, SUM(o.total_amt_usd) total_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY a.name
ORDER BY 2 DESC) t1
ON t1.account_name = t2.account_name
ORDER BY 2 DESC;

/* Query 6 */
SELECT AVG(total_spent) AS average_spent
FROM (
	SELECT TOP 10 a.name account_name, SUM(o.total_amt_usd) total_spent
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s
	ON s.id = a.sales_rep_id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY a.name
	ORDER BY 2 DESC) t1

/* Query 6 */
SELECT t1.account_name, (t1.total_spent / t1.number_of_orders) life_avg_spent
FROM (
	SELECT a.name account_name, SUM(o.total_amt_usd) total_spent, COUNT(*) number_of_orders
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY a.name) t1
WHERE (t1.total_spent / t1.number_of_orders) > (
	SELECT AVG(total_amt_usd)
	FROM orders)
ORDER BY 2 DESC;

/* Query 7*/
SELECT AVG(avg_amt) avg_amt
FROM (
	SELECT account_id, AVG(total_amt_usd) avg_amt
	FROM orders
	GROUP BY account_id
	HAVING AVG(total_amt_usd) > (
		SELECT AVG(total_amt_usd) avg_all
		FROM orders)) t1;