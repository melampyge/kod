% Online prediction using DMA
% One model case (and hence no model averaging)
% TVP-AR with forgetting and recurssive moment estimation of the
% measurement variance. 
%==========================================================================
%This is just for demonstration. If you need to implement DMA with many 
%models, use DMA.m and DMA_memory.m
%==========================================================================

% Written by Dimitris Korobilis, 2008

clear all;
clc;
randn('state',sum(100*clock));
rand('twister',sum(100*clock)); 

%-----------------------------LOAD DATA------------------------------------
% Load quarterly inflation data & explanatory variables from 1959:Q1 - 2006:Q4
cd D:\MATLAB\DMA\quarterly;
%first load the dependent (various definitions of inflation)
load GDPDEFL.dat; load PCECTPI.dat; load PCE.dat; load CPIAUCSL.dat; load CPILFESL.dat; load PPIACO.dat;
%and then the explanatory variables, names, year and transforation indexes
load xdata.dat;
load namesX.mat;
load tcode.dat;
load yearlab.dat;
cd ..

% ------------Transform data to be approximately stationary
% Transform "X"
for i_x = 1:size(xdata,2)
    if tcode(i_x)==5
        xtempraw(:,i_x) = 100*transx(xdata(:,i_x),tcode(i_x)); %#ok<AGROW>
    else
        xtempraw(:,i_x) = transx(xdata(:,i_x),tcode(i_x)); %#ok<AGROW>
    end
end

% Transform "Y"
GDPDEFL = 100*transx(GDPDEFL,5);
PCECTPI = 100*transx(PCECTPI,5);
PCE = 100*transx(PCE,5);
CPIAUCSL = 100*transx(CPIAUCSL,5);
CPILFESL = 100*transx(CPILFESL,5);
PPIACO = 100*transx(PPIACO,5);

% Define here which of the many variables in xdata will be used for
% forecasting
Xindex = [1:size(xdata,2)]; % use all variables
%Xindex = [1 2 3 4 5];% 6 7 8 9 10];% 11 12 16]; %[1 4 7]                           %  <----------------***** CHANGE *****

% Y is GDP deflator or PCE or... (change). X names are in matrix 'namesX'
% Note that we loose 1 obs because of stationarity transformations
Y = GDPDEFL(49:end-2,1);                                                            %  <----------------***** CHANGE *****
X = xtempraw(49:end-2,Xindex);

tgary=namesX;
namesX=namesX(Xindex);

% % Simulate data from DGP
% [Y,X,state]=simDLM2();

% Number of observations and dimension of X and Y
T = size(Y,1);

% Number of exogenous predictors
h = size(X,2);
 
% Number of lags:                                           %  <----------------***** CHANGE *****
plag = 2; % plag is number of lags of the endogenous variable
hlag = 0; % hlag is number of EXTRA lags of the exogenous variables
LAGS = max(plag,hlag);

% Define d-step ahead forecasts (i.e. forward variable Y d-periods ahead
% the predictor variables).
% choices:  d=1  / y[t+1] = b[t] x X[t] + e[t+1]
%           d=4  / y[t+4] = b[t] x X[t] + e[t+4]
%           ... and so on
d=1;                                                        %  <----------------***** CHANGE *****
Y2 = Y(2:end-d+1,:);
X = X(1:end-d,:);
Y = Y(1+d:end,:);
T=T-d;
% ===================================| Create lagged depended variable|=========================
% Generate lagged Y matrix.
ylag = mlag2(Y2,plag); % Y is [T x m]. ylag is [T x (m x plag)]
ylag = ylag(LAGS+1:T,:);

xlag = mlag2(X,hlag);
xlag = xlag(LAGS+1:T,:);

m = 1 + plag + h*hlag; % m is the number of elements in the state vector
% Create X_t
x_t = [ones(T-plag,1) ylag];

% Redefine FAVAR variables y
y_t = Y(LAGS+1:T,:);

% Time series observations
%yearlab = yearlab(LAGS+1:T,:);
T=size(y_t,1);

% create vector with names of variables
namesARY = cell(plag,1);
for ii = 1:plag
    ff = 'ARY_1';
    fg = strrep(ff, '1', num2str(ii));
    namesARY{ii,1} =  fg;
