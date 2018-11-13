function Tp = accruedTimeNum(ts, tc, m)

%ACCRUEDTIME Returns accrued time Tp.

Tp = m.*(tc-ts)./365;

end

