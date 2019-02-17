function Tp = accruedTimeNum(ts, tc, m, dcc)

%ACCRUEDTIME Returns accrued time Tp.

Tp      = zeros(size(m));
for i = 1:length(Tp)
    if dcc{i} == '30E/360         '
        Tp(i) = 1;
    elseif dcc{i} == 'Act/360         '
        Tp(i) = 2;
    elseif dcc{i} == 'Act/Act         '
        Tp(i) = 3;
    else %Act/365
        Tp(i) = 4;
    end
end

ind1    = (Tp==1);   %30E/360
ind2    = (Tp==2);   %Act/360  
ind3    = (Tp==3);   %Act/Act
ind4    = (Tp==4);   %Act/365

%30E/360
dm = month(tc) - month(ts); ind = (dm<0); dm(ind) = dm(ind) + 12;
dd = day(tc) - day(ts);
Tp(ind1) = m(ind1).*( 30*dm(ind1) + dd(ind1) )./360;
clearvars dm dd ind;

%Act/360
Tp(ind2) = m(ind2).*( tc(ind2) - ts(ind2) )./360;

%Act/365 and Act/Act (approx)
Tp(ind3) = m(ind3).*( tc(ind3) - ts(ind3) )./365;
Tp(ind4) = m(ind4).*( tc(ind4) - ts(ind4) )./365;

%Coupon paid before settle date...
negInd      = (Tp < 0);
Tp(negInd)  = 1;

end

