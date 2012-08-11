%Simulate artificial data set for probit empirical illustration in Chapter 9

n=100;

%generate explanatory variable
x= rand(n,1);
beta=.5;
sigma1=1;
for i=1:n
    temp= beta*x(i,1) + sigma1*randn;
    if temp<0
        y(i,1)=0;
    else
        y(i,1)=1;
    end
end

keepdata=[y x];
save ch9datab.dat keepdata  -ASCII;

