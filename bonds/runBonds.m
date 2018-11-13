%% read data
clearvars
clc
[num, txt, raw] = xlsread('data.xlsx', 'SNAP');
%% set parameters
clc
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

% calculate parameters
couponFreq          = couponFreqNum(couponFreq);
remainingCoupons    = remainingCouponsNum(quoteDate, maturityDate, couponFreq);
accruedTime         = accruedTimeNum(quoteDate, nextCouponDate, couponFreq); %%settle or quote?

disp('Parameters set.');
%%
n = length(ric);
P = zeros(n,1);
for i = 1:n
    P(i) = dirtyBondPrice(faceValue, coupon(i), couponFreq(i), yAsk(i), remainingCoupons(i), accruedTime(i));
end
%%
% Pd = dirtyBondPrice(N, k, m, y, n, Tp);
k = coupon(1)
n = 1
m = couponFreq(1)
y = yAsk(1)
Tp = (4*30 - 2)/360%accruedTime(1)
PcAsk = cleanBondPrice(faceValue, k, m, y, n, Tp)
Pask(1)
% [D, Dm, C] = bondDurationConvexity(N, k, m, y, n, Tp);


% y_opt = yieldToMaturity(N, k, m, n, Tp, Pd);

%TODO: 
%Convexity
