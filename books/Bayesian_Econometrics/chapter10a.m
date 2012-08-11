%program which does empirical illustration for chapter 10
%This does empirical Bayesian analysis of nonparametric regression model using conjugate prior
%load in the data set. 

load ch10data.out;
n=size(ch10data,1);
%Sort the data so the explanatory variable is in ascending order
datasort=sortrows(ch10data,2);
y=datasort(:,1);
x=datasort(:,2);

%For do empirical Bayes to choose a particular value for eta
%Prior for eta is Gamma with mean mu0 and d.o.f. v0
mu0=1;
v0=.0001;

%set up a few things outside the loops
D=zeros(n-1,n);
for i=1:n-1
   D(i,i)=-1;
   D(i,i+1)=1;
end

%Do a grid search to find estimate of eta
ngrid=2000;
etagrid = cumsum(.0001*ones(ngrid,1));


lpetamax=-999e200;
etamax=0;
for igrid=1:ngrid
eta=etagrid(igrid,1);
%log prior for eta
lprieta = .5*(v0-2)*log(eta) - .5*v0*eta/mu0;

%log marginal likelihood
    vinv=(1/eta)*eye(n-1);
    capv1= inv(D'*vinv*D + eye(n));
    dtilda=capv1*y;
    v1s12 = (y-dtilda)'*(y-dtilda) + (D*dtilda)'*vinv*(D*dtilda);
    ldetv1=log(det(capv1));
    ldetv0=log(det(D'*vinv*D));
    
    lmlike = .5*ldetv1 +.5*ldetv0 -.5*n*log(v1s12);
    lpeta=lprieta+lmlike;
if lpeta > lpetamax
    lpetamax=lpeta;
    etamax=eta;
end

end

'Empirical Bayes estimate for eta'
etamax

%Now use this estimate to estimate fitted nonparametric regression line
vinv=(1/etamax)*eye(n-1);
    capv1= inv(D'*vinv*D + eye(n));
    dtilda=capv1*y;

%to complete graph plot the true DGP used to generate data
ytrue = x.*cos(4*pi*x);
    
plot(x,y,'.',x,ytrue,'-',x,dtilda,':')
legend('Data','True','Fitted')
title('Figure 10.1: True and Fitted Nonparametric Regression Lines')
xlabel('x')
