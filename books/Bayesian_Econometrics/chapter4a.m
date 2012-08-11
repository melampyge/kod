%program which does empirical illustration for first part of chapter 4
%Gibbs sampling for independent Normal-Gamma prior
%load in the data set. Here use house price data from hprice.txt
%Model comparison component uses Savage Dickey density ratio
%to calculate Bayes factors for beta(i)=0 for i=1,..,k
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
capv0=(10000^2)*eye(k);
capv0(2,2)=25;
capv0(3,3)=2500^2;
capv0(4,4)=5000^2;
capv0(5,5)=5000^2;
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
v0s02=v0*s02;
post = zeros(k,1);
%for Savage-Dickey density ratio evaluate prior quantities
prior = zeros(k,1);
for j = 1:k
    prior(j,1) = norm_pdf(0,b0(j,1),capv0(j,j));
end

%Now start Gibbs loop
%beta conditional on h is Normal
%h conditional on beta is Normal

%store all draws in the following matrices
%initialize them here
b_=[];
h_=[];
bf_=[];
ystar_=[];

%Specify the number of replications
%number of burnin replications
s0=10;
%number of retained replications
s1=10000;
s=s0+s1;

%choose a starting value for h
hdraw=1/s2;

for i = 1:s
    %draw from beta conditional on h
    capv1inv = capv0inv+ hdraw*xsquare;
    capv1=inv(capv1inv);
    b1 = capv1*(capv0inv*b0 + hdraw*xsquare*bols);
    bdraw=b1 + norm_rnd(capv1);
     
    %draw from h conditional on beta
    s12 = ((y-x*bdraw)'*(y-x*bdraw)+v0s02)/v1;
    hdraw=gamm_rnd(1,1,.5*v1,.5*v1*s12);
    if i>s0
        %after discarding burnin, store all draws
        b_ = [b_ bdraw];
        h_ = [h_ hdraw];
        %for Savage-Dickey density ratio evaluate posterior quantities
        for j = 1:k
           post(j,1) = norm_pdf(0,b1(j,1),capv1(j,j)); 
        end
        bfdraw = post./prior;
        bf_ = [bf_ bfdraw];
        %draw from predictive, conditional on beta and h
        ystdraw = xstar*bdraw + norm_rnd(1/hdraw);
        ystar_ = [ystar_ ystdraw];

    end
end


alldraws = [b_' h_'];
%The function momentg is taken from LeSage's toolbox
%it inputs all Gibbs draws and produces posterior
%mean, standard deviation, nse and rne
%it calculates what the book calls S(0) in various ways
%see momentg.m for more details
result = momentg(alldraws);
means=[result.pmean]';
stdevs=[result.pstd]';
nse=[result.nse]';
nse1=[result.nse1]';
nse2=[result.nse2]';
nse3=[result.nse3]';
%calculate Geweke convergence diagnostic based on first .1
%and last .4 of draws
idraw1= round(.1*s1);
result = momentg(alldraws(1:idraw1,:));
meansa=[result.pmean]';
nsea=[result.nse1]';

idraw2= round(.6*s1)+1;
result = momentg(alldraws(idraw2:s1,:));
meansb=[result.pmean]';
nseb=[result.nse1]';

cd = (meansa - meansb)./(nsea+nseb);

%Print out whatever you want
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

'posterior mean, standard deviation and convergence diagnostic, CD'
'beta followed by h'
[means stdevs cd]

'nse assuming no, .04, .08 and .15 autocovariance estimates'
'beta followed by h'
[nse nse1 nse2 nse3]

'Bayes factor for testing beta(i)=0 for i=1,..,k'
bfmean = mean(bf_')';
bfmean


'Predictive mean and standard deviation for specified house'
predmean=mean(ystar_')';
predsd = std(ystar_')';
[predmean predsd]

hist(ystar_',25)
title('Figure 4.1: Predictive Density')
xlabel('House Price')
%ylabel('Bayes factor')