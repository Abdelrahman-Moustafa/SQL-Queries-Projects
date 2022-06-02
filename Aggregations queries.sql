/*Query 1 */
SELECT TOP 2 *
FROM (
	SELECT TOP 3457 total_amt_usd
	FROM orders
	ORDER BY 1) AS t1
ORDER BY 1 DESC;

/*Query 2 */
SELECT a.name, sum(o.total_amt_usd) AS total_sales
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY 2 DESC;

/*Query 3 */
SELECT channel, COUNT(*) AS times_channel_used
FROM web_events
GROUP BY channel
ORDER BY 2 DESC;

/*Query 4 */
SELECT TOP 1 a.name, MIN(o.total_amt_usd) smallest_order
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY 2;

/*Query 5 */
SELECT r.name AS region_name, COUNT(*) number_of_sales_reps
FROM sales_reps s
JOIN region r
ON r.id = s.region_id
GROUP by r.name
ORDER BY 2 DESC;

/*Query 6 */
SELECT s.name rep_name, w.channel, count(*) AS occurrences
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY 2, 3 DESC;

/*Query 7 */
SELECT s.name, COUNT(*)
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
HAVING COUNT(*) > 5
ORDER BY 2 DESC;

/*Query 8 */
SELECT a.name, SUM(o.total_amt_usd) AS total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id 
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY 2 DESC;

/*Query 9 */
SELECT a.name, COUNT(*) total_users_facebook
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.name, w.channel
HAVING COUNT(*) > 6
ORDER BY 2 DESC;

/*Query 10 */
SELECT w.channel, COUNT(DISTINCT a.name) AS total_channel_users
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY w.channel
ORDER BY 2 DESC;