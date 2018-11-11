%% data
clc

N = 100;
k = 0.08;
m = 2;
y = 0.06;
T = 5;    %dummy variable
n = m*T;

tradeDate       = datenum("2018-11-01");
maturityDate    = datenum("2028-05-09");
lastPaymentDate = datenum("2018-10-01");
nextPaymentDate = datenum("2019-04-01");

Tp = (nextPaymentDate - tradeDate)/(nextPaymentDate - lastPaymentDate); %act/X
%%
Pd = dirtyBondPrice(N, k, m, y, n, Tp);
Pc = cleanBondPrice(N, k, m, y, n, Tp);

[D, Dm, C] = bondDurationConvexity(N, k, m, y, n, Tp);


y_opt = yieldToMaturity(N, k, m, n, Tp, Pd);

%TODO: 
%Convexity
