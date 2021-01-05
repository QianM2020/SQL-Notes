# COUNT, SUM, MIN, MAX, AVG, Group by,Distinct

# get MEDIAN
select total_amt_usd
from
(select total_amt_usd
from orders
order by total_amt_usd
limit 3457)sb
order by total_amt_usd desc
limit 2

#GROUP by 2 or more cols, using ,
select sr.name, we.channel,count(we.occurred_at)
from sales_reps sr
join accounts ac
on ac.sales_rep_id = sr.id
join web_events we
on we.account_id = ac.id
group by sr.name,we.channel

#HAVING appears after GROUP BY, before ORDER BY. WHERE before GROUP BY.
#Most order accont
select ac.id, count(*)
from accounts ac
join orders od
on od.account_id = ac.id
group by ac.id
order by count(*) desc
limit 1

# DATE Function:
#   DATE_TRUNC('day',date) month, year, second
#   DATE_PART(('day',date)) take the day part or month, year, second,'dow'- day of the week
SELECT DATE_PART('year', occurred_at) ord_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

#CASE STATEMENTS
SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;

# SUBQUERY
SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders) # no need as for condition, but need as like 'sub' for FROM

# WITH (CTE) define SUBQUERY by 'WITH <sub> AS ()' first

WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day,
                        channel, COUNT(*) as events
          FROM web_events
          GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;

#Define 2 or more tables
WITH table1 AS (
          SELECT *
          FROM web_events), # 'comma'

     table2 AS (            # No WITH
          SELECT *
          FROM accounts)
