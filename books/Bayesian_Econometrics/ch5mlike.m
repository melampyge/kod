function lbayfact = ch5mlike(drawsnl,drawsl,y,x,b0,capv0inv,b00,capv00inv,...
    v0,s02,p)
%This program takes as inputs posterior simulator output from the
%nonlinear and linear regression models used in Chapter 5 so they must
%be run first and saved in files named drawsnl and drawsl as noted below
%it calculates the log of the marginal likelihood for each of these two
%models using the Gelfand-Dey method 
%output is the log of the Bayes factor
%Note: The empirical illustration uses same prior for h and, hence,
%I use only kernel for this prior
%Also this program assumes that same truncation point used for two models
nrep=size(drawsnl,1);
n=size(y,1);
k=size(x,2);
bdrawl = drawsl(:,1:k);
bdrawnl = drawsnl(:,1:k+1);
hdrawl =drawsl(:,k+1);
hdrawnl =drawsnl(:,k+2);

%Get truncation function
thmeannl=mean(drawsnl)';
thmeanl=mean(drawsl)';
sigl = (drawsl'*drawsl)./nrep - thmeanl*thmeanl'; 
signl = (drawsnl'*drawsnl)./nrep - thmeannl*thmeannl'; 
siglinv=inv(sigl);
signlinv=inv(signl);
cvnl = chis_inv(1-p,k+2);
cvl = chis_inv(1-p,k+1);
ntrunc=size(cvl,1);

%calculate truncation function, log of prior and likelihood for each of two models
funnl=zeros(nrep,ntrunc);
funl=zeros(nrep,ntrunc);
lprinl=zeros(nrep,1);
lpril=zeros(nrep,1);
llikenl=zeros(nrep,1);
llikel=zeros(nrep,1);
%integrating constants for various densities, evaluated outside loop
intconl=-.5*k*log(2*pi) + .5*log(det(capv00inv)) ;
intconnl=-.5*(k+1)*log(2*pi) + .5*log(det(capv0inv)) ;
intfl = sqrt(det(siglinv))*(2*pi)^(-.5*(k+1));
intfnl = sqrt(det(signlinv))*(2*pi)^(-.5*(k+2));

for i = 1:nrep
%truncation function
quadl=(thmeanl - drawsl(i,:)')'*siglinv*(thmeanl - drawsl(i,:)');
quadnl=(thmeannl - drawsnl(i,:)')'*signlinv*(thmeannl - drawsnl(i,:)');
for j = 1:ntrunc
if quadl < cvl(j,1)
funl(i,j) = intfl*exp(-.5*quadl);    
end
if quadnl < cvnl(j,1)
funnl(i,j) = intfnl*exp(-.5*quadnl);    
end
end
%log prior evaluated at every draw
%log prior for beta
    lpril(i,1)=intconl-.5*(bdrawl(i,:)'-b00)'*capv00inv*(bdrawl(i,:)'-b00);
    lprinl(i,1)=intconnl-.5*(bdrawnl(i,:)'-b0)'*capv0inv*(bdrawnl(i,:)'-b0);
%log prior for h
    lpril(i,1) = lpril(i,1)+ .5*(v0-2)*log(hdrawl(i,1))-.5*v0*s02*hdrawl(i,1);
    lprinl(i,1) = lprinl(i,1)+ .5*(v0-2)*log(hdrawnl(i,1))-.5*v0*s02*hdrawnl(i,1);
%log likelihoods evaluated at every draw
fgamma=zeros(n,1);
for ii = 1:2
    fgamma = fgamma + bdrawnl(i,ii+1)*(x(:,ii+1).^bdrawnl(i,4)); 
end
fgamma = fgamma.^(1/bdrawnl(i,4));
fgamma = fgamma + bdrawnl(i,1)*ones(n,1);

llikenl(i,1) = .5*n*log(hdrawnl(i,1))-.5*hdrawnl(i,1)*(y-fgamma)'*(y-fgamma);

llikel(i,1) = .5*n*log(hdrawl(i,1))...
-.5*hdrawl(i,1)*(y-x*(bdrawl(i,:)'))'*(y-x*(bdrawl(i,:)'));

end

lbayfact=zeros(ntrunc,1);
for j = 1:ntrunc
lterm = funl(:,j)./exp(lpril + llikel);
nlterm = funnl(:,j)./exp(lprinl + llikenl);
mlinv = sum(lterm);
mnlinv = sum(nlterm);
lbayfact(j,1) = log(mnlinv) - log(mlinv);
end






