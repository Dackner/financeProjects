%% read data
clc
[num, txt, raw] = xlsread('data.xlsx', 'SNAP');
%% set parameters
N = 100;
timeError = 693960;

ric = raw(2:99,2);
quoteDate = timeError + cell2mat(raw(2:99,3));
issueDate = timeError + cell2mat(raw(2:99,5));
settleDate = timeError + cell2mat(raw(2:99,6));
maturityDate = timeError + cell2mat(raw(2:99,7));
nextCouponDate = timeError + cell2mat(raw(2:99,13));


k = 0.08;
m = 2;
y = 0.06;
T = 5;    %dummy variable
n = m*T;


lastPaymentDate = datenum("2018-10-01");

Tp = (nextCouponDate - settleDate)/(nextCouponDate - lastPaymentDate); %act/X
%%
Pd = dirtyBondPrice(N, k, m, y, n, Tp);
Pc = cleanBondPrice(N, k, m, y, n, Tp);

[D, Dm, C] = bondDurationConvexity(N, k, m, y, n, Tp);


y_opt = yieldToMaturity(N, k, m, n, Tp, Pd);

%TODO: 
%Convexity
