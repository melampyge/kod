clear;

load('inputDataOHLCDaily_20120511', 'syms', 'tday', 'cl');
% load('//dellquad/Futures_data/inputDataOHLCDaily_20120815', 'syms', 'tday', 'cl');
idx=strmatch('TU', syms, 'exact');

tday=tday(:, idx);
cl=cl(:, idx);

A = [tday cl];
save('/tmp/out','A');
exit;
