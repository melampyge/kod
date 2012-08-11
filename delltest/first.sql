select 
o.orderid, 
first_value(o.orderid) over (partition by o.customerid order by o.orderdate) as first_order_id,
o.customerid,
o.totalamount
from orders o
order by customerid
limit 100
