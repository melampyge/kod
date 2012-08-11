%Simulate artificial data set for second empirical illustration in Chapter 10
%Additive partial linear model
n=100;

%generate x --- i.i.d. Uniform
x=rand(n,2);

sigma2=.09;

for i=1:n
    y(i,1)= x(i,1)*cos(4*pi*x(i,1)) + sin(2*pi*x(i,2))+sqrt(sigma2)*randn;
end

data = [y x];
save ch10datab.out data  -ASCII;

plot(x,y,'.')
