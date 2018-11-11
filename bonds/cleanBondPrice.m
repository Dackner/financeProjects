function Bc = cleanBondPrice(N, k, m, y, n, Tp)

%CLEANBONDPRICE Returns the clean price of the bond

Bd = dirtyBondPrice(N, k, m, y, n, Tp);
Bc = Bd - (1-Tp)*k*N/m;

end

