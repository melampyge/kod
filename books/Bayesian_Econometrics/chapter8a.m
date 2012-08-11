%program which does empirical illustration for chapter 8
%This does empirical Bayesian analysis of local level model using conjugate prior
%load in the data set. Here use artificial data

%I have set this up to try out 4 different priors to make figure 8.1

load ch8data.out;
t=size(ch8data,1);
y=ch8data(:,1);
pmkeep=[];
lmkeep=[];
etamax_=[];
ngrid=1000;

for iprior=1:4

    %set up informative prior configuration and then alter below
%Hyperparameters for natural conjugate prior
theta0=zeros(t,1);
theta0(1,1)=1;
v0=.01;
s02=1;
%The prior variance matrix for theta depends on eta so will be modified below
%set v11=-9999 for noninformative choice
v11=100;
capv0=v11*eye(t);
capv0inv=inv(capv0);

if iprior==2
    v0=0;
end

if iprior==3
    v0=1;
    v11=-9999;

end

if iprior==4
    v0=0;
    v11=-9999;
end

%specify a few things outside the loop
%The inverse of the first difference matrix (with first column chopped off)
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
end

end

'grid of values for eta and corresponding log marginal likelihoods'
[etagrid lmlike]

%make into probabilities rather than log probs
lmkeep=[lmkeep lmlike];
pm =exp(lmlike)./sum(exp(lmlike));
pmkeep =[pmkeep pm];
etamax_=[etamax_ etamax];
end
'Empirical Bayes estimates of eta for four priors'
etamax_
figure(1)
plot(etagrid,pmkeep)
plot(etagrid,pmkeep(:,1),'-',etagrid,pmkeep(:,2),'--',etagrid,pmkeep(:,3),':',etagrid,pmkeep(:,4),'.')
legend('Informative','Noninf. for h','Noninf. for theta(1)','Noninformative')
title('Figure 8.1: Marginal Likelihoods for Four Different Priors')
xlabel('\eta')

