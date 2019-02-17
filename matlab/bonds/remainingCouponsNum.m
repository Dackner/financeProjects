function n = remainingCouponsNum(tQ ,tM, m)

%REMAININGCOUPONS returns the amount of remaining coupon payments.

n = floor( (1/365)*(tM-tQ).*m ) + 1;

end

