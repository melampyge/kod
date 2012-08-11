%program which does empirical illustration for fourth part of chapter 6
%SUR model with m equations
%Gibbs sampling for independent Normal-Wishart prior for beta and H

load yankees.txt;
t=size(yankees,1);
yraw=yankees(:,2);
xraw=[ones(t,1) yankees(:,5:6) yankees(:,8:8)];
k1=4;
load redsox.txt;
yraw1=redsox(:,2);
xraw1=[ones(t,1) redsox(:,5:6) redsox(:,8:8)];
k2=4;

%Stack data as described in book
m=2;
k=k1+k2;
bigt=m*t;
y=zeros(bigt,1);
x=zeros(bigt,k);
for i = 1:t;
    y(2*i-1,1)=yraw(i,1);
    y(2*i,1)=yraw1(i,1);
    x(2*i-1,1:k1)=xraw(i,:);
    x(2*i,k1+1:k)=xraw1(i,:);
end

%Hyperparameters for independent Normal-Wishart prior for beta and H
b0=0*ones(k,1);
%for noninformative prior for beta comment out following lines and set capv0inv=0
capv0=(.1^2)*eye(k);
capv0inv=inv(capv0);
%for noninformative prior for H set v0=0 and H0inv=0
v0=0;
H0=eye(m);
H0inv=inv(H0);
H0inv=zeros(m,m);

%Calculate a few quantities outside the loop for later use
v1=v0+t;
hdraw=eye(m);
post = zeros(k1,1);
%Calculate savage-dickey density ratio for whether equivalent
%coefficients in the two equations are equal to one another
%for Savage-Dickey density ratio evaluate prior quantities
prior = zeros(k1,1);
for j = 1:k1
    r=zeros(1,k);
    r(1,j)=1;
    r(1,k1+j)=-1;
    pmean=r*b0;
    pvar= r*capv0*(r');
    prior(j,1) = norm_pdf(0,pmean,pvar);
end

%store all draws in the following matrices
%initialize them here
b_=[];
h_=[];
bf_=[];
corr_=[];

%Specify the number of replications
%number of burnin replications
s0=1000;
%number of retained replications
s1=10000;
s=s0+s1;

for i = 1:s
   i
   
   xhx = zeros(k,k);
   xhy=zeros(k,1);
   for ii = 1:t
       xterm=x(m*(ii-1)+1:m*ii,:);
       yterm=y(m*(ii-1)+1:m*ii,1);
       xhx=xhx+ xterm'*hdraw*xterm;
       xhy=xhy+xterm'*hdraw*yterm;
   end
   
    %draw from beta conditional on H
    capv1inv = capv0inv+ xhx;
    capv1=inv(capv1inv);
    b1 = capv1*(capv0inv*b0 + xhy);
    bdraw=b1 + norm_rnd(capv1);
     
    %draw from H conditional on beta
    ete = zeros(m,m);
      for ii = 1:t
       eterm=y(m*(ii-1)+1:m*ii,1)-x(m*(ii-1)+1:m*ii,:)*bdraw;
       ete=ete+ eterm*eterm';
   end
    H1 = inv(H0inv + ete);
    hdraw = wish_rnd(H1,v1);
    
    if i>s0
        %reshape m by m matrix H for easier storage
        vech = reshape(hdraw,m*m,1);
        %after discarding burnin, store all draws
        b_ = [b_ bdraw];
        h_ = [h_ vech];
        covdraw=inv(hdraw);
        corr12 = covdraw(2,1)/(sqrt(covdraw(1,1))*sqrt(covdraw(2,2)));
        corr_=[corr_ corr12];
       for j = 1:k1
         r=zeros(1,k);
         r(1,j)=1;
         r(1,k1+j)=-1;
         pmean=r*b1;
         pvar= r*capv1*r';
         post(j,1) = norm_pdf(0,pmean,pvar);
       end    
       bfdraw = post./prior;
        bf_ = [bf_ bfdraw];
    end
end


alldraws = [b_' h_' corr_'];
result = momentg(alldraws);
means=[result.pmean]';
stdevs=[result.pstd]';
nse=[result.nse1]';


%Print out whatever you want
'Hyperparameters for independent Normal-Wishart prior for b and H'
b0
capv0inv
v0
H0

'Posterior results'
'number of burnin replications'
s0
'number of included replications'
s1

'posterior mean, standard deviation and nse '
'beta followed by vec(H) followed by corr(e1,e2)'
[means stdevs nse]

'95% HPDIs'
'beta followed by vec(h)'
hpdis=zeros(k+m*m+1,2);
for ii=1:k+m*m+1
    hpdis(ii,1:2) = hpdi(alldraws(:,ii),.95);
end
hpdis

'Bayes factor for testing beta(1,j)-beta(2,j)=0 for j=1,..,k'
bfmean = mean(bf_')';
bfmean