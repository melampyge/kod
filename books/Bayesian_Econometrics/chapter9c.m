%program which does empirical illustration for third part of chapter 9
%Multinomial probit model with IDENTIFICATION NOT IMPOSED
%based on SUR model with m equations
%Gibbs sampling for independent Normal-Wishart prior for beta and H

%Program written for 4 alternatives, with one dropped (i.e. m=3)

load Crack.dat;

%The following makes data into an N by K matrix
n=136;
rawdat=[Crack(1:n,:) Crack(n+1:2*n,:)];

%first make up dependent variable
y=zeros(n,1);
for i=1:n
    for j=2:4
    if rawdat(i,j)==1
        y(i,1)=j-1;
    end
end
end

xraw1=[ones(n,1) rawdat(:,14:17)];
k1=size(xraw1,2);
xraw2=xraw1;
k2=size(xraw2,2);
xraw3=xraw1;
k3=size(xraw3,2);

%Stack data as described in book
m=3;
k=k1+k2+k3;
bign=m*n;
ystar=zeros(bign,1);
x=zeros(bign,k);
for i = 1:n;
    for j=1:m
       if y(i,1)==j
           ystar(m*(i-1)+j,1)=1;
      end
   end
    x(m*i-2,1:k1)=xraw1(i,:);
    x(m*i-1,k1+1:k1+k2)=xraw2(i,:);
     x(m*i,k1+k2+1:k)=xraw3(i,:);
end

%Hyperparameters for independent Normal-Wishart prior for beta and H
b0=0*ones(k,1);
%for noninformative prior for beta comment out following lines and set capv0inv=0
capv0=(100^2)*eye(k);
capv0inv=inv(capv0);
%for noninformative prior for H set v0=0 and H0inv=0
v0=.0001;
H0=eye(m);
H0inv=inv(H0);


%Calculate a few quantities outside the loop for later use
v1=v0+n;
hdraw=eye(m);
%A couple things relating to drawing truncated normal
kstep=[1;2;3];
d0=eye(m);
d1= zeros(m,m);
d1(:,1)=ones(m,1);
d1(2,2)=-1;
d1(3,3)=-1;
d2= zeros(m,m);
d2(:,2)=ones(m,1);
d2(1,1)=-1;
d2(3,3)=-1;
d3= zeros(m,m);
d3(:,3)=ones(m,1);
d3(1,1)=-1;
d3(2,2)=-1;

%store all draws in the following matrices
%initialize them here
b_=[];
h_=[];
bid_=[];
sig11_=[];
%Specify the number of replications
%number of burnin replications
s0=100;
%number of retained replications
s1=100;
s=s0+s1;

for irep = 1:s
   irep
   
   xhx = zeros(k,k);
   xhy=zeros(k,1);
   for ii = 1:n
       xterm=x(m*(ii-1)+1:m*ii,:);
       yterm=ystar(m*(ii-1)+1:m*ii,1);
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
      for ii = 1:n
       eterm=ystar(m*(ii-1)+1:m*ii,1)-x(m*(ii-1)+1:m*ii,:)*bdraw;
       ete=ete+ eterm*eterm';
   end
    H1 = inv(H0inv + ete);
    hdraw = wish_rnd(H1,v1);
    sigdraw=inv(hdraw);
    
    %Draw latent variable from truncated Normals
    for i=1:n
        amu = x(m*(i-1)+1:m*i,:)*bdraw;
        if y(i,1)==0
    ydraw = tnorm_rnd(m,amu,sigdraw,zeros(m,1),zeros(m,1),ones(m,1),zeros(m,1),d0,kstep);
       end
       if y(i,1)==1
           ydraw = tnorm_rnd(m,amu,sigdraw,zeros(m,1),ones(m,1),zeros(m,1),ones(m,1),d1,kstep);
       end  
       if y(i,1)==2
           ydraw = tnorm_rnd(m,amu,sigdraw,zeros(m,1),ones(m,1),zeros(m,1),ones(m,1),d2,kstep);
       end  
         if y(i,1)==3
           ydraw = tnorm_rnd(m,amu,sigdraw,zeros(m,1),ones(m,1),zeros(m,1),ones(m,1),d3,kstep);
       end  
    ystar(m*(i-1)+1:m*i,1)=ydraw;
    end
    if irep>s0
        %reshape m by m matrix H for easier storage
        vech = reshape(hdraw,m*m,1);
        %after discarding burnin, store all draws
        b_ = [b_ bdraw];
        h_ = [h_ vech];
        %identified parameters
        temp2=sigdraw(1,1);
        temp1=bdraw./sqrt(temp2);
        bid_ = [bid_ temp1]; 
        sig11_ = [sig11_ temp2];
    end
end


alldraws = [b_' h_' bid_' sig11_'];
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
'beta followed by vec(H) followed by identified variants of beta and sig(11)'
[means stdevs nse]

%Now plot actual Gibbs draws for 

gibbsb1 = b_(1,:)';
gibbsb1id =  bid_(1,:)';
gibbss11 = sig11_(1,:)';
xlab=cumsum(ones(s1,1));

plot(xlab,gibbsb1,'--',xlab,gibbss11,'-',xlab,gibbsb1id,':')
legend('\beta_{11}','\sigma_{11}','Identified coefficient')
title('Figure 9.1: Gibbs Draws of Identified and Non-identified Parameters')
xlabel('Gibbs draw')

