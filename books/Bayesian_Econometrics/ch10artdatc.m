%Simulate artificial data set for third empirical illustration in Chapter 10
%Mixtures of Normals models
n=200;

%one component mixture
alpha1=1;
sigma1=.5;
for i=1:n
    y(i,1)= alpha1 + sigma1*randn;
end
y1=y;

%two component mixture
alpha1=1;
alpha2=-1;
sigma1=.5;
sigma2=.25;
p1=.25;
p2=.75;

for i=1:n
    if rand <p1
    y(i,1)= alpha1 + sigma1*randn;
else
     y(i,1)= alpha2 + sigma2*randn;
end
end
y2=y;

%three component mixture
alpha1=1;
alpha2=0;
alpha3=-1;
sigma1=.25;
sigma2=.25;
sigma3=.5;
p1=.25;
p2=.5;
p3=1-p1-p2;

for i=1:n
    unif=rand;
    if unif <p1
    y(i,1)= alpha1 + sigma1*randn;
elseif unif < (p1+p2)
     y(i,1)= alpha2 + sigma2*randn;
 else
      y(i,1)= alpha3 + sigma3*randn;
end
end
y3=y;

%Above 3 data sets have been generated
%Here choose one of them 
y=y3;
save ch10datac.out y  -ASCII;

hist(y,20)
