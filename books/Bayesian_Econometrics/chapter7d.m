%Individual effects with random coefficients model for panel data
%program which does empirical illustration for fourth part of chapter 7
%Gibbs sampling for independent hierarchical Normal prior

%Load in data into y and x (all stacked by individual)

%Note also that the notation is slightly different than in book
%theta is used for coefficients which vary across individuals

load ch7data2.out;
tn=size(ch7data2,1);
t=5;
n=100;
y=ch7data2(:,1);
x=ch7data2(:,2:3);
kx=size(x,2);
%--------
%Define the prior hyperparameters
%--------

%hierarchical prior for varying coefficients
%Notation used here has theta0 being mean of theta in hierarchical prior
%theta0 has Normal prior with mean mu_theta and variance V_theta
mu_theta = zeros(kx,1);
V_theta = 1*eye(kx);
V_thinv=inv(V_theta);
%Notation here has Sigma being variance of theta in hierarchical prior
%Sigma-inverse has prior which is Wishart 
%degree of freedom = rho, scale matrix R --- implying mean = rho*R
rho = 2;
R = .5*eye(kx);
%for error precision use Gamma prior with mean h02 and v0=d.o.f. 
v0 = 1;
h02=25;
s02 = 1/h02;

%Do OLS and related results (assuming no heterogeneity) to get starting values
bols = inv(x'*x)*x'*y;
s2 = (y-x*bols)'*(y-x*bols)/(tn-kx);
%choose a starting value for h
hdraw=1/s2;
%Calculate a few quantities outside the loop for later use
xsquare=x'*x;
v1=v0+tn;
v0s02=v0*s02;
vrho=rho + n;
%starting value for theta
thetdraw = [bols(1,1)*ones(1,n); bols(2,1)*ones(1,n)]; 
thet0draw = bols;
%If imlike==1 then calculate marginal likelihood, if not then no marglike
imlike=1;
%Use Chib (1995) method for marginal likelihood calculation
%this requires point to evaluate all at --- try ols or posterior mean
%chibval7d.out is a file where I have saved posterior mean from earlier run
if imlike==1;
  load chibval7d.out;
  hchib=chibval7d(1,1);
  th0chib=chibval7d(2:kx+1,1);
 %capital sigma inverse
    sigchib=eye(kx);
    sigchib(1:kx,1)=chibval7d(kx+2:2*kx+1,1);
    sigchib(1:kx,2)=chibval7d(2*kx+2:3*kx+1,1);
    sigichib=inv(sigchib); 

%log prior evaluated at this point 
     logprior = -.5*v0*log(2*h02/v0)-gammaln(.5*v0)+.5*(v0-2)*log(hchib)...
       -.5*v0*hchib/h02 -.5*kx*log(2*pi) -.5*kx*log(det(V_theta))...
       -.5*(th0chib-mu_theta)'*V_thinv*(th0chib-mu_theta);
   sigtemp = logwish_pdf(sigichib,R,rho);
   logprior = logprior + sigtemp;
%log likelihood evaluated at the point
loglike=0;
   for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
       capri = xuse*sigchib*xuse' + (1/hchib)*eye(t);
       capriinv=inv(capri);
        loglike = loglike -.5*t*log(2*pi)-.5*log(det(capri))...
   -.5*(yuse-xuse*th0chib)'*capriinv*(yuse-xuse*th0chib);
    end 
 
end

%store all draws in the following matrices
%initialize them here
h_=[];
th0_=[];
sig_=[];
postth0=0;
%Just calculate mean and st dev for all the varying coeffs
%requires too much storage to store all draws 
thmean=zeros(n,kx);
thsd=zeros(n,kx);
%Specify the number of replications
%number of burnin replications
s0=100;
%number of retained replications
s1=2000;
s=s0+s1;

%Now start Gibbs loop

for irep = 1:s
    irep
    %Draw from sigmainverse using Wishart
    sigterm=zeros(kx,kx);
    for i = 1:n
     sigterm=sigterm+(thetdraw(:,i)-thet0draw)*(thetdraw(:,i)-thet0draw)';   
    end
    sigterm1=inv(sigterm + rho*R);
    siginv = wish_rnd(sigterm1,vrho);
    sigdraw=inv(siginv);
    
    %draw from h conditional on other parameters
    s12=0; 
        for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        thetuse=thetdraw(:,i);
       s12 = s12+ (yuse-xuse*thetuse)'*(yuse-xuse*thetuse);
    end 
    s12= (s12 + v0s02)/v1;
    hdraw=gamm_rnd(1,1,.5*v1,.5*v1*s12);
    
    %Now draw theta0 (mean in hierarchical prior)conditional on other params
    capd0 = inv(n*siginv +V_thinv);
    dtheta0=n*siginv*(mean(thetdraw')') + V_thinv*mu_theta;
    th0mean=capd0*dtheta0;
    thet0draw=th0mean+norm_rnd(capd0);
    
    %Now draw theta-i s conditional on other parameters
    for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        capdt = inv(hdraw*xuse'*xuse + siginv);
        dt = hdraw*xuse'*yuse + siginv*thet0draw;
        thetdraw(:,i)=capdt*dt+norm_rnd(capdt);
    end
    if irep>s0
        %after discarding burnin, store all draws
        h_ = [h_ hdraw];
        th0_=[th0_ thet0draw];
        temp = reshape(sigdraw,kx^2,1);
        sig_=[sig_ temp];
        thmean = thmean + thetdraw';
        thsd=thsd +(thetdraw.^2)';
        if imlike==1
%For Chib method, this calculates posterior chunk relating to theta0
         logpost = -.5*kx*log(2*pi) -.5*kx*log(det(capd0))...
       -.5*(th0chib-th0mean)'*inv(capd0)*(th0chib-th0mean);
        postth0=postth0+logpost;
    end
    end
end
thmean=thmean./s1;
thsd=thsd./s1;
thsd = sqrt(thsd-thmean.^2);

%Note that the next huge chunk of code does the auxilliary runs
%necessary to do the Chib method for marginal likelihood calculation

if imlike==1
postth0=postth0/s1;

%first auxilliary Gibbs run is to evaluate sigma-inverse component
%necessary if Chib method for marginal likelihood calculation is used
postsig=0;
for irep = 1:s
    irep
    %Draw from sigmainverse using Wishart
    sigterm=zeros(kx,kx);
    for i = 1:n
     sigterm=sigterm+(thetdraw(:,i)-th0chib)*(thetdraw(:,i)-th0chib)';   
    end
    sigterm1=inv(sigterm + rho*R);
    siginv = wish_rnd(sigterm1,vrho);
    sigdraw=inv(siginv);
   
     %draw from h conditional on beta
    s12=0; 
        for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        thetuse=thetdraw(:,i);
       s12 = s12+ (yuse-xuse*thetuse)'*...
           (yuse-xuse*thetuse);
    end 
    s12= (s12 + v0s02)/v1;
    hdraw=gamm_rnd(1,1,.5*v1,.5*v1*s12);
    
    %Now draw theta-i s
    for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        capdt = inv(hdraw*xuse'*xuse + siginv);
        dt = hdraw*xuse'*yuse + siginv*th0chib;
        thetdraw(:,i)=capdt*dt+norm_rnd(capdt);
    end
    if irep>s0
      
        post = logwish_pdf(sigichib,sigterm1,vrho);
        postsig=postsig+post;
      
    end
end
postsig=postsig/s1;
%second auxilliary Gibbs sampler is to evaluate error precision component
%this is necessary for evaluating marginal likelihood using Chib method
posth=0;
for irep = 1:s
    irep
    
     %draw from h conditional on beta
    s12=0; 
        for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        thetuse=thetdraw(:,i);
       s12 = s12+ (yuse-xuse*thetuse)'*...
           (yuse-xuse*thetuse);
    end 
    s12= (s12 + v0s02)/v1;
    hdraw=gamm_rnd(1,1,.5*v1,.5*v1*s12);
    
    %Now draw theta-i s
    for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        capdt = inv(hdraw*xuse'*xuse + sigichib);
        dt = hdraw*xuse'*yuse + sigichib*th0chib;
        thetdraw(:,i)=capdt*dt+norm_rnd(capdt);
    end
    if irep>s0
      
     logpost = -.5*v1*log(2/(v1*s12))-gammaln(.5*v1)+.5*(v1-2)*log(hchib)...
       -.5*v1*hchib*s12;
        posth=posth+logpost;
      
    end
end
posth=posth/s1;
logmlike=loglike+logprior-postth0-postsig-posth;
end

alldraws = [h_' th0_' sig_'];
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


'Posterior results'
'number of burnin replications'
s0
'number of included replications'
s1

if imlike==1
'Log of Marginal Likelihood'
logmlike
end

'Posterior means, std. devs and nse for parameters'
'Parameters ordered as error precision, theta0, vec(sig)'
[means stdevs nse]
'Posterior mean and standard deviation for theta'
[thmean thsd]

save chibval7d.out means -ASCII;

figure(1)
hist(thmean(:,1),20)
title('Figure 1: Histogram of Posterior Means of Alpha(i)s')
xlabel('Alpha(i)')
