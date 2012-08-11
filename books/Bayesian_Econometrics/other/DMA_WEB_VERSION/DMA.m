% Online prediction using DMA (Koop and Korobilis, 2009, Forecasting
% Inflation using Dynamic Model Averaging)
% http://www.rcfea.org/RePEc/pdf/wp34_09.pdf
%==========================================================================
% NOTE that I use only 5 out of all the possible predictors. You can change
% this around line 76. However note that if you use all predictors, you
% need a good PC with probably 4-8 GB of memory. I DO NOT TAKE
% RESPONSIBILITY IF YOUR PC GETS STUCK BECAUSE OF MISUSE OF THIS PROGRAM.
% Please make sure you understand this code before you hit "RUN". I provide 
% a separate version of this code which stores less matrices and is much 
% more memory efficient (DMA_memory.m)
%==========================================================================
% TVP-AR with forgetting and recurssive moment estimation of the
% measurement variance.
%
%        y[t] = theta[t] x z[t] + e1,        e1 ~ N(0,V_t)
%    theta[t] = theta[t-1]      + e2,        e2 ~ N(0,S_t)  
%
% where z[t] is the matrix of predictor variables and theta[t] the
% time-varying regression coefficient.
%
% Here first define matrix z[t] in line 111 with the maximum number of
% regressors. Then BMA is done over all possible models defined by the
% columns of z_t (i.e. if N regressors in z_t, then #_of_models = 2.^N
% I use 2 lags (see variable 'plag') which gives an intercept, the AR(1)
% coefficient and the AR(2) coefficient. All possible models are 8 = 2^3.
%
% NOTE: I have indicated the things you might want to change in the code,
% with a large " <----------------***** CHANGE ***** " arrow.
%
%==========================================================================
% Written on 20/11/2008
% Dimitris Korobilis,
% University of Strathclyde

clear all;
clc;

%randn('state',sum(100*clock));
%rand('twister',sum(100*clock)); 

%-----------------------------LOAD DATA------------------------------------
% Load quarterly inflation data & explanatory variables from 1959:Q1 - 2006:Q4
%%%% NOTE: Make sure you change the directory to the one you have your%%%%%
%%%% data!!!!!!!!!!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd D:\MATLAB\DMA_WEB_VERSION\quarterly;
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
        xtempraw(:,i_x) = 100*transx(xdata(:,i_x),tcode(i_x)); 
    else
        xtempraw(:,i_x) = transx(xdata(:,i_x),tcode(i_x)); 
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
%%%% BE VERY CAREFUL HERE, SINCE IF YOU USE MORE THAN 10 VARIABLES YOU%%%%%
%%%% MIGHT HAVE TROUBLES IN A SLOW PC%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xindex = [1:size(xdata,2)]; % use all variables
Xindex = [1 2 3 4 5];% 6 7 8 9 10];% 11 12 16]; %[1 4 7]          %  <----------------***** CHANGE *****

% Y is GDP deflator. X names are in matrix 'namesX'
% Note that we loose 1 obs because of stationarity transformations
Y = GDPDEFL(49:end-2,1);
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

% Generate lagged X matrix.
xlag = mlag2(X,hlag);
xlag = xlag(LAGS+1:T,:);

m = 1 + plag +  h*(hlag+1); % m is the number of elements in the state vector
% Create X_t
z_t = [X(LAGS+1:T,:) xlag];
Z_t = [ones(T-LAGS,1) ylag];

% Redefine variables y
y_t = Y(LAGS+1:T,:);

% Time series observations
yearlab = yearlab(LAGS+1:T,:);
T=size(y_t,1);

% create vector with names of variables
namesARY = cell(plag,1);
for ii = 1:plag
    ff = 'ARY_1';
    fg = strrep(ff, '1', num2str(ii));
    namesARY{ii,1} =  fg;
end

namesARX = cell(h*(hlag+1),1);
for ii = 1:hlag+1
    for j = 1:h   
        namesARX{(ii-1)*h + j,1} = [namesX{j,1} '_' num2str(ii)];
    end
end

test1=cell(1,1);
test1{1,1} = 'constant';
%Xnames = ['constant'; namesARY ; namesARX ]; %This vector contains the names of the variables in x_t
Xnames = [test1; namesARY ; namesARX ]; %This vector contains the names of the variables in x_t

% ======================| Form all possible model combinations |======================
% if z_t (the full model matrix of regressors) has N elements, all possible combinations 
% are (2^N - 1), i.e. 2^N minus the model with all predictors/constant excluded (y_t = error)
N = size(z_t,2);
comb = cell(N,1);
for nn = 1:N
    % 'comb' has N cells with all possible combinations for each N
    comb{nn,1} = combntns(1:N,nn);
