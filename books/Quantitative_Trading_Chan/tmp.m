% 
% written by:
% Ernest Chan
%
% Author of “Quantitative Trading: 
% How to Start Your Own Algorithmic Trading Business”
%
% ernest@epchan.com
% www.epchan.com

clear; % make sure previously defined variables are erased.

[num, txt]=xlsread('GLD'); % read a spreadsheet named "GLD.xls" into MATLAB. 

tday1=txt(2:end, 1); % the first column (starting from the second row) is the trading days in format mm/dd/yyyy.

disp(tday1);

tday1=datestr(datenum(tday1, 'mm/dd/yyyy'), 'yyyymmdd'); % convert the format into yyyymmdd.

tday1=str2double(cellstr(tday1)); % convert the date strings first into cell arrays and then into numeric format.

adjcls1=num(:, end); % the last column contains the adjusted close prices.

[num, txt]=xlsread('GDX'); % read a spreadsheet named "GDX.xls" into MATLAB. 

tday2=txt(2:end, 1); % the first column (starting from the second row) is the trading days in format mm/dd/yyyy.

tday2=datestr(datenum(tday2, 'mm/dd/yyyy'), 'yyyymmdd'); % convert the format into yyyymmdd.

tday2=str2double(cellstr(tday2)); % convert the date strings first into cell arrays and then into numeric format.

adjcls2=num(:, end); % the last column contains the adjusted close prices.

[tday, idx1, idx2]=intersect(tday1, tday2); % find the intersection of the two data sets, and sort them in ascending order

cl1=adjcls1(idx1); 

cl2=adjcls2(idx2);  

trainset=1:252; % define indices for training set

% determines the hedge ratio on the trainset
disp(cl1(trainset));
