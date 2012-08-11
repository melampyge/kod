% TVP-VAR Time varying structural VAR with stochastic volatility
% --------------------------------------------------------------------------
% This code implements the model in Primiceri (2005).
% ***********************************************************
% The model is:
%     _      _             _        _
%    |  Y(t)  |  = B(t) x |  Y(t-1)  |  +  u(t) 
%     -      -             -        -
% 
% 
%  with u(t)~N(0,H(t)), and  A(t)' x H(t) x A(t) = Sigma(t)*Sigma(t),
%             _                                          _
%            |    1         0        0       ...       0  |
%            |  a21(t)      1        0       ...       0  |
%    A(t) =  |  a31(t)     a32(t)    1       ...       0  |
%            |   ...        ...     ...      ...      ... |
%            |_ aN1(t)      ...     ...     aNN(t)     1 _|
% 
% 
% and Sigma(t) = diag{s1(t), .... ,sn(t)}.
% **************************************************************
%   NOTE: 
%      There are references to equations of Primiceri, "Time Varying Structural Vector
%      Autoregressions & Monetary Policy",(2005),Review of Economic Studies 72,821-852
%      for your convenience. The definition of vectors/matrices is also based on this
%      paper.
% --------------------------------------------------------------------------

clear all;
clc;
randn('state',sum(100*clock));
rand('twister',sum(100*clock));
%-----------------------------LOAD DATA------------------------------------
% Load Korobilis (2008) quarterly data
load ydata.dat;
load yearlab.dat;

% Demean and standardize data
t2 = size(ydata,1);
% stdffr = std(ydata(:,3));
% ydata = (ydata - repmat(mean(ydata,1),t2,1))./repmat(std(ydata,1),t2,1);
Y=ydata;

% Number of observations and dimension of X and Y
t=size(Y,1);
M=size(Y,2);

% Number of factors & lags:
tau = 40; % tau is the size of the training sample
p = M; % p is the dimensionality of Y
plag = 2; % plag is number of lags in the VAR part
numa = p*(p-1)/2;    % numa is the number of elements of At
% ===================================| FAVAR EQUATION |=========================
% Generate lagged Y matrix. This will be part of the X matrix
ylag = mlag2(Y,plag); % Y is [T x m]. ylag is [T x (nk)]
% Form RHS matrix X_t = [1 y_t-1 y_t-2 ... y_t-k] for t=1:T
ylag = ylag(plag+tau+1:t,:);

m = p + plag*(p^2); % m is the number of elements in the state vector
% Create Z_t matrix
Z = zeros((t-tau-plag)*p,m);
for i = 1:t-tau-plag
    ztemp = eye(p);
    for j = 1:plag        
        xtemp = ylag(i,(j-1)*p+1:j*p);
        xtemp = kron(eye(p),xtemp);
        ztemp = [ztemp xtemp];  %#ok<AGROW>
    end
    Z((i-1)*p+1:i*p,:) = ztemp;
end

% Redefine FAVAR variables y
y = Y(tau+plag+1:t,:)';
yearlab = yearlab(tau+plag+1:t);
% Time series observations
t=size(y,2);   % t is now 215 - plag - tau = 173

%----------------------------PRELIMINARIES---------------------------------
% Set some Gibbs - related preliminaries
nrep = 50000;  % Number of replications
nburn = 20000;   % Number of burn-in-draws
nthin = 1;   % Consider every thin-th draw (thin value)
it_print = 10;  %Print in the screen every "it_print"-th iteration


%========= PRIORS:
%========= PRIORS ON TRANSISION PROBS (Beta) 
% %1 - Least informative Beta prior
% a_prob = sqrt(t)*0.5;   
% b_prob = sqrt(t)*0.5;

%2 - Reference Beta prior
a_prob = 1;   
b_prob = 1;

% %3 - Informative prior (few breaks)
% a_prob = 0.1;   
% b_prob = 10;

ap_0 = a_prob*ones(2,1);
bp_0 = b_prob*ones(2,1);
% Implied prior "sample size" for state equations
t_0 = (ap_0./(ap_0 + bp_0))*t;

%=========PRIORS ON TIME-VARYING PARAMETERS AND THEIR COVARIANCES
% To set up training sample prior a la primiceri, use the following subroutine
%[B_OLS,VB_OLS,A_OLS,sigma_OLS,VA_OLS]= ts_prior(Y,tau,p,plag);
B_OLS = 0*ones(m,1);
A_OLS = 0*ones(numa,1);
VA_OLS = eye(numa);
VB_OLS = eye(m);
sigma_OLS = ones(p,1);

