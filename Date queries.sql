/* Query 1 */
SELECT DATEPART(year, occurred_at) AS years, SUM(total_amt_usd) AS sales_in_that_year
FROM orders
GROUP BY DATEPART(year, occurred_at)
ORDER BY 2 DESC;

/* Query 2 */
SELECT DATEPART(month, occurred_at) AS months, SUM(total_amt_usd) AS sales_in_that_month
FROM orders
GROUP BY DATEPART(month, occurred_at)
ORDER BY 2 DESC

/* Query 3 */
SELECT DATEPART(month, o.occurred_at) AS months, SUM(o.gloss_amt_usd) AS amt_spent_gloss_walmart
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY DATEPART(month, o.occurred_at)
ORDER BY 2 DESC;