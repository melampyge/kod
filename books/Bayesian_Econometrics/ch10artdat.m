%Simulate artificial data set for empirical illustration in Chapter 10

n=100;

%generate x --- i.i.d. Uniform
x=rand(n,1);

sigma2=.09;

for i=1:n
    y(i,1)= x(i,1)*cos(4*pi*x(i,1)) + sqrt(sigma2)*randn;
end

data = [y x];
save ch10data.out data  -ASCII;

plot(x,y,'.')
