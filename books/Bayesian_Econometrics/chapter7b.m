%Individual effects with non-hierarchical prior for panel data
%program which does empirical illustration for second part of chapter 7
%Gibbs sampling for independent Normal-Gamma prior
%Basically the same as chapter4a.m, but uses Chib method for marginal 
%likelihood calculation


%Load in data into y and x(all stacked by individual)
load ch7data2.out;
tn=size(ch7data2,1);
t=5;
n=100;
y=ch7data2(:,1);
x=ch7data2(:,3);
%Now make individual specific dummy variables
xdummy=zeros(tn,n);
for i = 1:n
    xdummy((i-1)*t+1:i*t,i)=ones(t,1);
end
x=[xdummy x];
k=size(x,2);

%--------
%Define the prior hyperparameters
%--------
%Hyperparameters for independent Normal-Gamma prior
v0=1;
b0=0*ones(k,1);
s02=.04;
h02=1/s02;
capv0=(1^2)*eye(k);
capv0inv=inv(capv0);

%Do OLS and related results to get starting values
bols = inv(x'*x)*x'*y;
s2 = (y-x*bols)'*(y-x*bols)/(tn-k);
%choose a starting value for h and
%Calculate a few quantities outside the loop for later use
xsquare=x'*x;
v1=v0+tn;
v0s02=v0*s02;
hdraw=1/s2;  

%If imlike==1 then calculate marginal likelihood, if not then no marglike
imlike=1;
%Use Chib (1995) method for marginal likelihood calculation
%this requires point to evaluate all at --- try ols results or use post means
if imlike==1;
%bchib=bols;
%hchib=1/s2;
 load chibval7b.out;
  bchib=chibval7b(1:k,1);
  hchib=chibval7b(k+1,1);
%log prior evaluated at this point 
     logprior = -.5*v0*log(2*h02/v0)-gammaln(.5*v0)+.5*(v0-2)*log(hchib)...
       -.5*v0*hchib/h02 -.5*k*log(2*pi) -.5*k*log(det(capv0))...
       -.5*(bchib-b0)'*capv0inv*(bchib-b0);
%log likelihood evaluated at the point
   loglike = -.5*tn*log(2*pi)+.5*tn*log(hchib)...
   -.5*hchib*(y-x*bchib)'*(y-x*bchib);
end

%store all draws in the following matrices
%initialize them here
b_=[];
h_=[];
logpost2=0;

%Specify the number of replications
%number of burnin replications
s0=100;
%number of retained replications
s1=1000;
s=s0+s1;

%Now start Gibbs loop
%beta conditional on h is Normal
%h conditional on beta is Normal
for irep = 1:s
    irep
    %draw from beta conditional on h
  capv1inv = capv0inv+ hdraw*xsquare;
    capv1=inv(capv1inv);
    b1 = capv1*(capv0inv*b0 + hdraw*xsquare*bols);
    bdraw=b1 + norm_rnd(capv1);
     
    %draw from h conditional on beta
    s12 = ((y-x*bdraw)'*(y-x*bdraw)+v0s02)/v1;
    hdraw=gamm_rnd(1,1,.5*v1,.5*v1*s12);
     
    if irep>s0
        %after discarding burnin, store all draws
        b_ = [b_ bdraw];
        h_ = [h_ hdraw];
        if imlike==1
        %log posterior for betaevaluated at point -- use for marg like
        %see Chib (1995, JASA) pp. 1315 for justification
        logpost = -.5*k*log(2*pi) -.5*k*log(det(capv1))...
       -.5*(bchib-b1)'*capv1inv*(bchib-b1);
        logpost2=logpost2+logpost;
    end
    end
end
if imlike ==1
logpost2=logpost2/s1;
%we need p(beta,h|y) evaluated as point
%In loop we calculated p(beta|y) now need p(h|y,beta) to complete
  s12 = ((y-x*bchib)'*(y-x*bchib)+v0s02)/v1;
      logpost1 = -.5*v1*log(2/(v1*s12))-gammaln(.5*v1)+.5*(v1-2)*log(hchib)...
       -.5*v1*hchib*s12; 
logmlike = loglike + logprior - logpost2-logpost1;
end
alldraws = [b_' h_'];
%The function momentg is taken from LeSage's toolbox
%it inputs all Gibbs draws and produces posterior
%mean, standard deviation, nse and rne
%it calculates what Geweke calls S(0) in various ways
%see momentg.m for more details
result = momentg(alldraws);
means=[result.pmean]';
stdevs=[result.pstd]';
nse=[result.nse]';
nse1=[result.nse1]';
nse2=[result.nse2]';
nse3=[result.nse3]';



'Hyperparameters for independent Normal-Gamma prior'
b0
capv0
v0
s02

'Posterior results based on Informative Prior'
'number of burnin replications'
s0
'number of included replications'
s1

if imlike==1
'Log of Marginal Likelihood'
logmlike
end

'Posterior means, std. devs and nse for parameters'
'Parameters ordered as theta, gamma then error precision'
[means stdevs nse]
%Save the posterior means for use as point at which to evaluate in Chib method
save chibval7b.out means -ASCII;

thmean=means(1:n,1);
figure(1)
hist(thmean,20)
title('Figure 7.3: Histogram of Posterior Means of Alpha(i)s, Non-hier. Prior')
xlabel('Alpha(i)')
