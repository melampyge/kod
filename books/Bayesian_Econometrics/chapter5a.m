%program which does part of empirical illustration for Chapter 5
%Uses Independence Chain Metropolis-Hastings algorithm
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

%candidate generating density is t with mode postmode
%scale matrix vscale and degrees of freedom dof
%experiment with different values for c and dof
c=1;
dof=10;
vscale= c*postvar;
vscinv=inv(vscale);
vchol=chol(vscale);
vchol=vchol';

%set up things so first candidate draw is always accepted
lwdraw = -9e+200;
bdraw=postmode;

%store all draws in the following matrices
%initialize them here
b_=[];

%Specify the number of replications
s=25000;
pswitch=0;
%Start the loop
for i = 1:s
  
    %draw a t(0,1,v1) then transform to yield cadidate draw of gamma
    bcan=postmode+ vchol*tdis_rnd(nparam,dof);
    
   lwcan = ch5aw(bcan,postmode,vscinv,dof,y,x,n,nparam);
   
%log of acceptance probability
   laccprob = lwcan-lwdraw;
  
%accept candidate draw with log prob = laccprob, else keep old draw
   if log(rand)<laccprob
       lwdraw=lwcan;
       bdraw=bcan;
       pswitch=pswitch+1;
   end    
        b_ = [b_ bdraw];
          
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
