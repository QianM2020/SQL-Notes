# TO_DATE() # change a month name 'Jan' to number 1
#    Correct format of dates in SQL is yyyy-mm-dd

# Concatenate strings by using concat(col,'',col,...) or || '' or col name)

# CAST( as date) transfer data type or using ::
  '100'::INTEGER # transfer string into INTEGER

# LEFT(phone_number, 3) first 3 digits, RIGHT(), LENGTH()

# STRPOS(col,'') same as POSITION ,POSITION('',col) return position index of '' in col# case sensitive
# LOWER , UPPER, REPLACE(col,'a','b') a->b, SUBSTR(date, 7, 4) the 4 digs after 7th

WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,
 RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)

SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com'), LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1)
|| LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1

# COALESCE to work with NULL values, COALESCE(col,'a') replace null with 'a'
#  Is NULL

# WINDOW Function : OVER and PARTITION BY are key, Not every uses PARTITION BY; can also use ORDER BY
# new PARTITION - recalculate, without ORDER By - calculate based on whole PARTITION, ORDER BY based on previous row

SELECT standard_amt_usd,
       DATE_TRUNC('year', occurred_at) as year,
       SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders

# ROW_NUMBER(), RANK() no need arg, OVER(PARTITION BY...ORDER BY..), RANK keep same number while ROW_NUMBER use differnt number
#     RANK() give same value and skip, DENSE_RANK() avoid skip
#     (PARTITION BY...ORDER BY..) can be defined out of a query by WINDOW <wdname> as (PARTITION...), OVER <wdname>

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))

# LAG - return previous row, LEAD - return following row, eg LEAD(standard_sum) OVER (ORDER BY standard_sum)

SELECT account_id,
       standard_sum,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
       standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
SELECT account_id,
       SUM(standard_qty) AS standard_sum
  FROM orders
 GROUP BY 1
 ) sub

 # NTILE Function,  when the number of rows in the partition is < the NTILE(number of groups), list only numbers of rows.

 SELECT
       account_id,
       occurred_at,
       gloss_qty,
       NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
  FROM orders
 ORDER BY account_id DESC

# FULL (OUTER) JOIN - UNION

SELECT column_name(s)
FROM Table_A
FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name
WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL # checkout unmatched rows, union (AB) - intersection(AB)

# SELF JoIN

SELECT we1.id AS we_id,
       we1.account_id AS we1_account_id,
       we1.occurred_at AS we1_occurred_at,
       we1.channel AS we1_channel,
       we2.id AS we2_id,
       we2.account_id AS we2_account_id,
       we2.occurred_at AS we2_occurred_at,
       we2.channel AS we2_channel
  FROM web_events we1
 LEFT JOIN web_events we2 # LEFT - not lose original data
   ON we1.account_id = we2.account_id
  AND we1.occurred_at > we2.occurred_at
  AND we1.occurred_at <= we2.occurred_at + INTERVAL '1 day' # date + Interval
ORDER BY we1.account_id, we2.occurred_at

# UNION - UNION removes duplicate rows, UNION ALL does not remove duplicate rows.
#  2 tables should have same # of cols.,same data type.

WITH double_accounts AS (
    SELECT *
      FROM accounts

    UNION ALL

    SELECT *
      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
 FROM double_accounts
GROUP BY 1
ORDER BY 2 DESC

# TUNING SQL
#  Omake a query run faster is to reduce the number of calculations. Some of the high-level things affect the number of calculations include: Table size,Joins,Aggregations
#  Aggregations done before LIMIT

#EXplain to get query plan, the execution order to estimate running time

 EXplain
 SELECT *
   FROM accounts
