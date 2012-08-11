%program which does part of empirical illustration for Chapter 5
%Metropolis-within-Gibbs algorithm
%Focus on model comparison using Gelfand-Dey method
%Handles both nonlinear regression model and linear regression model
%Independent Normal-Gamma prior

%load in the data set.
load ch5data.out;
output = ch5data(:,1);
lab=ch5data(:,2);
cap=ch5data(:,3);
n=size(output,1);
x = [ones(n,1) lab cap];
y=output;
k=3;

%Hyperparameters for independent Normal-Gamma prior
v0=12;
s02=.1;
%hyperparameters for nonlinear regression model
b0=ones(k+1,1);
capv0=.25*eye(k+1);
capv0inv=inv(capv0);
%hyperparameters for linear regression model
b00=ones(k,1);
capv00=.25*eye(k);
capv00inv=inv(capv00);
v1=v0+n;
v0s02=v0*s02;

%Ordinary least squares quantities
xsquare=x'*x;
bols = inv(xsquare)*x'*y;
s2 = (y-x*bols)'*(y-x*bols)/(n-k);

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
hdraw=1/s02;
bdraw0=postmode(1:k,1);
hdraw0=1/s02;
%store all draws in the following matrices
%initialize them here
b_=[];
h_=[];
b0_=[];
h0_=[];
pswitch=0;
gammcov=zeros(k+1,k+1);
%Specify the number of replications
%number of burnin replications
s0=100;
%number of retained replications
s1=1000;
s=s0+s1;
for i = 1:s

%LINEAR REGRESSION MODEL
    %draw from beta conditional on h
    capv1inv0 = capv00inv+ hdraw0*xsquare;
    capv10=inv(capv1inv0);
    b1 = capv10*(capv00inv*b00 + hdraw0*xsquare*bols);
    bdraw0=b1 + norm_rnd(capv10);
     
    %draw from h conditional on beta
    s120 = ((y-x*bdraw0)'*(y-x*bdraw0)+v0s02)/v1;
    hdraw0=gamm_rnd(1,1,.5*v1,.5*v1*s120);
%calculate f(x,gamma) for CES production function
    fgamma=zeros(n,1);   
    for ii = 1:2
        fgamma = fgamma + bdraw(ii+1,1)*(x(:,ii+1).^bdraw(4,1)); 
    end
    fgamma = fgamma.^(1/bdraw(4,1));
    fgamma = fgamma + bdraw(1,1)*ones(n,1);
   s12 = ((y-fgamma)'*(y-fgamma)+v0s02)/v1;
    %draw from h conditional on Gamma
    hdraw=gamm_rnd(1,1,.5*v1,.5*v1*s12);
    %candidate draw for gamma conditional on h
    bcan=bdraw + norm_rnd(vscale);

   lpostcan = ch5cw(bcan,y,x,n,nparam,hdraw,b0,capv0inv);
   lpostdraw = ch5cw(bdraw,y,x,n,nparam,hdraw,b0,capv0inv);
   
%log of acceptance probability
   laccprob = lpostcan-lpostdraw;
  
%accept candidate draw with log prob = laccprob, else keep old draw
   if log(rand)<laccprob
       bdraw=bcan;
       pswitch=pswitch+1;
   end    
        
   if i>s0
        %after discarding burnin, store all draws
        b_ = [b_ bdraw];
        h_ = [h_ hdraw];
         b0_ = [b0_ bdraw0];
        h0_ = [h0_ hdraw0];
        gammcov=gammcov + bdraw*bdraw';
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
nse=[result.nse1]';
alldraws0 = [b0_' h0_'];
result0 = momentg(alldraws0);
means0=[result0.pmean]';
stdevs0=[result0.pstd]';
nse0=[result0.nse1]';
%Print out whatever you want

'Posterior results based on Noninformative Prior'
'number of burn in draws'
s0
'number of included draws'
s1
'Nonlinear regression model'
'posterior mean, standard deviation and nse of Gamma and h'
[means stdevs nse]
'proportion of switches'
pswitch/s
'Linear regression model'
'posterior mean, standard deviation and nse of beta and h'
[means0 stdevs0 nse0]

gammcov=gammcov/s1 - means(1:k+1,1)*means(1:k+1,1)';
