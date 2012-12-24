data <- read.csv ("/home/burak/dell.csv",header=TRUE,sep=",")
attach (data)

model <- lm(formula = last_visit ~ month + netamount + gender + day +
      	    day_of_week + totalamount + rank + categoryname +
      	    per_customer_count + total_total_amount + income + season
      	    + cat_freq + creditcardtype + frequency )
	    
print (summary(model))

data.validate <- read.csv ("/home/burak/dell-validate.csv",header=TRUE,sep=",")
estimate = predict (model, newdata=data.validate)

diff = abs(data.validate$last_visit-estimate)

error <- sum(diff) / length(diff)
print (error)
