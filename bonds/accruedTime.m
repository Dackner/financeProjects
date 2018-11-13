function Tp = accruedTime(ts, tc, m)

%ACCRUEDTIME Returns accrued time Tp.

Tp = m.*(tc-ts)./365;

end

