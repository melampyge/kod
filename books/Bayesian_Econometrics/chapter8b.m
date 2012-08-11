%program which does empirical illustration for chapter 8
%This does empirical Bayesian analysis of local level model using conjugate prior
%This program is very similar to Chapter8a.m, however with this one I use
%one prior and four different data sets
%for each data set I do empirical Bayes to estimate eta 
%then I do posterior analysis for the chosen eta

alpha=[];
ykeep=[];
for idata=1:4
if idata==1
load ch8data1.out;
y=ch8data1(:,1);
end
if idata==2
load ch8data2.out;
y=ch8data2(:,1);
end
if idata==3
load ch8data.out;
y=ch8data(:,1);
end
if idata==4
load ch8data3.out;
y=ch8data3(:,1);
end
t=size(y,1);
ngrid=10000;


    %set up informative prior configuration and then alter below
%Hyperparameters for natural conjugate prior
theta0=zeros(t,1);
theta0(1,1)=1;
v0=.01;
s02=1;
%The prior variance matrix for theta depends on eta so will be modified below
%set v11=-9999 for noninformative choice
v11=-9999;
capv0=v11*eye(t);
capv0inv=inv(capv0);


%specify a few things outside the loop
%The inverse of the first difference matrix
dinv=ones(t-1,t-1);
for i=2:t-1
    dinv(i-1,i:t-1)=zeros(1,t-i);
end
w=ones(t,t);
w(1,2:t)=zeros(1,t-1);
w(2:t,2:t)=dinv;
wsquare=w'*w;

v1=v0+t;



%Search over a grid of values to find eta which maximizes marg likelihood
etagrid = cumsum(.01*ones(ngrid,1));
lmlike=zeros(ngrid,1);

mlmax=-999e200;
etamax=0;
for igrid=1:ngrid
    if v11==-9999
       capv0inv(1,1)=0; 
   end
   capv0inv(2:t,2:t)=(1/etagrid(igrid,1))*eye(t-1); 
   
capv1inv = capv0inv+ wsquare;
capv1=inv(capv1inv);
theta1 = capv1*(capv0inv*theta0 + w'*y);

v1s12 = v0*s02 + (y-w*theta1)'*(y-w*theta1) + (theta1-theta0)'*capv0inv*(theta1-theta0);
  
%evaluate log of marginal likelihood (ignoring irrelevant integrating constant)
%capv0 is a diagonal matrix so calculate its determinant directly
if v11==-9999
    ldetcapv0= (t-1)*log(etagrid(igrid,1));
else
ldetcapv0= log(v11) + (t-1)*log(etagrid(igrid,1));
end

logmlike = -.5*v1*log(v1s12) + .5*log(det(capv1)) -.5*ldetcapv0;
lmlike(igrid,1)=logmlike;
if logmlike > mlmax
    mlmax=logmlike;
    etamax=etagrid(igrid,1);
    capv1max=capv1;
    th1max=theta1;
    v1s12max=v1s12;
end

end


alpha1=w*th1max;
capv1a = w*capv1max*w';

'empirical Bayes results'
'selected value for eta'
etamax
'posterior mean of initial condition'
th1max(1,1)
'posterior mean of error variance'
v1s12max/v1
alpha=[alpha alpha1];
ykeep=[ykeep y];
end

xlab=cumsum(ones(t,1));

figure(1)
subplot(2,2,1);
plot(xlab,ykeep(:,1),':',xlab,alpha(:,1),'-')
legend('Data','Fitted Trend')
title('Figure 8.2a: Data Set with \eta=0')
xlabel('Time')
subplot(2,2,2);
plot(xlab,ykeep(:,2),':',xlab,alpha(:,2),'-')
legend('Data','Fitted Trend')
title('Figure 8.2b: Data Set with \eta=.1')
xlabel('Time')
subplot(2,2,3);
plot(xlab,ykeep(:,3),':',xlab,alpha(:,3),'-')
legend('Data','Fitted Trend')
title('Figure 8.2c: Data Set with \eta=1')
xlabel('Time')
subplot(2,2,4);
plot(xlab,ykeep(:,4),':',xlab,alpha(:,4),'-')
legend('Data','Fitted Trend')
title('Figure 8.2d: Data Set with \eta=100')
xlabel('Time')