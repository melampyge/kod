select 
rank() over (partition by o.customerid order by ol.orderlineid) as rank,
count(*) over (partition by o.customerid) as per_customer_count,
sum(o.totalamount) over (partition by o.customerid) as total_total_amount,
o.orderid, 
o.customerid, 
o.totalamount,
o.netamount,
c.zip,
'c' || c.creditcardtype as creditcardtype,
c.gender,
c.age,
c.income,
o.orderdate,
cat.categoryname,
extract(year from o.orderdate) as year,
extract(month from o.orderdate) as month,
extract(day from o.orderdate) as day,
extract(dow from o.orderdate)+1 as day_of_week,
case when extract(month from o.orderdate) in (3,4,5) then 'SPRING' 
     when extract(month from o.orderdate) in (6,7,8) then 'SUMMER'
     when extract(month from o.orderdate) in (9,10,11) then 'AUTUMN'
     when extract(month from o.orderdate) in (12,1,2) then 'WINTER' 
     end as season,
extract('epoch' from (((first_last.max::timestamp - first_last.min::timestamp) / first_last.orders)) / 60 / 60 / 24) as frequency,
extract('epoch' from (((first_last.max::timestamp - first_last.min::timestamp))) / 60 / 60 / 24) as time_on_site,
count(*) over (partition by o.customerid,cat.categoryname) as cat_freq,
first_last.min,
first_last.max,
extract('epoch' from ('2005-01-01'::timestamp - first_last.max)) / 60 / 60 / 24 as last_visit
from orders o
join customers c on o.customerid = c.customerid
join orderlines ol on ol.orderid = o.orderid
join products p on ol.prod_id = p.prod_id
join categories cat on p.category = cat.category
left outer join
(
 select o.orderid as oid,
 min(o.orderdate) over (partition by o.customerid) as min,
 max(o.orderdate) over (partition by o.customerid) as max,
 count(*) over (partition by o.customerid) as orders
 from orders o
) as first_last on first_last.oid = o.orderid
order by customerid,orderlineid