% Set some hyperparameters here (see page 831, end of section 4.1)
k_Q = 0.01;
k_S = 0.1;
k_W = 0.01;

% We need the sizes of some matrices as prior hyperparameters (see page
% 831 again, lines 2-3 and line 6)
sizeW = p; % Size of matrix W
sizeS = 1:p; % Size of matrix S

%-------- Now set prior means and variances (_prmean / _prvar)
% B_0 ~ N(B_OLS, 4Var(B_OLS))
B_0_prmean = B_OLS;
B_0_prvar = 4*VB_OLS;
% A_0 ~ N(A_OLS, 4Var(A_OLS))
A_0_prmean = A_OLS;
A_0_prvar = 4*VA_OLS;
% log(sigma_0) ~ N(log(sigma_OLS),I_n)
sigma_prmean = sigma_OLS;
sigma_prvar = 4*eye(p);

% Note that for IW distribution I keep the _prmean/_prvar notation,
% but these are scale and shape parameters...
% Q ~ IW(k2_Q*size(subsample)*Var(B_OLS),size(subsample))
Q_prmean = ((k_Q).^2)*tau*(t/t_0(1,1))*VB_OLS;
Q_prvar = tau;
% W ~ IW(k2_W*(1+dimension(W))*I_n,(1+dimension(W)))
W_prmean = ((k_W)^2)*(t/t_0(1,1))*(1 + sizeW)*eye(p);
W_prvar = 1 + sizeW;
% S ~ IW(k2_S*(1+dimension(S)*Var(A_OLS),(1+dimension(S)))
S_prmean = cell(p-1,1);
S_prvar = zeros(p-1,1);
ind = 1;
for ii = 2:p
    % S is block diagonal as in Primiceri (2005)
    S_prmean{ii-1} = ((k_S)^2)*(1 + sizeS(ii-1))*VA_OLS(((ii-1)+(ii-3)*(ii-2)/2):ind,((ii-1)+(ii-3)*(ii-2)/2):ind);
    S_prvar(ii-1) = 1 + sizeS(ii-1);
    ind = ind + ii;
end

% Parameters of the 7 component mixture approximation to a log(chi^2)
% density:
q_s = [0.00730; 0.10556; 0.00002; 0.04395; 0.34001; 0.24566; 0.25750];
m_s = [-11.40039; -5.24321; -9.83726; 1.50746; -0.65098; 0.52478; -2.35859];
u2_s = [5.79596; 2.61369; 5.17950; 0.16735; 0.64009; 0.34023; 1.26261];


%========= INITIALIZE MATRICES:
% Specify covariance matrices for measurement and state equations
numa = p*(p-1)/2;
consQ = 0.0001;
consS = 0.0001;
consH = 0.01;
consW = 0.0001;
Qdraw = consQ*eye(m);
Qchol = sqrt(consQ)*eye(m);
Ht = kron(ones(t,1),consH*eye(p));
Htsd = kron(ones(t,1),sqrt(consH)*eye(p));
Sdraw = consS*eye(numa);
Sblockdraw = cell(p-1,1);
ijc = 1;
for jj=2:p
    Sblockdraw{jj-1} = Sdraw(((jj-1)+(jj-3)*(jj-2)/2):ijc,((jj-1)+(jj-3)*(jj-2)/2):ijc);
    ijc = ijc + jj;
end
Wdraw = consW*eye(p);
Bdraw = zeros(m,t);
Atdraw = zeros(numa,t);
Sigtdraw = zeros(p,t);
sigt = kron(ones(t,1),0.01*eye(p));
statedraw = 5*ones(t,p);
Zs = kron(ones(t,1),eye(p));
prw = zeros(numel(q_s),1);

kdraw = 1*ones(t,2);
pdraw = .5*ones(1,2);
kold = kdraw;
kmean = zeros(t,2);
kmax = zeros(t,2);
kvals = ones(2,1);
kvals(1,1) = 0;
kprior = .5*ones(2,1);

% Storage matrices for posteriors and stuff
B_postmean = zeros(m,t);
At_postmean = zeros(numa,t);
Sigt_postmean = zeros(p,t);
Qmean = zeros(m,m);
Smean = zeros(numa,numa);
Wmean = zeros(p,p);

sigmean = zeros(t,p);
cormean = zeros(t,numa);
kpmean = zeros(1,2);
sig2mo = zeros(t,p);
cor2mo = zeros(t,numa);
kp2mo = zeros(1,2);

% Model selection
llikmax = -9999e200;
llikmean = 0;
gelfday = 0;
lpymean = 0;

%========= IMPULSE RESPONSES:
% Note that impulse response and related stuff involves a lot of storage
% and, hence, put istore=0 if you do not want them
istore = 1;
if istore == 1;
    % Impulse response horizon
    nhor = 21;
    imp75p = [];
    imp75u = [];
    imp75r = [];
    a75_= [];
    sig75_= [];
    imp81p = [];
    imp81u=[];
    imp81r=[];
    a81_=[];
    sig81_=[];
    a96_=[];
    sig96_=[];
    imp96p=[];
    imp96u=[];
    imp96r=[];
    a06_=[];
    sig06_=[];
    imp06p=[];
    imp06u=[];
    imp06r=[];    
    bigj=zeros(p,p*plag);
    bigj(1:p,1:p)=eye(p);
end
%----------------------------- END OF PRELIMINARIES ---------------------------

%====================================== START SAMPLING ========================================
%==============================================================================================
tic; % This is just a timer
disp('Number of iterations');

for irep = 1:nrep + nburn    % GIBBS iterations starts here
    % Print iterations
    if mod(irep,it_print) == 0
        disp(irep);toc;
    end
    % -----------------------------------------------------------------------------------------
    %   STEP I: Sample B from p(B|y,A,Sigma,V) (Drawing coefficient states, pp. 844-845)
    % -----------------------------------------------------------------------------------------
    
    % I.1: draw K1 index and related probabilities
    %----------------------------------------------------------------------
    ap = ap_0(1,1) + sum(kdraw(:,1));
    bp = bp_0(1,1) + t - sum(kdraw(:,1));

    pdrawa = betarnd(ap,bp);
    pdraw(1,1) = pdrawa;
    kprior(2,1) = pdrawa;
    kprior(1,1) = 1 - kprior(2,1);
    
    [kdrawa,lpyB] = gck(y,zeros(p,t),Z,Htsd,zeros(m,t),kron(ones(t,1),eye(m)),Qchol',kold(:,1),t,zeros(m,1),zeros(m,m),2,kprior,kvals,p,m);
    %kdrawa = 1*ones(t,1);
    kdraw(:,1) = kdrawa;
    kold(:,1) = kdraw(:,1);
    
    % I.2: draw Bt and keep only stationary draws
    %----------------------------------------------------------------------
    [Bdrawc,log_lik] = carter_kohn(y,Z,Ht,Qdraw,m,p,t,B_0_prmean,B_0_prvar,kdraw(:,1));
    Bdraw = Bdrawc;
    
%     %Now check for the polynomial roots to see if explosive
%     %first rearrange VAR coeffs as needed for polymroot
%     ctemp1 = zeros(p,p*plag);
%     counter = [];
%     restviol=0;
%     for i = 1:t;
%         BBctempor = [];
%         for jj=1:plag
%             BBtempor = Bdrawc((jj-1)*p*p +1:jj*p*p,i);
%             BBtempor = reshape(BBtempor,p,p)';
%             BBctempor = [BBctempor  BBtempor]; %#ok<AGROW>
%         end
%         ctemp1 = [BBctempor; eye(p*(plag-1)) zeros(p*(plag-1),p)];
%         if max(abs(eig(ctemp1))) > 0.9999;
%             restviol=1;
%             counter = [counter ; restviol]; %#ok<AGROW>
%         end
%     end
%     %if they haven't been rejected, then accept them, else keep old draw
%     if sum(counter)==0
%         Btdraw = Bdrawc;
%         disp('I found a keeper!');
%     end
    
    Btemp = Bdraw(:,2:t)' - Bdraw(:,1:t-1)';
    sse_2 = zeros(m,m);
    for i = 1:t-1
        sse_2 = sse_2 + Btemp(i,:)'*Btemp(i,:);
    end

    Qinv = inv(sse_2 + Q_prmean);
    Qinvdraw = wish(Qinv,t+Q_prvar);
    Qdraw = inv(Qinvdraw);
    Qchol = chol(Qdraw);

    %-------------------------------------------------------------------------------------------
    %   STEP II: Draw At from p(At|y,B,Sigma,V) (Drawing coefficient states, p. 845)
    %-------------------------------------------------------------------------------------------
    % Substract from the data y(t), the mean Z x B(t)
    yhat = zeros(p,t);
    for i = 1:t
        yhat(:,i) = y(:,i) - Z((i-1)*p+1:i*p,:)*Bdraw(:,i);
    end
    
    % This part is more tricky, check Primiceri
    % Zc is a [p x p(p-1)/2] matrix defined in (A.2) page 845, Primiceri
    Zc = - yhat(:,:)';
    sigma2temp = zeros(t,p);
    for i = 1:t
        sigma2temp(i,:) = diag(sigt((i-1)*p+1:i*p,:)^2)';
    end
    
    Atdraw = [];
    ind = 1;
    for ii = 2:p
        % Draw each block of A(t)
        [Atblockdraw,log_lik2a] = carter_kohn(yhat(ii,:),Zc(:,1:ii-1),sigma2temp(:,ii),...
            Sblockdraw{ii-1},sizeS(ii-1),1,t,A_0_prmean(((ii-1)+(ii-3)*(ii-2)/2):ind,:),A_0_prvar(((ii-1)+(ii-3)*(ii-2)/2):ind,((ii-1)+(ii-3)*(ii-2)/2):ind),ones(t,1));
        Atdraw = [Atdraw ; Atblockdraw]; %#ok<AGROW> % Atdraw is the final matrix of draws of A(t)
        ind = ind + ii;
    end
    
    %=====| Draw S, the covariance of A(t) (from iWishart)
    Attemp = Atdraw(:,2:t)' - Atdraw(:,1:t-1)';
    sse_2 = zeros(numa,numa);
    for i = 1:t-1
        sse_2 = sse_2 + Attemp(i,:)'*Attemp(i,:);
    end
    
    ijc = 1;
    for jj=2:p
        Sinv = inv(sse_2(((jj-1)+(jj-3)*(jj-2)/2):ijc,((jj-1)+(jj-3)*(jj-2)/2):ijc) + S_prmean{jj-1});
        Sinvblockdraw = wish(Sinv,t+S_prvar(jj-1));
        Sblockdraw{jj-1} = inv(Sinvblockdraw);
        ijc = ijc + jj;
    end
    %------------------------------------------------------------------------------------------
    %   STEP III: Draw diagonal VAR covariance matrix "H_t" elements
    %------------------------------------------------------------------------------------------
    capAt = zeros(p*t,p);
    for i = 1:t
        capatemp = eye(p);
        aatemp = Atdraw(:,i);
        ic=1;
        for j = 2:p
            capatemp(j,1:j-1) = aatemp(ic:ic+j-2,1)';
            ic = ic + j - 1;
        end
        capAt((i-1)*p+1:i*p,:) = capatemp;
    end
    % III.1: draw "H_t"s' elements from Normal distribution
    %----------------------------------------------------------------------
    y2 = [];
    for i = 1:t
        ytemps = capAt((i-1)*p+1:i*p,:)*yhat(:,i);
        y2 = [y2  (ytemps.^2)]; %#ok<AGROW>
    end   

    yss = zeros(t,p);
    for i = 1:p
        yss(:,i) = log(y2(i,:)' + 0.001);
    end
        
    % III.1: draw K2 index and related probabilities
    %----------------------------------------------------------------------
    ap = ap_0(2,1) + sum(kdraw(:,2));
    bp = bp_0(2,1) + t - sum(kdraw(:,2));

    pdrawa = betarnd(ap,bp);
    pdraw(1,2) = pdrawa;
    kprior(2,1) = pdrawa;
    kprior(1,1) = 1 - kprior(2,1);
    Wchol = chol(Wdraw)';

    [kdrawa] = gck1(yss',zeros(p,t),Zs,zeros(p,t),kron(ones(t,1),eye(p)),Wchol,kold(:,2),t,zeros(p,1),zeros(p,p),2,kprior,kvals,p,p,statedraw);
    %kdrawa=1*ones(t,1);
    kdraw(:,2) = kdrawa;
    kold(:,2) = kdraw(:,2);
    
    % III.2: draw "H_t"s' elements from Normal distribution
    %----------------------------------------------------------------------    
    %First draw volatilities conditional on sdraw
    vart = zeros(t*p,p);
    yss1 = zeros(t,p);
    for i = 1:t
        for j = 1:p
            imix = statedraw(i,j);
            vart((i-1)*p+j,j) = u2_s(imix);
            yss1(i,j) = yss(i,j) - m_s(imix) + 1.2704;
        end
    end
    [Sigtdraw,log_lik3] = carter_kohn(yss1',Zs,vart,Wdraw,p,p,t,sigma_prmean,sigma_prvar,kdraw(:,2));
    
    % Next draw statedraw (chi square approximation mixture component) conditional on Sigtdraw
    for jj = 1:p
        for i = 1:t
            for j = 1:numel(m_s)
                temp1= (1/sqrt(2*pi*u2_s(j)))*exp(-.5*(((yss(i,jj) - Sigtdraw(jj,i) - m_s(j) + 1.2704)^2)/u2_s(j)));
                prw(j,1) = q_s(j,1)*temp1;
            end
            prw = prw./sum(prw);
            cprw = cumsum(prw);
            trand = rand(1,1);
            if trand < cprw(1,1); imix=1;
            elseif trand < cprw(2,1), imix=2;
            elseif trand < cprw(3,1), imix=3;
            elseif trand < cprw(4,1), imix=4;
            elseif trand < cprw(5,1), imix=5;
            elseif trand < cprw(6,1), imix=6;
            else imix=7; 
            end
            statedraw(i,jj)=imix;
        end
    end

    sigtemp = eye(p);
    sigt = zeros(p*t,p);
    for i = 1:t
        for j = 1:p
            sigtemp(j,j) = exp(.5*Sigtdraw(j,i));
        end
        sigt((i-1)*p+1:i*p,:) = sigtemp;
    end

    Sigttemp = Sigtdraw(:,2:t)' - Sigtdraw(:,1:t-1)';

    sse_2 = zeros(p,p);
    for i = 1:t-1
        sse_2 = sse_2 + Sigttemp(i,:)'*Sigttemp(i,:);
    end
    Winv = inv(sse_2 + W_prmean);
    Winvdraw = wish(Winv,t+W_prvar);
    Wdraw = inv(Winvdraw);

    Ht = zeros(p*t,p);
    Htsd = zeros(p*t,p);
    for i = 1:t
        inva = inv(capAt((i-1)*p+1:i*p,:));
        stem = sigt((i-1)*p+1:i*p,:);
        Hsd = inva*stem;
        Hdraw = Hsd*Hsd';
        Ht((i-1)*p+1:i*p,:) = Hdraw;
        Htsd((i-1)*p+1:i*p,:) = Hsd;
    end
    
    %----------------------------SAVE AFTER-BURN-IN DRAWS AND IMPULSE RESPONSES -----------------
    if irep > nburn;
        B_postmean = B_postmean + Bdraw;
        At_postmean = At_postmean + Atdraw;
        Sigt_postmean = Sigt_postmean + Sigtdraw;
        Qmean = Qmean + Qdraw;
        ikc = 1;
        for kk = 2:p
            Sdraw(((kk-1)+(kk-3)*(kk-2)/2):ikc,((kk-1)+(kk-3)*(kk-2)/2):ikc)=Sblockdraw{kk-1};
            ikc = ikc + kk;
        end
        Smean = Smean + Sdraw;
        Wmean = Wmean + Wdraw;
        kmean = kmean + kdraw;
        kpmean = kpmean + pdraw;
        kp2mo = kp2mo + pdraw.^2;
        stemp6 = zeros(p,1);
        stemp5 = [];
        stemp7 = [];
        for i = 1:t
            stemp8 = corrvc(Ht((i-1)*p+1:i*p,:));
            stemp7a = [];
            ic = 1;
            for j = 1:p
                if j>1;
                    stemp7a = [stemp7a ; stemp8(j,1:ic)']; %#ok<AGROW>
                    ic = ic+1;
                end
                stemp6(j,1) = sqrt(Ht((i-1)*p+j,j));
            end
            stemp5 = [stemp5 ; stemp6']; %#ok<AGROW>
            stemp7 = [stemp7 ; stemp7a']; %#ok<AGROW>
        end
        sigmean = sigmean + stemp5;
        cormean =cormean + stemp7; 
        sig2mo = sig2mo + stemp5.^2;
        cor2mo = cor2mo + stemp7.^2;
         
        if istore==1;
            % Impulse response analysis. Note that Htsd contains the
            % structural error cov matrix
            % Set up things in VAR(1) format as in Lutkepohl page 11
            k = size(Bdraw,1);
            biga = zeros(p*plag,p*plag);
            for j = 1:plag-1
                biga(j*p+1:p*(j+1),p*(j-1)+1:j*p) = eye(p);
            end

            for i = 1:t %Get impulses recurssively for each time period
                bbtemp = Bdraw(p+1:k,i);
                splace = 0;
                for ii = 1:plag
                    for iii = 1:p
                        biga(iii,(ii-1)*p+1:ii*p) = bbtemp(splace+1:splace+p,1)';
                        splace = splace + p;
                    end
                end

                % ------------Identification code:
                % st dev matrix for structural VAR
                Hsd = Htsd((i-1)*p+1:i*p,1:p);
                %Hsd=eye(p);
                
                %now get impulse responses for 1 through nhor future
                %periods
                impresp = zeros(p,p*nhor);
                impresp(1:p,1:p) = Hsd;
                bigai = biga;
                for j = 1:nhor-1
                    impresp(:,j*p+1:(j+1)*p) = bigj*bigai*bigj'*Hsd;
                    bigai = bigai*biga;
                end

                if yearlab(i,1) == 1975;
                    sig75_ = [sig75_ ; (vec(Hsd)')];
                    a75_ = [a75_ ; (bbtemp')];
                    imp75_m = zeros(p,nhor);
                    jj=0;
                    for ij = 1:nhor
                        jj = jj + p;
                        imp75_m(:,ij) = impresp(:,jj);
                    end
                    imp75p = [imp75p ; imp75_m(1,:)];
                    imp75u = [imp75u ; imp75_m(2,:)];
                    imp75r = [imp75r ; imp75_m(3,:)];
                end
                if yearlab(i,1) == 1981.75;
                    sig81_ = [sig81_ ; (vec(Hsd)')];
                    a81_ = [a81_ ; (bbtemp')];
                    imp81_m = zeros(p,nhor);
                    jj=0;
                    for ij = 1:nhor
                        jj = jj + p;
                        imp81_m(:,ij) = impresp(:,jj);
                    end
                    imp81p = [imp81p ; imp81_m(1,:)];
                    imp81u = [imp81u ; imp81_m(2,:)];
                    imp81r = [imp81r ; imp81_m(3,:)];
                end                
                if yearlab(i,1) == 1996;
                    sig96_ = [sig96_ ; (vec(Hsd)')];
                    a96_ = [a96_ ; (bbtemp')];
                    imp96_m = zeros(p,nhor);
                    jj = 0;
                    for ij = 1:nhor
                        jj = jj + p;
                        imp96_m(:,ij) = impresp(:,jj);
                    end
                    imp96p = [imp96p ; imp96_m(1,:)];
                    imp96u = [imp96u ; imp96_m(2,:)];
                    imp96r = [imp96r ; imp96_m(3,:)];
                end
                if yearlab(i,1) == 2006.5;
                    sig06_ = [sig06_ ; (vec(Hsd)')];
                    a06_ = [a06_ ; (bbtemp')];
                    imp06_m = zeros(p,nhor);
                    jj = 0;
                    for ij = 1:nhor
                        jj = jj + p;
                        imp06_m(:,ij) = impresp(:,jj);
                    end
                    imp06p = [imp06p ; imp06_m(1,:)];
                    imp06u = [imp06u ; imp06_m(2,:)];
                    imp06r = [imp06r ; imp06_m(3,:)];
                end
            end %END geting impulses for each time period 
        end %END the impulse response calculation section   
    end % END saving after burn-in results 
end %END main Gibbs loop (for irep = 1:nrep+nburn)

toc; % Stop timer and print total time
%=============================GIBBS SAMPLER ENDS HERE==================================

B_postmean = B_postmean./nrep;
At_postmean = At_postmean./nrep;
Sigt_postmean = Sigt_postmean./nrep;
Qmean = Qmean./nrep;
Smean = Smean./nrep;
Wmean = Wmean./nrep;
kmean = kmean./nrep;
kpmean = kpmean./nrep;
kp2mo = kp2mo./nrep;
sigmean = sigmean./nrep;
cormean = cormean./nrep;
sig2mo = sig2mo./nrep;
cor2mo = cor2mo./nrep;





