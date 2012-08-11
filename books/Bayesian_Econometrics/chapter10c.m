%program which does third empirical illustration for chapter 10 
%mixtures of Normals model 
load ch10datac.out;
n=size(ch10datac,1);
y=ch10datac(:,1);

for m=1:3

%Hyperparameters for independent Normal-Gamma prior for alpha(j) and h(j) 
%To simplify, assume same prior for every j=1,..,m
v0=.01;
alpha0=0*ones(m,1);
s02=1;
valpha0=(10000^2)*eye(m);
va0inv=inv(valpha0);
%Dirichlet prior for p = probs attached to each component
p0=ones(m,1);

%Specify a few things outside loop for truncated Normal draws
a=0*ones(m,1);
b=0*ones(m,1);
la=0*ones(m,1);
lb=1*ones(m,1);
la(1,1)=1;
d=eye(m);
if m>1
for i=2:m
    d(i,i-1)=-1;
end
end
kstep=cumsum(ones(m,1));


%store all draws in the following matrices
%initialize them here
alpha_=[];
h_=[];
p_=[];


%Specify the number of replications
%number of burnin replications
s0=100;
%number of retained replications
s1=1000;
s=s0+s1;

%choose starting values
pdraw=(1/m)*ones(m,1);
edraw=zeros(n,m);
%Randomly draw a set of starting values for e
for i=1:n
    unif=rand;
  psum=0;
    for j=1:m
        psum=psum+pdraw(j,1);
        if unif <psum
            edraw(i,j)=1;
         break
        end
   end
end
%starting value for h
hdraw=(1/(std(y)^2))*ones(m,1);

alpha_=[];

for irep = 1:s
%    irep
    %draw from alpha conditional on other parameters
    esquare=zeros(m,m);
    ey=zeros(m,1);
    for i=1:n
        eterm1=0;
        for j=1:m
            eterm1=eterm1+edraw(i,j)*hdraw(j,1);
        end
       esquare=esquare + eterm1*edraw(i,:)'*edraw(i,:); 
       ey = ey + eterm1*edraw(i,:)'*y(i,1);
     end
    
    va1inv = va0inv+ esquare;
    va1=inv(va1inv);
    alpha1 = va1*(va0inv*alpha0 + ey);
%Now draw alpha with labelling restriction imposed using truncated Normal
   adraw = tnorm_rnd(m,alpha1,va1,a,b,la,lb,d,kstep);
   
     
    %draw from h conditional on other parameters
    v1=sum(edraw) + v0;
    for j=1:m
        sse=0;
        for i=1:n
           sse=sse + edraw(i,j)*(y(i,1) - adraw(j,1))^2;
       end
    s12 = (sse+v0*s02)/v1(1,j);
    hdraw(j,1)=gamm_rnd(1,1,.5*v1(1,j),.5*v1(1,j)*s12);
    vardraw(j,1)=1/hdraw(j,1);
end

   %draw from p conditional on other parameters
    p1=sum(edraw)';
    p1=p1+p0;
    pdraw = dirich_rnd(p1);
    
    %Draw component indicators
   
   for i = 1:n
       pterm=zeros(m,1);
        for j=1:m
            pterm(j,1) = norm_pdf(y(i,1),adraw(j,1),vardraw(j,1));
            pterm(j,1)=pdraw(j,1)*pterm(j,1);
        end
       
        probs=pterm./sum(pterm);
        multiterm = multi_rnd(probs);
        edraw(i,:)=multiterm';
    end
    
    if irep>s0
        %after discarding burnin, store all draws
        alpha_ = [alpha_ adraw];
         h_ = [h_ hdraw];
         p_ = [p_ pdraw];
       
    end
end


alldraws = [alpha_' h_' p_'];
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
'Number of components in the mixture'
m
'posterior mean, standard deviation and convergence diagnostic, CD'
'alpha followed by h followed by p'
[means stdevs cd]

'nse assuming no, .04, .08 and .15 autocovariance estimates'
'alpha followed by h followed by p'
[nse nse1 nse2 nse3]

%Now calculate information criteria at posterior means
amean = means(1:m,1);
hmean=means(m+1:2*m,1);
pmean=means(2*m+1:3*m,1);
loglike=0;
for i=1:n
    norterm=0;
    for j=1:m
      norterm = norterm + pmean(j,1)*sqrt(hmean(j,1))*exp(-.5*hmean(j,1)*(y(i,1) - amean(j,1))^2);     
    end
    loglike=loglike+log(norterm);
end
nparam = 3*m;
aic = 2*loglike -2*nparam;
bic=2*loglike -nparam*log(n);
hq=2*loglike - 3*nparam*log(log(n));
'AIC'
aic
'BIC'
bic
'HQ'
hq
end