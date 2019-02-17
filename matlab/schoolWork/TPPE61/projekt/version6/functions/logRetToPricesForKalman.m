function [ S ] = logRetToPrices(S0, r)

[M,N] = size(r);
S = zeros(M,N+1);
S(:,1) = S0';

for t = 2:size(S,2)
    
    tt = t-1;
    S(:,t) = S(:,t-1).*exp(r(:,tt));
    
end



end

