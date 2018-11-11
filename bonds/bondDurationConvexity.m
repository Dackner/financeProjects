function [D, Dm, C] = bondDurationConvexity(N, k, m, y, n, Tp)

%DURATION Returns the duration, D, modified duration, Dm, and convexity C

Pd = dirtyBondPrice(N, k, m, y, n, Tp);

i = 1:n;
D = (1/Pd)*(sum(k*N*(1/m)*(i+Tp-1)*(1/m)./((1+y/m).^(i+Tp-1))) + N*(n+Tp-1)*(1/m)/((1+y/m)^(n+Tp-1)));

Dm = D/(1+y/m);

C = 1; %TODO
end

