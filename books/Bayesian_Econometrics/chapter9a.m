%program which does empirical illustration for first part of chapter 9
%tobit model
%Regression parameters have noninformative prior

load ch9dataa.dat;
n=size(ch9dataa,1);
y=ch9dataa(:,1);
x=ch9dataa(:,2);
x=[ones(n,1) x];
k=size(x,2);

%Count the number of censored observations
sum=0;
for i=1:n
    if y(i,1)==0
        sum=sum+1;
    end
end
'proportion of censored observations'
sum/n

%Calculate a few quantities outside the loop for later use
xsquare=x'*x;
xtxinv=inv(xsquare);
v1=n;

%Now start Gibbs loop
%beta conditional on h is Normal
%h is Gamma

%store all draws in the following matrices
%initialize them here
b_=[];
h_=[];
%Specify the number of replications
%number of burnin replications
s0=10;
%number of retained replications
s1=1000;
s=s0+s1;

%choose a starting value for latent data
ystar=y;

for irep = 1:s
    %ols quantities for latent data
    %Ordinary least squares quantities
bols = xtxinv*x'*ystar;
vs2 = (ystar-x*bols)'*(ystar-x*bols);
%draw from h
    s12 = vs2/v1;
    hdraw=gamm_rnd(1,1,.5*v1,.5*v1*s12);
    %draw from beta conditional on h
    capv1inv = hdraw*xsquare;
    capv1=inv(capv1inv);
    b1 = capv1*(hdraw*xsquare*bols);
    bdraw=b1 + norm_rnd(capv1);
     
 %Draw from latent data
 sigma2=1/hdraw;
   for i=1:n
       if y(i,1)==0
           mu=x(i,:)*bdraw;
           ystar(i,1)=normrt_rnd(mu,sigma2,0);
       else
           ystar(i,1)=y(i,1);
       end
   end
    if irep>s0
        %after discarding burnin, store all draws
        b_ = [b_ bdraw];
        h_ = [h_ hdraw];
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

ytrue = 2*x(:,2);
ytobit = means(1,1)*ones(n,1)+means(2,1)*x(:,2);
%regular regression results
bols = xtxinv*x'*y;
vs2 = (y-x*bols)'*(y-x*bols);
bcov = (vs2/v1)*xtxinv;
bsd=zeros(k,1);
for i=1:k
    bsd(i,1)=sqrt(bcov(i,i));
end
'Normal linear regression results with noninformative prior'
'beta, mean followed be standard deviation'
[bols bsd]
yregress = bols(1,1)*ones(n,1) + bols(2,1)*x(:,2); 
plot(x(:,2),y,'.',x(:,2),ytrue,':',x(:,2),ytobit,'-',x(:,2),yregress,'--')
legend('Data','True','Tobit','Regression')
title('Figure 9.1: True, Tobit and Regression Lines')
xlabel('x')
