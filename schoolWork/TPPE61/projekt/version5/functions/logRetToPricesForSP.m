function [ S ] = logRetToPricesForSP(S0, r)

[N,M] = size(r);
S = zeros(N,M);
S = repmat(S0,N,1).*r;


end

