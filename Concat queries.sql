/* Query 1 */
SELECT
primary_poc,
CONCAT(
	LEFT(primary_poc, CHARINDEX(' ', primary_poc) - 1),
	'.',
	RIGHT(primary_poc, LEN(primary_poc) - CHARINDEX(' ', primary_poc)),
	'@',
	name,
	'.com') AS email
FROM accounts;

/* Query 2 */
SELECT 
lower(CONCAT(
	LEFT(primary_poc, CHARINDEX(' ', primary_poc) - 1),
	'.',
	RIGHT(primary_poc, LEN(primary_poc) - CHARINDEX(' ', primary_poc)),
	'@',
	REPLACE(name, ' ', ''),
	'.com')) AS email
FROM accounts;


/* Query 3 */
SELECT *,
CONCAT(lower(LEFT(primary_poc, 1)),
	   lower(RIGHT(LEFT(primary_poc, CHARINDEX(' ', primary_poc) - 1), 1)),
	   lower(LEFT(RIGHT(primary_poc, LEN(primary_poc) - CHARINDEX(' ', primary_poc)), 1)),
	   lower(RIGHT(primary_poc, 1)),
	   LEN(LEFT(primary_poc, CHARINDEX(' ', primary_poc) - 1)),
	   LEN(RIGHT(primary_poc, LEN(primary_poc) - CHARINDEX(' ', primary_poc))),
	   UPPER(REPLACE(name, ' ', ''))) AS initial_pw
FROM accounts