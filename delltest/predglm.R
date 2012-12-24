data <- read.csv ("/home/burak/dell.csv",header=TRUE,sep=",")
attach (data)

model <- glm(formula = last_visit ~ month + netamount + gender + day +
      	    day_of_week + totalamount + rank + categoryname + time_on_site +
      	    per_customer_count + total_total_amount + income + season +
      	    cat_freq + creditcardtype + frequency + season:rank + 
       	    frequency:rank + frequency:season + frequency:per_customer_count +
	    frequency:total_total_amount + frequency:time_on_site +
	    frequency:month 
	    ,
      	    family=gaussian(link="log") )

print (summary(model))

data.validate <- read.csv ("/home/burak/dell-validate.csv",header=TRUE,sep=",")
estimate = predict (model, newdata=data.validate)
estimate = exp(estimate)

diff = abs(data.validate$last_visit-estimate)
error <- sum(diff) / length(diff)
print (error)
