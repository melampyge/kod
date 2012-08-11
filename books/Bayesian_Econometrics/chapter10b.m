%program which does second empirical illustration for chapter 10 
%additive partial linear model 
%This does empirical Bayesian analysis of nonparametric regression model using conjugate prior
%Note I have set up this program for the 2 explanatory variable case, both of which enter nonparametrically
%Minor modifications to this program are necessary for more explanatory variables and/or inclusion of a parametric part (Z)

load ch10datab.out;
n=size(ch10datab,1);
%Sort the data so the explanatory variable is in ascending order
datasort=sortrows(ch10datab,2);
y=datasort(:,1);
x=datasort(:,2:3);

%For do empirical Bayes to choose a particular value for eta
%Prior for eta is Gamma with mean mu0 and d.o.f. v0
mu0=1;
v0=.0001;

%D = first differencing matrix
D=zeros(n-1,n);
for i=1:n-1
   D(i,i)=-1;
   D(i,i+1)=1;
end

%For second explanatory variable, define rearranged D matrix (remember observations are ordered acc. to x1)
%This is a very crude algorithm

x2sort=sortrows(x(:,2),1);
D2=zeros(n-1,n);
%find location of lowest value for explanatory variable 2
for j=1:n
        if x(j,2)==x2sort(1,1)
            indx1=j;
        end
    end
  D2(1,indx1)=-1;
 
for i=1:n-1
    for j=1:n
        if x(j,2)==x2sort(i+1,1)
            indx=j;
        end
    end
    D2(i,indx)=1;
    if i<n-1
    D2(i+1,indx)=-1;
end
end

%Now delete the necessary column to impose identification
I2=eye(n);
if indx1==1
    D2star=D2(:,2:n);
    I2star=I2(:,2:n);
elseif indx1==n
    D2star=D2(:,1:n-1);
    I2star=I2(:,1:n-1);
else
    D2star=[D2(:,1:indx1-1) D2(:,indx1+1:n)];
    I2star=[I2(:,1:indx1-1) I2(:,indx1+1:n)];
end

%Matrix of "explanatory variables"
W = [eye(n) I2star];

%total number of regressors
bigk=n + (n-1);
%define R for the smoothness prior
R = zeros(2*(n-1),bigk);
R(1:n-1,1:n)=D;
R(n:2*(n-1),n+1:bigk)=D2star;

%Do a grid search to find estimate of eta
ngrid=1000;
etagrid = cumsum(.001*ones(ngrid,1));

lpetamax=-999e200;
etamax=0;
for igrid=1:ngrid
eta=etagrid(igrid,1);
%log prior for eta
lprieta = .5*(v0-2)*log(eta) - .5*v0*eta/mu0;

%log marginal likelihood
    vinv=(1/eta)*eye(2*(n-1));
    capv1= inv(R'*vinv*R + W'*W);
    dtilda=capv1*W'*y;
    v1s12 = (y-W*dtilda)'*(y-W*dtilda) + (R*dtilda)'*vinv*(R*dtilda);
    ldetv1=log(det(capv1));
    ldetv0=log(det(R'*vinv*R));
    
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
vinv=(1/etamax)*eye(2*(n-1));
    capv1= inv(R'*vinv*R + W'*W);
    dtilda=capv1*W'*y;

%to complete graph plot the true DGP used to generate data
ytrue1 = x(:,1).*cos(4*pi*x(:,1));
ytrue2 = sin(2*pi*x(:,2)); 
if indx1==1
    yfit2=[0; dtilda(n+2:bigk)];
elseif indx1==n
     yfit2=[dtilda(n+1:bigk-1); 0];
else
   yfit2 = [dtilda(n+1:n+indx1-1,1); 0; dtilda(n+indx1:bigk,1)];
end

f2=[x(:,2) y ytrue2 yfit2];
f2sort = sortrows(f2,1);

subplot(2,1,1)
plot(x(:,1),ytrue1,'-',x(:,1),dtilda(1:n,1),':')
legend('True','Fitted')
title('Figure 10.2a: True and Fitted Lines for First Additive Term')
subplot(2,1,2)
plot(f2sort(:,1),f2sort(:,3),'-',f2sort(:,1),f2sort(:,4),':')
legend('True','Fitted')
title('Figure 10.2b: True and Fitted Lines for Second Additive Term')

