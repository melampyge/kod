%program which does empirical illustration for second part of chapter 4
%Importance sampling for truncated prior
%load in the data set. Here use house price data from hprice.txt
%Model comparison component uses Savage Dickey density ratio
%to calculate Bayes factors for beta(i)= prior mean for i=1,..,k

load hprice.txt;
n=size(hprice,1);
y=hprice(:,1);
x=hprice(:,2:5);
x=[ones(n,1) x];
k=5;

%Hyperparameters for independent Normal-Gamma prior
v0=5;
b0=0*ones(k,1);
b0(2,1)=10;
b0(3,1)=5000;
b0(4,1)=10000;
b0(5,1)=10000;
s02=1/4.0e-8;
capv0=2.4*eye(k);
capv0(2,2)=6e-7;
capv0(3,3)=.15;
capv0(4,4)=.6;
capv0(5,5)=.6;
capv0inv=inv(capv0);

%choose house characteristics for predictive
xstar = [1 5000 2 2 1];

%Ordinary least squares quantities
bols = inv(x'*x)*x'*y;
s2 = (y-x*bols)'*(y-x*bols)/(n-k);
v=n-k;

%Calculate a few quantities outside the loop for later use
xsquare=x'*x;
v1=v0+n;
capv1inv = capv0inv+ xsquare;
capv1=inv(capv1inv);
b1 = capv1*(capv0inv*b0 + xsquare*bols);
v1s12 = v0*s02 + v*s2 + (bols-b0)'*inv(capv0 + inv(xsquare))*(bols-b0);
s12 = v1s12/v1;
vscale = s12*capv1;
vchol=chol(vscale);
vchol=vchol';
v0s02=v0*s02;
vscale0=s02*capv0;

%store all draws in the following matrices
%initialize them here
b_=[];
ystar_=[];

%Specify the number of replications
s=10000;
w=ones(s,1);
for i = 1:s
  
    %draw a t(0,1,v1) then transform to yield draw of beta
    bdraw=b1 + vchol*tdis_rnd(k,v1);
   
        if bdraw(2,1)<5
            w(i,1)=0;
        end
        if bdraw(3,1)<2500
            w(i,1)=0;
        end
        if bdraw(4,1)<5000
            w(i,1)=0;
        end
        if bdraw(5,1)<5000
            w(i,1)=0;
        end
        b_ = [b_ bdraw];
        
        %draw from predictive, conditional on beta and h
      ystdraw = xstar*bdraw + sqrt(s12)*tdis_rnd(1,v1);
        ystar_ = [ystar_ ystdraw];

end

%Now take weighted averages to get estimates
bmean = (b_*w)./sum(w);
bsquare = ((b_.^2)*w)./sum(w);
bvar = bsquare - bmean.^2;
bsd=sqrt(bvar);
predmean = (ystar_*w)./sum(w);
psquare = ((ystar_.^2)*w)./sum(w);
predvar = psquare - predmean.^2;
predsd=sqrt(predvar);


%calculate numerical standard errors
nse=zeros(k,1)
for j = 1:k
   temp1 = (w.*b_(j,:)' - bmean(j,1)*w).^2;
   nse(j,1) = mean(temp1)/(mean(w))^2;
   nse(j,1)=sqrt(nse(j,1)/s);
end


%Savage-Dickey density ratio 
prior = zeros(k,1);
post = zeros(k,1);
for j = 1:k
    prior(j,1) = tdens(b0(j,1),b0(j,1),vscale0(j,j),v0);
    post(j,1) = tdens(b0(j,1),b1(j,1),vscale(j,j),v1);
end
bf = post./prior;

%now obtain clower and cupper for each restriction
%and correct bayes factor appropriately
zscore = (5-b0(2,1))/sqrt(vscale0(2,2));
clower = 1/(1-tdis_cdf(zscore,v0));
zscore = (5-b1(2,1))/sqrt(vscale(2,2));
cupper = 1/(1-tdis_cdf(zscore,v1));
bf(2,1)= cupper*bf(2,1)/clower;
zscore = (2500-b0(3,1))/sqrt(vscale0(3,3));
clower = 1/(1-tdis_cdf(zscore,v0));
zscore = (2500-b1(3,1))/sqrt(vscale(3,3));
cupper = 1/(1-tdis_cdf(zscore,v1));
bf(3,1)= cupper*bf(3,1)/clower;
zscore = (5000-b0(4,1))/sqrt(vscale0(4,4));
clower = 1/(1-tdis_cdf(zscore,v0));
zscore = (5000-b1(4,1))/sqrt(vscale(4,4));
cupper = 1/(1-tdis_cdf(zscore,v1));
bf(4,1)= cupper*bf(4,1)/clower;
zscore = (5000-b0(5,1))/sqrt(vscale0(5,5));
clower = 1/(1-tdis_cdf(zscore,v0));
zscore = (5000-b1(5,1))/sqrt(vscale(5,5));
cupper = 1/(1-tdis_cdf(zscore,v1));
bf(5,1)= cupper*bf(5,1)/clower;
%Print out whatever you want
'Hyperparameters for Normal-Gamma prior'
b0
capv0
v0
s02

'Posterior results based on Informative Prior'
'number of replications'
s
'posterior mean, standard deviation and nse of beta'
[bmean bsd nse]

'according to unrestricted model, probability of restrictions'
mean(w)

'Bayes factor for testing beta(i)=b0(i) for i=1,..,k'
bf

'Predictive mean and standard deviation for specified house'
[predmean predsd]

