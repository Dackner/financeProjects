%% read data
clearvars
clc
[num, txt, raw] = xlsread('data.xlsx', 'SNAP');
%% set parameters
faceValue   = 100;
timeError   = 693960;

ric             = raw(2:99,2);
quoteDate       = timeError + cell2mat(raw(2:99,3));
issueDate       = timeError + cell2mat(raw(2:99,5));
settleDate      = timeError + cell2mat(raw(2:99,6));
maturityDate    = timeError + cell2mat(raw(2:99,7));
nextCouponDate  = timeError + cell2mat(raw(2:99,13));
Pbid            = cell2mat(raw(2:99,8));
Pask            = cell2mat(raw(2:99,9));
yAsk            = cell2mat(raw(2:99,10))/100;
yBid            = cell2mat(raw(2:99,11))/100;
coupon          = cell2mat(raw(2:99,12))/100;
couponFreq      = raw(2:99,14);
modDuration     = cell2mat(raw(2:99,15));
convexity       = cell2mat(raw(2:99,16));
currency        = raw(2:99,17);
dayCountRef     = raw(2:99,18);
%% calculate parameters
couponPaymentsPerYear   = couponFreqNum(couponFreq);
accruedTime             = accruedTime(quoteDate, nextCouponDate, couponPaymentsPerYear);
%%

% Pd = dirtyBondPrice(N, k, m, y, n, Tp);
k = coupon(1)
n = 1
m = couponPaymentsPerYear(1)
y = yAsk(1)
Tp = accruedTime(1)
PcAsk = cleanBondPrice(faceValue, k, m, y, n, Tp)

% [D, Dm, C] = bondDurationConvexity(N, k, m, y, n, Tp);


% y_opt = yieldToMaturity(N, k, m, n, Tp, Pd);

%TODO: 
%Convexity
