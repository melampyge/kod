data <- read.csv ("/home/burak/dell.csv",header=TRUE,sep=",")
attach (data)

model <- lm(formula = last_visit ~ month + netamount + gender +
      	    day + day_of_week + totalamount + rank + categoryname +
	    per_customer_count + total_total_amount +
            income +  season  + cat_freq + creditcardtype)
print (summary(model))

plot(last_visit, resid(model))

#data.validate <- read.csv ("/home/burak/dell-validate.csv",header=TRUE,sep=",")
#estimate = predict (model, newdata=data.validate)
#
#rmse <- sqrt(sum((data.validate$last_visit-estimate)^2)
#        /length(data.validate$last_visit)) 
#print(paste("RMSE: ", rmse))
#plot(estimate, data.validate$last_visit)


