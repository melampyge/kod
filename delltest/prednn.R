library(nnet)
data <- read.csv ("/home/burak/dell.csv",header=TRUE,sep=",")
attach(data)

nn <- nnet(formula = last_visit ~ month + netamount + gender +
      	    day + day_of_week + totalamount + rank + 
	    per_customer_count + total_total_amount +
            income +  season  + cat_freq,
	   data=data,linout=TRUE,size=25,decay=1.5,maxit=10000)

print (summary(nn))

data.validate <- read.csv ("/home/burak/dell-validate.csv",header=TRUE,sep=",")
estimate = predict (nn, newdata=data.validate)

rmse <- sqrt(sum((data.validate$last_visit-estimate)^2)
        /length(data.validate$last_visit)) 
print(paste("RMSE: ", rmse))

# 53