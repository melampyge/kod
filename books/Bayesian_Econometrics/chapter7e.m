%Stochastic frontier model for panel data
%program which does empirical illustration for last part of chapter 7
%Gibbs sampling for independent Normal-Gamma prior + hierarchical prior for ineff's
%I have not included marginal likelihood calculation to keep things simple
%Chib method can be used here

%Load data into y and x (all stacked by individual)

load stoch_front.out;
tn=size(stoch_front,1);
t=5;
n=100;
y=stoch_front(:,1);
x=stoch_front(:,2:4);
k=size(x,2);

%Choose 3 firms to provide detailed results for
%I choose min, med, max firms (quartile efficiency based on earlier Gibbs run)
%if you want to plot results for these firms set iplot=1, else iplot=0
firmno=cumsum(ones(n,1));
iplot=1;
if iplot==1
    load ch7keep.out;
    choose=ch7keep;
end
%--------
%Define the prior hyperparameters
%--------
%for constant coefficients, Normal with mean mu_gamma and var V_gamma
mu_beta = zeros(k,1);
mu_beta(2,1)=.5;
mu_beta(3,1)=.5;
V_beta = (.25^2)*eye(k);
V_beta(1,1)=100;
V_binv=inv(V_beta);

%for error precision use Gamma prior with mean h02 and v0=d.o.f. 
v0 = 0;
h02=25;
s02 = 1/h02;

%For mu(z)-inverse use Gamma prior with mean mu_z-inverse and dof-v_z
v_z=2;
mu_z=-log(.5);

%Do OLS and related results (assuming no heterogeneity) to get starting values
bols = inv(x'*x)*x'*y;
s2 = (y-x*bols)'*(y-x*bols)/(tn-k);
%choose a starting value for h
hdraw=1/s2;
%choose a starting value for beta
bdraw=bols;
%choose a starting value for mu(z)
muzdraw=-log(.5);
zdraw=muzdraw*ones(n,1);
%Calculate a few quantities outside the loop for later use
xsquare=x'*x;
v1=v0+tn;
vz=2*n + v_z;
v0s02=v0*s02;
xtxsum=zeros(k,k);
xtysum=zeros(k,1);
for i=1:n
    xtxsum=xtxsum + x((i-1)*t+1:i*t,:)'*x((i-1)*t+1:i*t,:); 
    xtysum=xtysum + x((i-1)*t+1:i*t,:)'*y((i-1)*t+1:i*t,:); 
end

%store all draws in the following matrices
%initialize them here
b_=[];
h_=[];
muz_=[];
firms_=[];
effmean=zeros(n,1);
effsd=zeros(n,1);
p12=0;
p23=0;
p13=0;
%Specify the number of replications
%number of burnin replications
s0=2500;
%number of retained replications
s1=25000;
s=s0+s1;

%Now start Gibbs loop

for irep = 1:s
    irep
    %Draw from z-i s conditional on other parameters
    
    zterm = 1/(t*hdraw*muzdraw);
    zvar=1/(t*hdraw);
    for i = 1:n
        xmean=mean(x((i-1)*t+1:i*t,:));
        ymean=mean(y((i-1)*t+1:i*t,:));
        zmean = xmean*bdraw - ymean -zterm;
     zdraw(i,1)=truncnorm_rnd(zmean,zvar,0);
    end   
 
    %Draw from Beta conditional on other parameters
    xtzsum=zeros(k,1);
    for i=1:n
       xtzsum=xtzsum + x((i-1)*t+1:i*t,:)'*(zdraw(i,1)*ones(t,1)); 
    end
    bvarinv = V_binv + hdraw*xtxsum;
    bvar=inv(bvarinv);
    bmean = bvar*(V_binv*mu_beta + hdraw*(xtysum +xtzsum));
    bdraw=bmean+norm_rnd(bvar);
    
    
    %draw from h conditional on other parameters
    s12=0; 
        for i = 1:n
        xuse=x((i-1)*t+1:i*t,:);
        yuse=y((i-1)*t+1:i*t,1);
           s12 = s12+ (yuse-xuse*bdraw + zdraw(i,1)*ones(t,1))'*...
           (yuse-xuse*bdraw + zdraw(i,1)*ones(t,1));
    end 
    s12= (s12 + v0s02)/v1;
    hdraw=gamm_rnd(1,1,.5*v1,.5*v1*s12);
    
  %draw from mu(z)-inverse conditional on other parameters
  meanmuz=(sum(zdraw) + mu_z)/(n+.5*v_z);
    muzinvdraw=gamm_rnd(1,1,.5*vz,.5*vz*meanmuz);
    muzdraw=1/muzinvdraw;
    
    
    if irep>s0
        %after discarding burnin, store all draws
        b_ = [b_ bdraw];
        h_ = [h_ hdraw];
        muz_=[muz_ muzdraw];
        effmean=effmean + exp(-zdraw);
        effsd=effsd + (exp(-zdraw)).^2;
        %store draws for selected firms to later plot
        if iplot==1
            effmin=exp(-zdraw(choose(1,1),1));
            effmed=exp(-zdraw(choose(2,1),1));
            effmax=exp(-zdraw(choose(3,1),1));
            effchoose(1,1)=effmin;
            effchoose(2,1)=effmed;
            effchoose(3,1)=effmax;
            firms_ =[firms_ effchoose];
            if effmax>effmed
                p12=p12+1;
            end
            if effmax>effmin
                p13=p13+1;
            end
            if effmed>effmin
                p23=p23+1;
            end
        end
    end
end
effmean=effmean./s1;
effsd=effsd./s1;
effsd=sqrt(effsd - effmean.^2);

alldraws = [b_' h_' muz_'];
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

'Posterior means, std. devs and nse for parameters'
'Parameters ordered as beta, error precision, mu(z)'
[means stdevs nse]

'Posterior mean and standard deviation of efficiencies'
[effmean effsd]

%sort by efficiency mean and then choose a few firms
temp1=[firmno effmean];
effsort=sortrows(temp1,2);
firmkeep(1,1)=effsort(1,1);
nmed=round(n/2);
firmkeep(2,1)=effsort(nmed,1);
firmkeep(3,1)=effsort(n,1);
save ch7keep.out firmkeep -ASCII;

figure(1)
hist(effmean,25)
title('Figure 7.5: Histogram of Posterior Means of Efficiencies')
xlabel('Efficiency')

if iplot==1
    'probability that max is more efficient than med'
    p12/s1
    'probability that max is more efficient than min'
    p13/s1
    'probability that med is more efficient than min'
    p23/s1
    nbins=50;
    bins=zeros(nbins,1);
    bins(1,1)=.5;
    for i=2:nbins
        bins(i,1)=bins(i-1,1)+.01;
    end
       freq=hist(firms_',bins);
    for i=1:3
      freq(i,1)=freq(i,1)./mean(freq(i,1));
    end
    figure(2)
%hist(firms_',bins)
plot(bins,freq(:,1),'-',bins,freq(:,2),'--',bins,freq(:,3),':')
legend('Min Efficient','Median Efficient','Max Efficient')
title('Figure 7.6: Posteriors of Min/Med/Max Efficient Firms')
xlabel('Efficiency')
end