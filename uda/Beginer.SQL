# LIMIT show limited rows
select occurred_at, account_id, channel
from web_events
limit 15

# WHERE with non-numeric data fields, we use the LIKE (%), NOT, IN,
#AND & BETWEEN (includinng 2 end points)

#eg select names including L
select *
from accounts
where name like '%L%'

select name, primary_poc, sales_rep_id
from accounts
where name in ('Walmart','Target','Nordstrom') # don't forget "" for non-numeric

select *
from accounts
where name not in ('C%','%s')  # find all names not start with 'C' and end with 's'.

# Join (INNER JOIN)  Intersection, Outer JOIN Union, Left JOIN A, Right JOIN B
# we can add condition in 'on' clause

#JOIN 2 tables
SELECT r.name region, a.name account,
       o.total_amt_usd/(o.total + 0.01) unit_price # using _
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;

# DISTINCT can work on 2 or more cols.
select distinct ac.name,channel
from web_events we
join accounts ac
on we.account_id = ac.id
and ac.id = 1001

# DATE type : between '2015-01-01' and '2015-12-31'
