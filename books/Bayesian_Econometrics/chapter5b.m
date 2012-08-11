%program which does part of empirical illustration for Chapter 5
%Uses Random walk chain Chain Metropolis-Hastings algorithm
%Calculate posterior predictive p-values 
%load in the data set.
load ch5data.out;
output = ch5data(:,1);
lab=ch5data(:,2);
cap=ch5data(:,3);
n=size(output,1);
x = [ones(n,1) lab cap];
y=output;
k=3;


%Read in posterior mode and variance created in program ch5mode.m
nparam=4;
load postmode.out;
load postvar.out;

%candidate generating density is Normal with mean = oldraw
%and variance matrix vscale
%experiment with different values for c and dof
c=1;
vscale= c*postvar;


%set up things so first candidate draw is always accepted
lpostdraw = -9e+200;
bdraw=postmode;

%store all draws in the following matrices
%initialize them here
b_=[];
skew_=[];
kurt_=[];
skewstar_=[];
kurtstar_=[];

%Specify the number of replications
s=25000;
pswitch=0;
%Start the loop
for i = 1:s
  
    
    bcan=bdraw + norm_rnd(vscale);

   lpostcan = ch5bw(bcan,y,x,n,nparam);
   
%log of acceptance probability
   laccprob = lpostcan-lpostdraw;
  
%accept candidate draw with log prob = laccprob, else keep old draw
   if log(rand)<laccprob
       lpostdraw=lpostcan;
       bdraw=bcan;
       pswitch=pswitch+1;
   end    
        b_ = [b_ bdraw];

%now do posterior predictive p-values
%calculate f(X,gamma) 
fgamma=zeros(n,1);
for ii = 1:2
    fgamma = fgamma + bdraw(ii+1,1)*(x(:,ii+1).^bdraw(4,1)); 
end
fgamma = bdraw(1,1)*ones(n,1)+fgamma.^(1/bdraw(4,1));
s12 = (y-fgamma)'*(y-fgamma)/n;

%calculate skew and kurt stats for observed data
skewkurt = ch5ppred(bdraw,y,fgamma,n);
skew_ = [skew_ skewkurt(1,1)];
kurt_= [kurt_ skewkurt(1,2)];
%Simulate an artificial data set
ystar = fgamma + sqrt(s12)*tdis_rnd(n,n);
skewkurt = ch5ppred(bdraw,ystar,fgamma,n);
skewstar_ = [skewstar_ skewkurt(1,1)];
kurtstar_= [kurtstar_ skewkurt(1,2)];
          
end

alldraws = [b_'];
%The function momentg is taken from LeSage's toolbox
%it inputs all Gibbs draws and produces posterior
%mean, standard deviation, nse and rne
%it calculates what the book calls S(0) in various ways
%see momentg.m for more details
result = momentg(alldraws);
means=[result.pmean]';
stdevs=[result.pstd]';
nse=[result.nse1]';

%Print out whatever you want

'Posterior results based on Noninformative Prior'
'number of replications'
s
'posterior mean, standard deviation and nse of Gamma'
[means stdevs nse]
'proportion of switches'
pswitch/s

'Mean of skew in observed data'
mskew=mean(skew_')

'Mean of kurtosis in observed data'
mkurt=mean(kurt_')

%now calculate posterior predictive p-values (2 sided)
skstar = abs(skewstar_');
skstar=sort(skstar);
for ii = 1:s
if abs(mskew)<skstar(ii,1)
    break
end
end
skewpval=1-ii/s;
'posterior predictive p-value for skewness'
skewpval
kstar = abs(kurtstar_');
kstar=sort(kstar);
for ii = 1:s
if abs(mkurt)<kstar(ii,1)
    break
end
end
kurtpval=1-ii/s;
'posterior predictive p-value for kurtosis'
kurtpval


hist(skewstar_',25)
title('Figure 5.1: Posterior Predictive Density for Skewness')
xlabel('Skewness')

%hist(kurtstar_',25)
%title('Figure 5.2: Posterior Predictive Density for Kurtosis')
%xlabel('Kurtosis')