end

namesARX = cell(h*hlag,1);
for ii = 1:hlag
    for j = 1:h   
        namesARX{(ii-1)*h + j,1} = [namesX{j,1} '_' num2str(ii)]; %#ok<USENS>
    end
end

Xnames = ['constant'; namesARY ; namesARX ]; %This vector contains the names of the variables in z_t

%----------------------------PRELIMINARIES---------------------------------
% Define the sample that will be used for forecasting
t=T;
%t = ceil(T/2);

%========= PRIORS:
%-------- Now set prior means and variances (_prmean / _prvar)
% theta_0 ~ N(theta_OLS, Var(theta_OLS))
theta_OLS = (y_t(1:t,:)'/x_t(1:t,:)')';
%theta_0_prmean = theta_OLS;
theta_0_prmean = zeros(m,1);
temp = (y_t(1:t,:)'/x_t(1:t,:)')';
s_02 = temp(1,1).^2 + var(y_t(1:t,:));
%theta_0_prvar = 0.1*diag([s_02./100]);% (var(y_t(1:t,:))./var(x_t(1:t,2:end)))']);
theta_0_prvar = 10*eye(m);

% Define forgetting factor:
lamda = 0.99;                                          %  <----------------***** CHANGE *****

%----------------------------- END OF PRELIMINARIES ---------------------------
tic;
for i = 1:t
    % Predict
    if i==1
        theta_pred(:,i) = theta_0_prmean;  % this is eq.(3)
        R_t(:,:,i) = (1./lamda)*theta_0_prvar;  % this is eq.(5)
    else
        theta_pred(:,i) = theta_update(:,i-1);    % this is eq.(3)
        R_t(:,:,i) = (1./lamda)*squeeze(S_t(:,:,i-1));     % this is eq.(5)
    end
    y_t_pred(i,:) = x_t(i,:)*theta_pred(:,i);  % this is one step ahead prediction
    
    % Update
    e_t(:,i) = y_t(i,:) - x_t(i,:)*theta_pred(:,i);  % this is one step ahead prediction error
    % first update V[t], see the part below equation (10)
    if i==1
        A_t(:,i) = (1/i)*(e_t(:,i).^2 - x_t(i,:)*squeeze(R_t(:,:,i))*x_t(i,:)');
        if A_t(:,i)>0
            V_t(:,i) = A_t(:,i);
        else
            V_t(:,i) = 1; %abs(A_t(:,i));
        end
    else
        A_t(:,i) = ((i-1)/i)*V_t(:,i-1) + (1/i)*(e_t(:,i).^2 - x_t(i,:)*squeeze(R_t(:,:,i))*x_t(i,:)');
        if A_t(:,i)>0
            V_t(:,i) = A_t(:,i);
        else
            V_t(:,i) = V_t(:,i-1);
        end
    end
    %V_t(:,i) = 1/i*(e_t(:,i).^2 - x_t(i,:)*squeeze(R_t(:,:,i))*x_t(i,:)');
    
    %update theta[t]
    theta_update(:,i) = theta_pred(:,i) + squeeze(R_t(:,:,i))*x_t(i,:)'*inv(V_t(:,i) + x_t(i,:)*squeeze(R_t(:,:,i))*x_t(i,:)')*e_t(:,i);      % this is eq.(7)
    S_t(:,:,i) = squeeze(R_t(:,:,i)) - squeeze(R_t(:,:,i))*x_t(i,:)'*inv(V_t(:,i) + x_t(i,:)*squeeze(R_t(:,:,i))*x_t(i,:)')*x_t(i,:)*squeeze(R_t(:,:,i));   % this is eq.(8)
    
    % recursive OLS forecasts (just for comparisons)
    if i==1
        theta_recOLS(:,i)=zeros(m,1);
        y_t_OLS(i,1) = 0;    
    else
        theta_recOLS(:,i)=(y_t(1:i-1,:)'/x_t(1:i-1,:)')';
        y_t_OLS(i,1) = x_t(i-1,:)*theta_recOLS(:,i);
    end
    
end

toc;



