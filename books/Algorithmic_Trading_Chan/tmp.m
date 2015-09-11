clear;

load('inputDataOHLCDaily_20120511', 'syms', 'tday', 'cl');

% load('//dellquad/Futures_data/inputDataOHLCDaily_20120815', 'syms', 'tday', 'cl');
idx=strmatch('TU', syms, 'exact');
tday=tday(:, idx);
cl=cl(:, idx);

lookback=250;
holddays=25;

longs=cl > backshift(lookback, cl)  ;
shorts=cl < backshift(lookback, cl) ;

pos=zeros(length(cl), 1);

for h=0:holddays-1
    long_lag=backshift(h, longs);
    long_lag(isnan(long_lag))=false;
    long_lag=logical(long_lag);
    
    short_lag=backshift(h, shorts);
    short_lag(isnan(short_lag))=false;
    short_lag=logical(short_lag);
    
    pos(long_lag)=pos(long_lag)+1;
    pos(short_lag)=pos(short_lag)-1;
end

ret=(backshift(1, pos).*(cl-backshift(1, cl))./backshift(1, cl))/holddays;

ret(isnan(ret))=0;
% idx=find(tday==20090102);
idx=1;

cumret=cumprod(1+ret(idx:end))-1;

fprintf(1, 'Avg Ann Ret=%7.4f Ann Volatility=%7.4f Sharpe ratio=%4.2f \n',252*smartmean(ret(idx:end)), sqrt(252)*smartstd(ret(idx:end)), sqrt(252)*smartmean(ret(idx:end))/smartstd(ret(idx:end)));
fprintf(1, 'APR=%10.4f\n', prod(1+ret(idx:end)).^(252/length(ret(idx:end)))-1);
[maxDD maxDDD]=calculateMaxDD(cumret);
fprintf(1, 'Max DD =%f Max DDD in days=%i\n\n', maxDD, round(maxDDD));
fprintf(1, 'Kelly f=%f\n', mean(ret(idx:end))/std(ret(idx:end))^2);

