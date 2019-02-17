%% read data
clearvars
clc
[num, txt, raw] = xlsread('data.xlsx', 'SNAP');
disp('Data loaded.')
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
yBid            = cell2mat(raw(2:99,10))/100;
yAsk            = cell2mat(raw(2:99,11))/100;
coupon          = cell2mat(raw(2:99,12))/100;
couponFreq      = raw(2:99,14);
modDuration     = cell2mat(raw(2:99,15));
convexity       = cell2mat(raw(2:99,16));
currency        = raw(2:99,17);
dayCountRef     = raw(2:99,18);

% calculate parameters
couponFreq          = couponFreqNum(couponFreq);
remainingCoupons    = remainingCouponsNum(settleDate, maturityDate, couponFreq);
accruedTime         = accruedTimeNum(settleDate, nextCouponDate, couponFreq, dayCountRef); %%settle or quote?

n = length(ric);

disp('Parameters set.');
%%
P = zeros(n,1);
for i = 1:n
    P(i) = cleanBondPrice(faceValue, coupon(i), couponFreq(i), yBid(i), remainingCoupons(i), accruedTime(i));
end
disp('Priced.');
%%
YTM = zeros(n,1);
Pdirty = zeros(n,1);
for i = 1:n
   Pdirty(i) = cleanToDirty(Pbid(i), faceValue, coupon(i), couponFreq(i), accruedTime(i));
   YTM(i) = yieldToMaturity(faceValue, coupon(i), couponFreq(i), remainingCoupons(i),accruedTime(i), Pdirty(i));
end
disp('Quoted YTM');
%%

%TODO: 
%Convexity
