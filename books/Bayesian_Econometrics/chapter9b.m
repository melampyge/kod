%program which does empirical illustration for second part of chapter 9
%probit model
%Regression parameters have noninformative prior

load ch9datab.dat;
n=size(ch9datab,1);
y=ch9datab(:,1);
x=ch9datab(:,2);
x=[ones(n,1) x];
k=size(x,2);

%Calculate a few quantities outside the loop for later use
xsquare=x'*x;
xtxinv=inv(xsquare);
v1=n;

%Now start Gibbs loop
%beta conditional on h is Normal
%h is Gamma

%store all draws in the following matrices
b_=[];
probs_=[];
%Specify the number of replications
%number of burnin replications
s0=10;
%number of retained replications
s1=1000;
s=s0+s1;

%choose a starting value for latent data
ystar=y;

for irep = 1:s
    %draw from beta
    bols = xtxinv*x'*ystar;
    b1 = xtxinv*(xsquare*bols);
    bdraw=b1 + norm_rnd(xtxinv);
     
 %Draw from latent data
   for i=1:n
        mu=x(i,:)*bdraw;
       if y(i,1)==0       
           ystar(i,1)=normrt_rnd(mu,1,0);
       else
           ystar(i,1)=normlt_rnd(mu,1,0);
       end
   end
    if irep>s0
        %probability of making choice one for individuals with x = +2, 0, -2
        muterm(1,1) = -bdraw(1,1) - 2*bdraw(2,1);
        muterm(2,1) = -bdraw(1,1) ;
        muterm(3,1) = -bdraw(1,1) + 2*bdraw(2,1);
        probs = ones(3,1)-stdn_cdf(muterm);
        
        %after discarding burnin, store all draws
        b_ = [b_ bdraw];
        probs_ = [probs_ probs];
    end
end


alldraws = [b_' probs_'];
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

'Posterior results based on Informative Prior'
'number of burnin replications'
s0
'number of included replications'
s1

'posterior mean, standard deviation and convergence diagnostic, CD'
'beta followed by probability of +2/0/-2 individuals making choice 1'
[means stdevs cd]

'nse assuming no, .04, .08 and .15 autocovariance estimates'
'beta'
[nse nse1 nse2 nse3]
