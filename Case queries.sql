/*Query 1 */
SELECT account_id, total_amt_usd,
	   CASE WHEN total_amt_usd >= 3000 THEN 'Large'
	   ELSE 'Small' END AS level_of_orders
FROM orders
ORDER BY level_of_orders, 2 DESC;

/*Query 2 */
SELECT CASE
WHEN total_amt_usd >= 2000 THEN 'Atleast 200'
WHEN total_amt_usd < 200 AND total_amt_usd >= 100 THEN 'Between 1000 and 2000'
ELSE 'Less than 1000'
END AS level_of_orders, COUNT(*)
FROM orders
GROUP BY CASE
WHEN total_amt_usd >= 2000 THEN 'Atleast 200'
WHEN total_amt_usd < 200 AND total_amt_usd >= 100 THEN 'Between 1000 and 2000'
ELSE 'Less than 1000'
END
ORDER BY 2 DESC;

/*Query 3 */
SELECT a.name account_name, SUM(o.total_amt_usd) total_spend,
	CASE
		WHEN SUM(o.total_amt_usd) > 200000 THEN 'Greater than 200000'
		WHEN SUM(o.total_amt_usd) <= 200000 AND SUM(o.total_amt_usd) >= 100000 THEN 'Between 100000 and 20000'
		ELSE 'Under 100000'
		END AS levels
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY 2 DESC;

/*Query 4 */
SELECT a.name account_name, SUM(o.total_amt_usd) total_spend,
	CASE
		WHEN SUM(o.total_amt_usd) > 200000 THEN 'Greater than 200000'
		WHEN SUM(o.total_amt_usd) <= 200000 AND SUM(o.total_amt_usd) >= 100000 THEN 'Between 100000 and 20000'
		ELSE 'Under 100000'
		END AS levels
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2018-01-01'
GROUP BY a.name
ORDER BY 2 DESC;

/*Query 5 */
SELECT *,
	CASE WHEN number > 200 THEN 'top'
	ELSE 'not' END AS top_or_not
FROM (
	SELECT s.name AS rep_name, COUNT(*) AS number
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s
	ON s.id = a.sales_rep_id
	GROUP BY s.name) AS topnot
ORDER BY top_or_not DESC, number DESC;

/*Query 6 */
SELECT *,
	CASE WHEN number > 200 OR total_sales > 750000 THEN 'Top'
	WHEN (number > 150 AND number <= 200) OR (total_sales > 500000 AND total_sales <= 750000) THEN 'Middle'
	ELSE 'Low' END AS TMN
FROM (
	SELECT s.name AS rep_name, COUNT(*) AS number, SUM(total_amt_usd) AS total_sales
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s
	ON s.id = a.sales_rep_id
	GROUP BY s.name) AS t1
	ORDER BY total_sales DESC, number DESC;