end

K = 2.^N;  %Total number of models
index_temp = cell(K,1);
dim = zeros(1,N+1);
for nn=1:N
    dim(:,nn+1) = size(comb{nn,1},1);
    for jj=1:size(comb{nn,1},1)
        % Take all possible combinations from variable 'comb' and sort them
        % in each row of 'index'. Index now has a vector in each K row that
        % indexes the variables to be used, i.e. for N==3:
        % index = {[1] ; [2] ; [3] ; [1 2] ; [1 3] ; [2 3] ; [1 2 3]}
        index_temp{jj + sum(dim(:,1:nn)),1} = comb{nn,1}(jj,:);
    end
end

% x_t_temp = cell(K,1);
% for ll = 1:K
%     % Each cell of x_t now has the explanatory variables for each of the K
%     % models that will be used in model averaging
%     x_t_temp{ll,1} = z_t(:,index_temp{ll,1}');
% end

x_t = cell(K,1);
for ll2 = 1:K
    % Now also add the variables in Z_t that are always included in each
    % model (i.e. no DMA for the variables defined in Z_t, as opposed to
    % the variables in z_t)
    x_t{ll2,1} = [Z_t z_t(:,index_temp{ll2,1}')];%x_t_temp{ll2,1}];
end

% Fix now the dimensions of the "index" variable to include the indexes for
% the variables that are not subject to DMA
for iii=1:K
    index_temp{iii,1} = index_temp{iii,1} + plag + 1;
end

index = cell(K,1);
for iii=1:K
    index{iii,1} = [ [1 2:plag+1] index_temp{iii,1}];
end
%----------------------------PRELIMINARIES---------------------------------

%========= PRIORS:
%-------- Now set prior means and variances (_prmean / _prvar)
% theta_0 ~ N(theta_OLS, Var(theta_OLS))

PRM = 0; % Prior mean of state variable                        <----------------***** CHANGE *****
PRV = 100; % Prior variance of state variable                  <----------------***** CHANGE *****

theta_OLS = cell(K,1);
theta_0_prmean = cell(K,1);
theta_0_prvar = cell(K,1);
for ll = 1:K
    theta_OLS{ll,1} = (y_t(1:T,:)'/x_t{ll,1}(1:T,:)')'; 
    theta_0_prmean{ll,1} = PRM*ones(size(x_t{ll,1},2),1);
    if sum(x_t{ll,1}(:,1)) == T               %if this condition is satisfied, we have a constant in the model
        s_02 = (theta_OLS{ll,1}(1,1)).^2 + var(y_t(1:T,:));
        if size(x_t{ll,1},2) == 1             %if this condition is satisfied, we have the model with ONLY the constant as RHS variable
            theta_0_prvar{ll,1} = PRV;   %0.1*diag(s_02./100);
        else
            theta_0_prvar{ll,1} =  PRV*eye(size(x_t{ll,1},2));    %0.1*diag([s_02./100; (var(y_t(1:T,:))./var(x_t{ll,1}(1:T,2:end)))']);
        end
    else
        theta_0_prvar{ll,1} =   PRV*eye(size(x_t{ll,1},2));       %0.1*diag((var(y_t(1:T,:))./var(x_t{ll,1}(1:T,:)))');
    end
end

% initial model probability for each individual model
prob_0_prmean = 1./K;              %                      <----------------***** CHANGE *****

% Define forgetting factor(s):
lamda = 0.99;                      %                      <----------------***** CHANGE *****
inv_lamda = 1./lamda;
alpha = 0.99;                      %                      <----------------***** CHANGE *****

% Initialize matrices
theta_pred = cell(K,1);
R_t = cell(K,1);
prob_pred = zeros(1,T,K);
y_t_pred = cell(K,1);
e_t = cell(K,1);
A_t = cell(K,1);
V_t = cell(K,1);
xRx2 = cell(K,1);
theta_update = cell(K,1);
S_t = cell(K,1);
w_t = cell(K,1);
prob_update = zeros(1,T,K);
theta_recOLS = cell(K,1);
y_t_OLS = cell(K,1);
y_t_DMA = zeros(T,1);
y_t_BEST = zeros(T,1);
%----------------------------- END OF PRELIMINARIES ---------------------------
tic;
disp('You are running program DMA_full.m')
disp('       ')

% =============================Start now the big Kalman filter loop 
for irep = 1:T % for 1 to T time periods
    if mod(irep,ceil(T./20)) == 0
        disp([num2str(100*(irep/T)) '% completed'])
        toc;
    end
    
    if irep>1
        sum_prob_a = sum((prob_update(:,irep-1,1:K)).^alpha,3);  % this is the sum of the K model probabilities (all in the power of the forgetting factor 'a')
    end
    R_t = cell(K,1);
    for k = 1:K  % for 1 to K competing models
        
        % -----------------------Predict
        if irep==1
            theta_pred{k,1}(:,irep) = theta_0_prmean{k,1};  % predict theta[t], this is Eq. (5)
          % R_t{k,1}(:,:,irep) = inv_lamda*theta_0_prvar{k,1};  % predict R[t], this is Eq. (6)
            R_t{k,1} = inv_lamda*theta_0_prvar{k,1};
            temp1 = ((prob_0_prmean).^alpha);  
            prob_pred(:,irep,k) = temp1./(K*temp1);     % predict model probability, this is Eq. (15)
        else
            theta_pred{k,1}(:,irep) = theta_update{k,1}(:,irep-1);    % predict theta[t], this is Eq. (5)
            %R_t{k,1}(:,:,irep) = inv_lamda.*S_t{k,1}(:,:,irep-1);     % predict R[t], this is Eq. (6)
            R_t{k,1} = inv_lamda.*S_t{k,1};
            prob_pred(:,irep,k) = ((prob_update(:,irep-1,k)).^alpha + 0.00000001)./(sum_prob_a + 0.00000001);   % predict model probability, this is Eq. (15)
        end

        % Now implememnt individual-model predictions of the variable of interest
        y_t_pred{k,1}(irep,:) = x_t{k,1}(irep,:)*theta_pred{k,1}(:,irep);   %one step ahead prediction
        
        
        % -------------------------Update
        e_t{k,1}(:,irep) = y_t(irep,:) - x_t{k,1}(irep,:)*theta_pred{k,1}(:,irep); % one-step ahead prediction error
        
        % We will need some products of matrices several times, which is better to define them
        % once here for computational efficiency
        R_mat = R_t{k,1};
        xRx = x_t{k,1}(irep,:)*R_mat*x_t{k,1}(irep,:)';
        xRx2{k,1}(:,irep) = x_t{k,1}(irep,:)*R_mat*x_t{k,1}(irep,:)';
        
        % Update V_t - measurement error covariance matrix using rolling
        % moments estimator, see top of page 12
        % ****Note that in the revision we have an EWMA model for variance,
        % which needs a separate decay factor. See the revised paper for
        % more info.****
        if irep<20
            A_t{k,1} = (1/irep)*((e_t{k,1}(:,irep)).^2 - xRx);
            if A_t{k,1}>0   % if the variance is positive keep it
                V_t{k,1}(:,irep) = A_t{k,1};
            else
                if irep==1;  % at t=1, A_t will not be positive, hence we will need to initialize it, say at 0.1
                    V_t{k,1}(:,irep) = 0.1; % IN PRACTISE YOU MIGHT NEED TO USE A TRAINING SAMPLE ESTIMATOR OF THIS.
                                            % BE CAREFUL WHAT INITIAL VALUE YOU USE!!!!!!
                else    % if the variance is not positive at any other t, use the value at t-1    
                    V_t{k,1}(:,irep) = V_t{k,1}(:,irep-1);
                end
            end
        else
            A_t{k,1} = (1/20)*sum(e_t{k,1}(:,irep-20+1:irep).^2 - xRx2{k,1}(:,irep-20+1:irep));
            if A_t{k,1}>0
                V_t{k,1}(:,irep) = A_t{k,1};
            else   % if the variance is not positive at any other t, use the value at t-1   
                V_t{k,1}(:,irep) = V_t{k,1}(:,irep-1);
            end
        end
        
        % Update theta[t] (regression coefficient) and its covariance
        % matrix S[t] (state equation covariance), see Equations (8) - (9)
        inv_mat = inv(V_t{k,1}(:,irep) + xRx);
        theta_update{k,1}(:,irep) = theta_pred{k,1}(:,irep) + R_mat*x_t{k,1}(irep,:)'*inv_mat*e_t{k,1}(:,irep);
        %S_t{k,1}(:,:,irep) = R_mat - R_mat*x_t{k,1}(irep,:)'*inv_mat*x_t{k,1}(irep,:)*R_mat;
        S_t{k,1} = R_mat - R_mat*x_t{k,1}(irep,:)'*inv_mat*x_t{k,1}(irep,:)*R_mat; %#ok<*MINV>
        
        % Update model probability
        variance = V_t{k,1}(:,irep) + xRx;
        mean = x_t{k,1}(irep,:)*theta_pred{k,1}(:,irep);
        f_l = (1/sqrt(2*pi*variance))*exp(-.5*(((y_t(irep,:) - mean)^2)/variance)); %normpdf(y_t(irep,:),mean,variance);
        w_t{k,1}(:,irep) = prob_pred(:,irep,k)*real(f_l);
        
    end % end cycling through all possible K models
    
    % First calculate the denominator of Equation (16) (the sum of the w's)
    sum_w_t = 0;
    for k_2=1:K
        sum_w_t = sum_w_t + w_t{k_2,1}(:,irep);
    end
    
    % Then calculate the updated model probabilities
    for k_3 = 1:K
        prob_update(:,irep,k_3) = w_t{k_3,1}(:,irep)./sum_w_t;  % this is Equation (16)
    end
    
    % Now we have the predictions for each model & the associated model probabilities: Do DMA prediction
    for k_4 = 1:K
        temp_pred = y_t_pred{k_4,1}(irep,:)*prob_pred(:,irep,k_4);
        y_t_DMA(irep,:) = y_t_DMA(irep,:) + temp_pred;
    end
    
end
%***********************************************************

% Find now the best models 
g = zeros(K,T);
for iii=1:K
    g(iii,:)= prob_update(1,:,iii) ;
end

for ii=1:T
    [max_prob(ii,1) best_model(ii,1)]=max(g(:,ii)); %#ok<*SAGROW>
end

for ii=1:T
    y_t_BEST(ii,1) = y_t_pred{best_model(ii,1),1}(ii,:);
end

% Print some directions for Gary to know which variable is which
clc;
disp('End of estimation')
toc;
disp('  ')
disp('If you want to plot the probs, use the command: plot(yearlab,prob_update{K,1}(1,:))')
disp('If you want to plot the regression coefficients, use the command: CHECK END OF THE CODE....')
disp('where "K" is the model number (1 to 2047, if you are using 11 predictors!)')
disp('Please check which variables are used in each model K using the command: Xnames(index{K,1})')
disp('For a specific choice of K, this gives the names of the variables of z_t included in the exogenous regressors.')
disp('  ')
disp('DMA predictions are in the vector "y_t_DMA"')
disp('Best model predictions (i.e. best at each time "t", not overall) are in the vector "y_t_BEST"')
disp('These are directly comparable with the actual observations vector "y_t"') 
disp('Hence: abs(y_t - y_t_DMA) , gives the mean absolute deviation')
disp('  ')
disp('Maximum probability of a single model at each point in time is in the vector "max_prob"')
disp('The index of the best single model at each point in time is in the vector "best_model"')
disp('Hence you may want to plot the "probabilities" and "theta" parameters for the "Ks" in the vector "best_model"')
disp('instead of using an arbitrary value for K. Also the command plot(yearlab,best_model) will give you an idea of how the')
disp('probabilities move at each point in time and which is the best model for each "t"')
disp('  ')
disp('Have fun')


%--------------------------------------------| PLOTS |----------------------------------------------------
% 1. Plot the THETA coefficients, naming each line the way you asked
% PLEASE CHOOSE THE MODEL NUMBER YOU WANT TO PLOT (1 to K):
MODEL_NO = 1;
% NOW YOU DO NOT HAVE TO DO ANYTHING ELSE, JUST RUN THIS CODE IN THE
% COMMAND WINDOW
theta_plotted = theta_update{MODEL_NO,1}';
% Create figure
figure1 = figure('PaperSize',[20 30],'Color',[1 1 0]);
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on');
hold all;
for ii=1:size(theta_plotted,2)
    hh ='\theta_1';
    hg = strrep(hh, '1', num2str(ii));
    plot(yearlab,theta_plotted(:,ii),'Parent',axes1,'LineWidth',2,'DisplayName',hg)
end
title({'\theta parameters for the full model'},'FontSize',14);
legend1 = legend(axes1,'show');
set(legend1,'Orientation','horizontal','FontSize',14);
hold off;


% 2. Make plots of the time-varying probability of inclusion of each variable
% First choose the number of the variable which you want to use
index_variable = 4;
g_index=[];
for ii=1:K
    ddd = sum(index{ii,1}==index_variable);
    if ddd==1
        g_index = [g_index ; ii]; %#ok<*AGROW>
    end
end
figure2 = figure('PaperSize',[20 30],'Color',[1 1 0]);
axes2 = axes('Parent',figure2,'YGrid','on','XGrid','on');
prob_variable = sum(squeeze(prob_update(:,:,g_index))'); %#ok<*UDIM>
plot(yearlab,prob_variable,'Parent',axes2,'LineWidth',2,'DisplayName','\pi_{t}')
title({['Time-varying probability of inclusion of variable ' cell2mat(Xnames(index_variable))]},'FontSize',14);
legend2 = legend(axes2,'show');
set(legend2,'Orientation','horizontal','FontSize',14);
