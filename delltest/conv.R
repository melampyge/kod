# generate expanded new file for factors, this new file
# can be used easily by Weka and other "pickier" tools that
# have trouble reading missing data, categories
#
orders <- read.csv ("/home/burak/dell.csv",header=TRUE,sep=",")

orders <- orders[, c('rank','per_customer_count','total_total_amount',
'orderid','customerid','totalamount','netamount','creditcardtype',
'gender','age','income','categoryname','year','month','day','time_on_site',
'day_of_week','season','frequency','cat_freq','last_visit')]

orders <- cbind(orders, model.matrix( ~ 0 + rank + per_customer_count
       	  + total_total_amount + orderid + customerid + totalamount +
       	  netamount + creditcardtype + gender + age + income +
       	  categoryname + year + month + day + day_of_week + season +
       	  frequency + time_on_site + cat_freq + last_visit, orders ))

orders <- orders[, setdiff(names(orders), c("creditcardtype", "categoryname","gender","season"))]
write.csv (orders,"/home/burak/dell2.csv")

