function Pc = cleanBondPrice(N, k, m, y, n, Tp)

%CLEANBONDPRICE Returns the clean price of the bond

Pd = dirtyBondPrice(N, k, m, y, n, Tp);
Pc = Pd - (1-Tp)*k*N/m;

end

