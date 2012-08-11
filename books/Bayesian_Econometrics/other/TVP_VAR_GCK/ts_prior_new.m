function [aols,vbar,a0,ssig1,a02mo] = ts_prior_new(K,p,plag,constant,slow)

%load data for training sample priors
load xdataTR.dat;
load ydataTR.dat;
load tcodeTR.dat;
load slowcodeTR.dat;
load yearlabTR.dat;
load namesXTR.mat;


xdata=xdataTR;
ydata=ydataTR;

%Transform data to be approximately stationary
for i_x = 1:size(xdata,2)   %#ok<NODEF> % Transform "X"
    xtempraw(:,i_x) = transx(xdata(:,i_x),tcodeTR(i_x)); %#ok<AGROW>
end

% Demean and standardize data
xdata = xtempraw(3:end,:);
ydata = ydata(3:end,:);
% t1 = size(xdata,1);
% t2 = size(ydata,1);
% xdata = (xdata - repmat(mean(xdata,1),t1,1))./repmat(std(xdata,1),t1,1);
% ydata = (ydata - repmat(mean(ydata,1),t2,1))./repmat(std(ydata,1),t2,1);

% Define X and Y matrices
X = xdata;
Y = ydata;
t=size(Y,1);
N=size(X,2);
M=size(Y,2);

% Demean X
X=X-repmat(mean(X),t,1);
%Y=Y-repmat(mean(Y),t,1);

% Standardize for PC only
X_st=X./repmat(std(X,1),t,1);
%Y=Y./repmat(std(Y,1),t,1);

% ================================| FACTOR EQUATION |==========================
% first step - extract PC from X
[F0,Lf0] = extract(X_st,K);

if slow == 1
    slowindex=find(slowcodeTR==1)';
    xslow = X_st(:,slowindex);
    [Fslow0,Lfslow0] = extract(xslow,K);
    Fr0 = facrot(F0,Y(:,end),Fslow0);
else
    Fr0=F0;
end

% Put it all in state-space representation, write obs equ as XY=FY*L+e
XY=[X,Y];   %Tx(N+M)
FY=[Fr0,Y];

L = (olssvd(XY,FY))';   %(N+M)xkm

% obtain R:
e = XY - FY*L';
R = e'*e./t;
R = diag(diag(R));
%R = diag([diag(R);zeros(M,1)]);   %(N+M)x(N+M)

% Generate lagged Y matrix. This will be part of the X matrix
ylag = mlag2(FY,plag); % Y is [T x m]. ylag is [T x (nk)]
% Form RHS matrix X_t = [1 y_t-1 y_t-2 ... y_t-k] for t=1:T
ylag = ylag(plag+1:t,:);

% m is the number of elements in the state vector
m = p*constant + plag*(p^2);

% Create X_t matrix as in Primiceri equation (4). I have reserved "X"
% for the data I use to extract factors, hence name this matrix "Z".
Zt = zeros((t-plag)*p,m);
for i = 1:t-plag
    if constant == 1
        ztemp = eye(p);
    else
        ztemp = [];
    end
    for j = 1:plag        
        xtemp = ylag(i,(j-1)*p+1:j*p);
        xtemp = kron(eye(p),xtemp);
        ztemp = [ztemp xtemp];  %#ok<AGROW>
    end
    Zt((i-1)*p+1:i*p,:) = ztemp;
end

% Redefine FAVAR variables y
y = FY(plag+1:t,:)';
% Time series observations
tau=size(y,2);   % t is now 195 - plag = 193

vbar = zeros(m,m);
xhy = zeros(m,1);
for i = 1:tau
    zhat1 = Zt((i-1)*p+1:i*p,:);
    vbar = vbar + zhat1'*zhat1;
    xhy = xhy + zhat1'*y(:,i);
end

vbar = inv(vbar);
aols = vbar*xhy;

sse2 = zeros(p,p);
for i = 1:tau
    zhat1 = Zt((i-1)*p+1:i*p,:);
    sse2 = sse2 + (y(:,i) - zhat1*aols)*(y(:,i) - zhat1*aols)';
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
hdraw = zeros(p,p); %#ok<NASGU>
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