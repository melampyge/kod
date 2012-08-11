%For a given data set and values for prior hyperparameters
%Calculate OLS and posterior quantities, marginal likelihood
%and predictive (Predictive sets x-star=.5

%Ordinary least squares quantities
n=size(y,1);
bols = inv(x'*x)*x'*y;
s2 = (y-x*bols)'*(y-x*bols)/(n-1);
bolscov = s2*inv(x'*x);
bolssd=sqrt(bolscov);
v=n-1;

%Posterior hyperparameters for Normal-Gamma
xsquare=x'*x;
v1=v0+n;
capv1inv = capv0inv+ xsquare;
capv1=inv(capv1inv);
b1 = capv1*(capv0inv*b0 + bols*xsquare);
if capv0inv>0
   v1s12 = v0*s02 + v*s2 + ((bols-b0)^2)/(capv0+(1/xsquare));
else
   v1s12 = v0*s02 + v*s2 ; 
end
s12 = v1s12/v1;

bcov = capv1*v1s12/(v1-2);
bsd=sqrt(bcov);

%posterior mean and variance of error precision
hmean = 1/s12;
hvar=2/(v1s12);
hsd=sqrt(hvar);

%predictive inference
xstar=.5;
ystarm = xstar*b1;
ystarcapv = (1+capv1*xstar^2)*s12;
ystarv = ystarcapv*v1/(v1-2);
ystarsd=sqrt(ystarv);

%log of marginal likelihood for the model if prior is informative
if v0>0;
    intcon=gammaln(.5*v1) + .5*v0*log(v0*s02)- gammaln(.5*v0) -.5*n*log(pi);
    lmarglik=intcon + .5*log(capv1/capv0) - .5*v1*log(v1s12);
end;