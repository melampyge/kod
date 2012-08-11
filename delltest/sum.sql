select 
o.orderid, 
o.customerid,
o.totalamount, 
sum(o.totalamount) over (partition by o.customerid ) as sum,
o.orderdate
from orders o
order by customerid
limit 100
