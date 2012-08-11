drop table if exists order_fact;
create table order_fact as (
select 
o.orderid, 
o.customerid, 
o.totalamount, 
c.zip,
c.creditcardtype,
c.gender,
min(o.orderdate) over (partition by o.customerid ) as reg_date,
orderdate
from orders o, customers c
where o.customerid = c.customerid
)
