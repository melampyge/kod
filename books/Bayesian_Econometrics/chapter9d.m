%program which does empirical illustration for third part of chapter 9
%Multinomial probit model with IDENTIFICATION IMPOSED
%based on SUR model with m equations


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



%Hyperparameters for independent Normal rior for beta 
b0=0*ones(k,1);
%for noninformative prior for beta comment out following lines and set capv0inv=0
capv0=(100^2)*eye(k);
capv0inv=inv(capv0);
capv0inv=zeros(k,k);
%Prior for PHI is Wishart
%for noninformative prior for PHI set v0=0 and PHI0inv=0
v0=0;
PHI0=eye(m-1);
PHI0inv=inv(PHI0);
PHI0inv=zeros(m-1,m-1);
%Normal prior for delta. for noninformative, set capd0inv=0
del0=zeros(m-1,1);
capd0=eye(m-1);
capd0inv=inv(capd0);
capd0inv=zeros(m-1,m-1);

%Calculate a few quantities outside the loop for later use
v1=v0+n;
sigdraw=eye(m);
deldraw=zeros(m-1,1);
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
SIGMA_=[];

%Specify the number of replications
%number of burnin replications
s0=200;
%number of retained replications
s1=2000;
s=s0+s1;

for irep = 1:s
   irep
   hdraw=inv(sigdraw);
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
    
    %now draw components of sigma
    %draw PHI-inverse first
   
    ete = zeros(m-1,m-1);
      for ii = 1:n
       eterm=ystar(m*(ii-1)+1:m*ii,1)-x(m*(ii-1)+1:m*ii,:)*bdraw;
       eterm1 = eterm(2:m,1) - eterm(1,1)*deldraw;
       ete=ete+ eterm1*eterm1';
   end
    H1 = inv(PHI0inv + ete);
    phiinvdraw = wish_rnd(H1,v1);
    
    %Now draw from delta
     ete1 = 0;
     ev=zeros(m-1,1);
      for ii = 1:n
       eterm=ystar(m*(ii-1)+1:m*ii,1)-x(m*(ii-1)+1:m*ii,:)*bdraw;
       ete1 = ete1 + eterm(1,1)^2;
       ev=ev+ eterm(1,1)*eterm(2:m,1);
   end
    capd1inv = capd0inv+ phiinvdraw*ete1;
    capd1=inv(capd1inv);
    del1 = capd1*(capd0inv*del0 + phiinvdraw*ev);
    deldraw=del1 + norm_rnd(capd1);
    
    %now make up sigma with identification imposed
    sigdraw=eye(m);
    sigdraw(2:m,2:m)=inv(phiinvdraw)+ deldraw*deldraw';
    sigdraw(2:m,1)=deldraw;
    sigdraw(1,2:m)=deldraw';
    
    
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
        vecsig = reshape(sigdraw,m*m,1);
        %after discarding burnin, store all draws
        b_ = [b_ bdraw];
        SIGMA_ = [SIGMA_ vecsig];
     
    end
end


alldraws = [b_' SIGMA_'];
result = momentg(alldraws);
means=[result.pmean]';
stdevs=[result.pstd]';
nse=[result.nse1]';


%Print out whatever you want
'Posterior results'
'number of burnin replications'
s0
'number of included replications'
s1

'posterior mean, standard deviation and nse '
'beta followed by vec(sIGMA) '
[means stdevs nse]
