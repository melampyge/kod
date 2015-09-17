clear;

% 1 minute data on USDCAD
load('/home/burak/Dropbox/Public/data/inputData_USDCAD_20120426', 'tday', 'hhmm', 'cl');

% Select the daily close at 16:59 ET.
y=cl(hhmm==1659);

disp(y);

save('/tmp/y','y')

% Variance ratio test from Matlab Econometrics Toolbox
[h,pValue]=vratiotest(log(y))

% Find value of lambda and thus the halflife of mean reversion by linear regression fit
ylag=lag(y, 1);  % lag is a function in the jplv7 (spatial-econometrics.com) package.
deltaY=y-ylag;
deltaY(1)=[]; % Regression functions cannot handle the NaN in the first bar of the time series.
ylag(1)=[];
regress_results=ols(deltaY, [ylag ones(size(ylag))]); % ols is a function in the jplv7 (spatial-econometrics.com) package.
halflife=-log(2)/regress_results.beta(1);

fprintf(1, 'halflife=%f days\n', halflife);
