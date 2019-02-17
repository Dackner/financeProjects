function Pd = dirtyBondPrice(N, k, m, y, n, Tp)

%DIRTYBONDPRICE Returns dirty quoted price of bond.

i = 1:n;
Pd = sum(k*(1/m)*N*ones(1, n)./((1+y/m).^(i+Tp-1))) + N/((1+y/m)^(n+Tp-1));

end

