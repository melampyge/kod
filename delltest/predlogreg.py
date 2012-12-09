data <- read.csv ("/home/burak/dell2.csv",header=TRUE,sep=",")
attach (data)

DAYS = 90

dormant <- rep(0, length(data$last_visit))
dormant[data$last_visit > DAYS & data$rank == data$per_customer_count] = 1

fit.1 <- glm(dormant ~ month + netamount + gender + 
      	    day + day_of_week + totalamount + rank + categoryname +
	    total_total_amount + income +  season  + cat_freq +
            creditcardtype 
            ,
	    family=binomial(link="logit"))
	   	   
print (summary(fit.1))

data.validate <- read.csv ("/home/burak/dell-validate.csv",header=TRUE,sep=",")
attach(data.validate)
dormant <- rep(0, length(data.validate$rank))
dormant[data.validate$last_visit > DAYS & data.validate$rank == data.validate$per_customer_count] = 1
total <- length(data.validate$rank)

g <- (predict(fit.1, type="response", data=data.validate)  >= 0.05)

#matches <- sum(dormant[g == TRUE] == 1) + sum(dormant[g == FALSE] == 0)

print (sum(dormant[g == TRUE] == 1) / length(dormant[dormant == 1]) * 100 )

print (sum(dormant[g == FALSE] == 0) / length(dormant[dormant == 0]) * 100 )


