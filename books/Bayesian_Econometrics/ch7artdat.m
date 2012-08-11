%Simulate artificial panel data set with intercept plus 1 explanatory variable
%This is used for making the data sets for the first part of Chapter 7
%By making various choices below this can generate data from individual
%effects or random coefficients models

n=100;
t=5;
tn=t*n;

%Data set 1 has intercept varying according to Normal
%Data set 2 has intercept varying according to a mixture of 2 values
%Data set 3 has intercept and slope varying according to Normal
%decide which data set to generate
dataset=2;
if dataset==1 | dataset==3
theta = [0; 2];
capsig= .25*eye(2);
sigma=.2;
end
if dataset==2
pidraw=.75*ones(2,1);
pidraw(2,1)=.25;
theta1 = [1; 2];
theta2 = [-1; 2];
sigma=.2;
end


%stack data sets with orering such that all t observations on individual are together
%Generate artificial data on the explanatory variable
x=[ones(tn,1) rand(tn,1)];
for i=1:n
    if dataset==1
   thetai(1,1) = theta(1,1) + norm_rnd(capsig(1,1));
   thetai(2,1)=theta(2,1);
end
  if dataset==3
   thetai = theta + norm_rnd(capsig);
end
if dataset==2
if rand<pidraw(1,1)
    thetai=theta1;
else
    thetai=theta2;
end
end
   
   y(1+t*(i-1):i*t,1)= x(1+t*(i-1):i*t,:)*thetai+sigma*norm_rnd(eye(t));    
end
data = [y x];
save ch7data2.out data -ASCII;
