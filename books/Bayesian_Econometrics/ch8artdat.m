%Simulate artificial data set for local level model in Chapter 8

t=100;
%initial condition
alpha1=1;
%error variance in observation equation
sigma2=1;
%eta --- note: error variance in state equation is eta*sigma2
eta=100;

alpha=zeros(t+1,1);
alpha(1,1)=alpha1;

for i=1:t
    y(i,1)= alpha(i,1) + sqrt(sigma2)*randn;
    alpha(i+1,1)=alpha(i,1) + sqrt(eta*sigma2)*randn;
end


save ch8data3.out y -ASCII;

plot(y)
