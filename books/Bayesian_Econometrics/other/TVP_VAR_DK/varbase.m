function [aamean,avar,hmean] = varbase(rawdat,p,plag,bigt)
% Basic results for a VAR using a noninformative prior

yt = zeros(p,bigt-plag);
yt = rawdat(plag+1:bigt,:)';

m = (1 + plag*p)*p;
Zt=[];
for i = plag+1:bigt
    ztemp = eye(p);
    for j = 1:plag
        xlag = rawdat(i-j,1:p);
        xtemp = zeros(p,p*p);
        for jj = 1:p
            xtemp(jj,(jj-1)*p+1:jj*p) = xlag;
        end
        ztemp = [ztemp  xtemp];
    end
    Zt = [Zt ; ztemp];
end

t = size(yt,2);
aamean = zeros(m,1);
avar = zeros(m,1);
hmean = zeros(p,p);
Hdraw = eye(p);
%-------Loop begins
nrep = 2500;
nburn = 500;
ntot = nrep + nburn;

for irep = 1:ntot

    vbar = zeros(m,m);
    xhy = zeros(m,1);
    for i = 1:t
        zhat1 = Zt((i-1)*p+1:i*p,:);
        yhat1 = yt(:,i) ;
        vbar = vbar + zhat1'*Hdraw*zhat1;
        xhy = xhy + zhat1'*Hdraw*yhat1;
    end
    vbar = inv(vbar);
    ahat = vbar*xhy;
    adraw = ahat + chol(vbar)'*randn(m,1);
    
    yhat = zeros(p,t);
    for i = 1:t
        yhat(:,i) = yt(:,i) - Zt((i-1)*p+1:i*p,:)*adraw;
    end

    hbar = yhat*yhat';
    hbar = inv(hbar);
    hdraw = wish(hbar,t);

    if irep > nburn;
        avar = avar + adraw.^2;
        aamean = aamean + adraw;
        hmean = hmean + inv(hdraw);        
    end
end
avar = avar./nrep;
aamean = aamean./nrep;
avar = sqrt(avar - aamean.^2);
hmean = hmean./nrep;