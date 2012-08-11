function [aols,vbar,a0,ssig1,a02mo] = ts_prior(rawdat,tau,p,plag)

yt = rawdat(plag+1:tau+plag,:)';

%m is the number of elements in the state vector
m = p + plag*(p^2);
Zt=[];
for i = plag+1:tau+plag
    ztemp = eye(p);
    for j = 1:plag;
        xlag = rawdat(i-j,1:p);
        xtemp = zeros(p,p*p);
        for jj = 1:p;
            xtemp(jj,(jj-1)*p+1:jj*p) = xlag;
        end
        ztemp = [ztemp   xtemp];
    end
    Zt = [Zt ; ztemp];
end

vbar = zeros(m,m);
xhy = zeros(m,1);
for i = 1:tau
    zhat1 = Zt((i-1)*p+1:i*p,:);
    vbar = vbar + zhat1'*zhat1;
    xhy = xhy + zhat1'*yt(:,i);
end

vbar = inv(vbar);
aols = vbar*xhy;

sse2 = zeros(p,p);
for i = 1:tau
    zhat1 = Zt((i-1)*p+1:i*p,:);
    sse2 = sse2 + (yt(:,i) - zhat1*aols)*(yt(:,i) - zhat1*aols)';
end

vbar = zeros(m,m);
for i = 1:tau
    zhat1 = Zt((i-1)*p+1:i*p,:);
    vbar = vbar + zhat1'*inv(sse2)*zhat1;
end
vbar = inv(vbar);
hbar = sse2./tau;
achol = chol(hbar)';
ssig = zeros(p,p);
for i = 1:p
    ssig(i,i) = achol(i,i); 
    for j = 1:p
        achol(j,i) = achol(j,i)/ssig(i,i);
    end
end
achol = inv(achol);
numa = p*(p-1)/2;
a0 = zeros(numa,1);
ic = 1;
for i = 2:p
    for j = 1:i-1
        a0(ic,1) = achol(i,j);
        ic = ic + 1;
    end
end
a0=a0([2 1 3]);
ssig1 = zeros(p,1);
for i = 1:p
    ssig1(i,1) = log(ssig(i,i)^2);
end

hbar1 = inv(tau*hbar);
hdraw = zeros(p,p);
a02mo = zeros(numa,numa);
a0mean = zeros(numa,1);
for irep = 1:1000
    hdraw = wish(hbar1,tau);
    hdraw = inv(hdraw);
    achol = chol(hdraw)';
    ssig = zeros(p,p);
    for i = 1:p
        ssig(i,i) = achol(i,i); 
        for j = 1:p
            achol(j,i) = achol(j,i)/ssig(i,i);
        end
    end
    achol = inv(achol);
    a0draw = zeros(numa,1);
    ic = 1;
    for i = 2:p
        for j = 1:i-1
            a0draw(ic,1) = achol(i,j);
            ic = ic + 1;
        end
    end
    a02mo = a02mo + a0draw*a0draw';
    a0mean = a0mean + a0draw; 
end

a02mo = a02mo./1000;
a0mean = a0mean./1000;
a02mo = a02mo - a0mean*a0mean';