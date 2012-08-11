function skewkurt = ch5ppred(parm,ystar,fgamma,n)
%Given a data set (either observed or simulated), evaluate skewness
%and kurtosis stats which are used for posterior predictive p-values

errors=ystar - fgamma;
errors2=errors.^2;
errors3=errors.^3;
errors4=errors.^4;
skew = sqrt(n)*sum(errors3)/(sum(errors2)^1.5);
kurt = n*sum(errors4)/(sum(errors2)^2) -3;
skewkurt = [skew kurt];




