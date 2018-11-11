function y = yieldToMaturity(N, k, m, n, Tp, Bd)

%YIELDTOMATURITY Returns the yield to maturity of the bond

y0 = 0;
y = fmincon(@(x) abs(dirtyBondPrice(N, k, m, x, n, Tp) - Bd),y0,[],[]);

end

