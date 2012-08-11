%Simulate artificial data set for tobit empirical illustration in Chapter 9

n=100;

%generate explanatory variable
a=.5;
b=1;

x= a+(b-a)*rand(n,1);
beta=2;
sigma1=.5;
for i=1:n
    y(i,1)= beta*x(i,1) + sigma1*randn;
    if y(i,1)<=0
        y(i,1)=0;
    end
end

keepdata=[y x];
save ch9dataa.dat keepdata  -ASCII;

