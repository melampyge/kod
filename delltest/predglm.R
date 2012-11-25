data <- read.csv ("/home/burak/dell.csv",header=TRUE,sep=",")
attach (data)

model <- glm(formula = last_visit ~ month + netamount + gender +
      	    day + day_of_week + totalamount + rank + categoryname +
	    per_customer_count + total_total_amount +
            income +  season  + cat_freq + creditcardtype,
	    family=Gamma(link="log")
	    )
print (summary(model))

data.validate <- read.csv ("/home/burak/dell-validate.csv",header=TRUE,sep=",")
estimate = predict (model, newdata=data.validate)

rmse <- sqrt(sum((data.validate$last_visit-exp(estimate))^2)
        /length(data.validate$last_visit)) 
print(paste("RMSE: ", rmse))

