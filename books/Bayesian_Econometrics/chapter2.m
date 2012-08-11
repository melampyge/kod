%program which does empirical illustration for chapter 2
%get the data which has been created using ch2data program
load ch2data.out;
y=ch2data(:,1);
x=ch2data(:,2);


%Hyperparameters for natural conjugate prior
v0=10;
b0=1.5;
s02=1;
capv0=.25;
capv0inv=inv(capv0);

%things used to plot marginal student t prior 
incr=.01;
alower=1;
aupper=3;
plotpri = tdensity(b0,s02*capv0,v0,alower,aupper,incr);

%Call script which carries actually does posterior analysis
ch2post;

plotpost = tdensity(b1,s12*capv1,v1,alower,aupper,incr);

%Print out whatever you want
'Posterior and Predictive results based on Informative Prior'
b1
bsd
hmean
hsd
ystarm
ystarsd
ystarcapv
lmarglik

lmarg1=lmarglik;

%Hyperparameters for noninformative prior
v0=0;
capv0inv=0;


%Call script which carries actually does posterior analysis
ch2post;
plotpost1 = tdensity(b1,capv1,v1,alower,aupper,incr);

%Print out whatever you want
'Posterior and Predictive results based on Noninformative Prior'
b1
bsd
hmean
hsd
ystarm
ystarsd
ystarcapv

plotpri(:,2)=plotpri(:,2)./sum(plotpri(:,2));
plotpost(:,2)=plotpost(:,2)./sum(plotpost(:,2));
plotpost1(:,2)=plotpost1(:,2)./sum(plotpost1(:,2));


plot(plotpri(:,1),plotpri(:,2),'--',...
plotpost(:,1),plotpost(:,2),plotpost1(:,1),plotpost1(:,2),':')
title('Figure 2.1: Marginal Prior and Posteriors for \beta')
legend('Prior','Posterior','Likelihood')
xlabel('\beta')
ylabel('probability density')

%As an example, evaluate marginal likelihood for model with only an intercept
x=ones(n,1);


%Hyperparameters for natural conjugate prior
v0=10;
b0=1.5;
s02=1;
capv0=.25;
capv0inv=inv(capv0);
ch2post;

postodds=exp(lmarg1 - lmarglik)