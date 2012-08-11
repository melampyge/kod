%Individual effects with hierarchical prior for panel data
%program which does empirical illustration for third part of chapter 7
%Gibbs sampling for independent Normal-Gamma prior

%Load in data into y and z (all stacked by individual)
%This is actually a more general program which allows for some
%coefficients to vary across individuals and others to be constant
%x contain variables with varying coefficients --- here set to intercept

%Note also that the notation is slightly different than in book
%theta is used for coefficients which vary across individuals
%gamma is used for coefficients constant across individuals
load ch7data2.out;
tn=size(ch7data2,1);
t=5;
n=100;
y=ch7data2(:,1);
x=ch7data2(:,2);
z=ch7data2(:,3);
xz=[x z];
kz=size(z,2);
kx=size(x,2);
k=kz+kx;
%--------
%Define the prior hyperparameters
%--------
%for constant coefficients, Normal with mean mu_gamma and var V_gamma
mu_gamma = zeros(kz,1);
V_gamma = 1*eye(kz);
V_ginv=inv(V_gamma);
%hierarchical prior for varying coefficients
%Normal with mean mu_theta and variance V_theta
mu_theta = zeros(kx,1);
V_theta = 1*eye(kx);
V_thinv=inv(V_theta);
%for heterogeneity precision use Wishart 
%degree of freedom = rho, scale matrix R --- implying mean = rho*R
%Note that when kx=1, this collapses to a Gamma prior
rho = 2;
R = .5;
%for error precision use Gamma prior with mean h02 and v0=d.o.f. 
v0 = 1;
h02=25;
s02 = 1/h02;

