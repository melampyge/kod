clear;

% 1 minute data on GLD-USO
load('inputData_ETF', 'tday', 'syms', 'cl');
idxG=find(strcmp('GLD', syms));
idxU=find(strcmp('USO', syms));

x=cl(:, idxG);
y=cl(:, idxU);

lookback=20; % Lookback set arbitrarily short
hedgeRatio=NaN(size(x, 1), 1);
for t=lookback:size(hedgeRatio, 1)
    tmp1 = [x(t-lookback+1:t) ones(lookback, 1)]
    yy = y(t-lookback+1:t)
    regression_result=ols(yy, tmp1);
    hedgeRatio(t)=regression_result.beta(1);
    disp(hedgeRatio(t));
end