%Do OLS and related results (assuming no heterogeneity) to get starting values
bols = inv(xz'*xz)*xz'*y;
s2 = (y-xz*bols)'*(y-xz*bols)/(tn-k);
%choose a starting value for h
hdraw=1/s2;
%Calculate a few quantities outside the loop for later use
xsquare=xz'*xz;
v1=v0+tn;
v0s02=v0*s02;
vrho=rho + n;
%starting value for theta
thetdraw = bols(1,1)*ones(1,n); 
thet0draw = bols(1,1);
%If imlike==1 then calculate marginal likelihood, if not then no marglike
imlike=0;
%Use Chib (1995) method for marginal likelihood calculation
%this requires point to evaluate all at --- try ols or posterior mean
%chibval7c.out is a file where I have saved posterior mean from earlier run
if imlike==1;
  load chibval7c.out;
  gchib=chibval7c(1:kz,1);
  hchib=chibval7c(kz+1,1);
  th0chib=chibval7c(kz+2:kz+kx+1,1);
 %capital sigma inverse
    sigchib=eye(kx);
    sigchib=chibval7c(k+2:k+kx+1,1);
    sigichib=inv(sigchib); 
%    th0chib=bols(1:kx+1,1);
%    gchib=bols(kx+1:k,1);
%hchib=1/s2;

%log prior evaluated at this point use Poirier page 100 for Gamma part
     logprior = -.5*v0*log(2*h02/v0)-gammaln(.5*v0)+.5*(v0-2)*log(hchib)...
       -.5*v0*hchib/h02 -.5*kz*log(2*pi) -.5*kz*log(det(V_gamma))...
       -.5*(gchib-mu_gamma)'*V_ginv*(gchib-mu_gamma)...
       -.5*kx*log(2*pi) -.5*kx*log(det(V_theta))...
       -.5*(th0chib-mu_theta)'*V_thinv*(th0chib-mu_theta);
   sigterm = logwish_pdf(sigichib,R,rho);
   logprior = logprior + sigterm;
%log likelihood evaluated at the point
loglike=0;
   for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        zuse=z((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
       capri = xuse*sigchib*xuse' + (1/hchib)*eye(t);
       capriinv=inv(capri);
        loglike = loglike -.5*t*log(2*pi)-.5*log(det(capri))...
   -.5*(yuse-xuse*th0chib -zuse*gchib)'*capriinv*(yuse-xuse*th0chib-zuse*gchib);
    end 
 
end

%store all draws in the following matrices
%initialize them here
g_=[];
h_=[];
th0_=[];
sig_=[];
postg=0;
thmean=zeros(n,kx);
thsd=zeros(n,kx);
%Specify the number of replications
%number of burnin replications
s0=100;
%number of retained replications
s1=2500;
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
   
    %Draw from Gamma (constant coeffs) conditional on other parameters
    capdginv = zeros(kz,kz);
    dgamma=zeros(kz,1);
    for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        zuse=z((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
       capri = xuse*sigdraw*xuse' + (1/hdraw)*eye(t);
       capriinv=inv(capri);
       capdginv = capdginv + zuse'*capriinv*zuse;
       dgamma=dgamma + zuse'*capriinv*(yuse - xuse*thet0draw);
    end 
   
    capdg=inv(capdginv+V_ginv);
    dgamma=dgamma + V_ginv*mu_gamma;
    gmean=capdg*dgamma;
    gdraw=gmean+norm_rnd(capdg);
    
    
    %draw from h conditional on other parameters
    s12=0; 
        for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        zuse=z((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        thetuse=thetdraw(:,i);
       s12 = s12+ (yuse-xuse*thetuse - zuse*gdraw)'*...
           (yuse-xuse*thetuse - zuse*gdraw);
    end 
    s12= (s12 + v0s02)/v1;
    hdraw=gamm_rnd(1,1,.5*v1,.5*v1*s12);
    
    %Now draw theta0 (mean in hierarchical prior)conditional on other params
    capd0 = inv(n*siginv +V_thinv);
    dtheta0=n*siginv*(mean(thetdraw')') + V_thinv*mu_theta;
    thet0draw=capd0*dtheta0+norm_rnd(capd0);
    
    %Now draw theta-i s conditional on other parameters
    for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        zuse=z((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        capdt = inv(hdraw*xuse'*xuse + siginv);
        dt = hdraw*xuse'*(yuse - zuse*gdraw) + siginv*thet0draw;
        thetdraw(:,i)=capdt*dt+norm_rnd(capdt);
    end
    if irep>s0
        %after discarding burnin, store all draws
        g_ = [g_ gdraw];
        h_ = [h_ hdraw];
        th0_=[th0_ thet0draw];
        temp = reshape(sigdraw,kx^2,1);
        sig_=[sig_ temp];
        thmean = thmean + thetdraw';
        thsd=thsd +(thetdraw.^2)';
        if imlike==1
        %log posterior for gamma evaluated at point -- use for marg like
        %see Chib (1995, JASA) pp. 1314-1316 for justification
        logpostg = -.5*kz*log(2*pi) -.5*kz*log(det(capdg))...
       -.5*(gchib-gmean)'*inv(capdg)*(gchib-gmean);
        postg=postg+logpostg;
    end
    end
end
thmean=thmean./s1;
thsd=thsd./s1;
thsd = sqrt(thsd-thmean.^2);

%Note that the next huge chunk of code does the auxilliary runs
%necessary to do the Chib method for marginal likelihood calculation

if imlike==1
postg=postg/s1;

%Now do auxiliary simulations as described in Chib (1995)
%first auxilliary is to evaluated theta(0) component
postth0=0;
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
   
     %draw from h conditional on beta
    s12=0; 
        for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        zuse=z((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        thetuse=thetdraw(:,i);
       s12 = s12+ (yuse-xuse*thetuse - zuse*gchib)'*...
           (yuse-xuse*thetuse - zuse*gchib);
    end 
    s12= (s12 + v0s02)/v1;
    hdraw=gamm_rnd(1,1,.5*v1,.5*v1*s12);
    
    %Now draw theta0 (mean in hierarchical prior)
    capd0 = inv(n*siginv +V_thinv);
    dtheta0=n*siginv*(mean(thetdraw')') + V_thinv*mu_theta;
    th0mean=capd0*dtheta0;
    thet0draw=th0mean+norm_rnd(capd0);
    
    %Now draw theta-i s
    for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        zuse=z((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        capdt = inv(hdraw*xuse'*xuse + siginv);
        dt = hdraw*xuse'*(yuse - zuse*gchib) + siginv*thet0draw;
        thetdraw(:,i)=capdt*dt+norm_rnd(capdt);
    end
    if irep>s0
      
        logpost = -.5*kx*log(2*pi) -.5*kx*log(det(capd0))...
       -.5*(th0chib-th0mean)'*inv(capd0)*(th0chib-th0mean);
        postth0=postth0+logpost;
      
    end
end
postth0=postth0/s1;
%second auxilliary Gibbs run is to evaluate sigma-inverse component
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
        zuse=z((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        thetuse=thetdraw(:,i);
       s12 = s12+ (yuse-xuse*thetuse - zuse*gchib)'*...
           (yuse-xuse*thetuse - zuse*gchib);
    end 
    s12= (s12 + v0s02)/v1;
    hdraw=gamm_rnd(1,1,.5*v1,.5*v1*s12);
    
    %Now draw theta-i s
    for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        zuse=z((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        capdt = inv(hdraw*xuse'*xuse + siginv);
        dt = hdraw*xuse'*(yuse - zuse*gchib) + siginv*th0chib;
        thetdraw(:,i)=capdt*dt+norm_rnd(capdt);
    end
    if irep>s0
      
        post = logwish_pdf(sigichib,sigterm1,vrho);
        postsig=postsig+post;
      
    end
end
postsig=postsig/s1;
%third auxilliary Gibbs sampler is to evaluate error precision component
%this is necessary for evaluating marginal likelihood using Chib method
posth=0;
for irep = 1:s
    irep
    
     %draw from h conditional on beta
    s12=0; 
        for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        zuse=z((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        thetuse=thetdraw(:,i);
       s12 = s12+ (yuse-xuse*thetuse - zuse*gchib)'*...
           (yuse-xuse*thetuse - zuse*gchib);
    end 
    s12= (s12 + v0s02)/v1;
    hdraw=gamm_rnd(1,1,.5*v1,.5*v1*s12);
    
    %Now draw theta-i s
    for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        zuse=z((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
        capdt = inv(hdraw*xuse'*xuse + sigichib);
        dt = hdraw*xuse'*(yuse - zuse*gchib) + sigichib*th0chib;
        thetdraw(:,i)=capdt*dt+norm_rnd(capdt);
    end
    if irep>s0
      
     logpost = -.5*v1*log(2/(v1*s12))-gammaln(.5*v1)+.5*(v1-2)*log(hchib)...
       -.5*v1*hchib*s12;
        posth=posth+logpost;
      
    end
end
posth=posth/s1;
logmlike=loglike+logprior-postg-postth0-postsig-posth;
end

alldraws = [g_' h_' th0_' sig_'];
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
'Parameters ordered as gamma, error precision, theta0, vec(sig)'
[means stdevs nse]
'Posterior mean and standard deviation for theta'
[thmean thsd]

save chibval7c.out means -ASCII;

figure(1)
hist(thmean(:,1),20)
title('Figure 7.4: Histogram of Posterior Means of Alpha(i)s, Hierarchical Prior')
xlabel('Alpha(i)')
