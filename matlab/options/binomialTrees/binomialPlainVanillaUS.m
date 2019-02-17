function [CTree, PTree] = binomialPlainVanillaUS(STree, K, r, dt, q)

%BINOMIALPLAINVANILLAUS Returns a binomial tree of call and put (american)
%option values given the tree for underlying asset. Assuming no dividend.

CTree = zeros(size(STree));
PTree = CTree;

%Call option payoff at maturity
CTree(1:end, end) = max( STree(1:end, end) - K, 0 );

%Put option payoff at maturity
PTree(1:end, end) = max( K - STree(1:end, end), 0 );

%Traverse
for i = 2:length(STree)
    
    EUValue                     = exp( -r*dt )*( q*CTree(1:end-i+1, end-i+2) + (1-q)*CTree(2:end-i+2, end-i+2) );
    USPayOff                    = max( STree(1:end-i+1, end-i+1) - K, 0 );
    CTree(1:end-i+1, end-i+1)   = max( EUValue, USPayOff );
    
    EUValue                     = exp( -r*dt )*( q*PTree(1:end-i+1, end-i+2) + (1-q)*PTree(2:end-i+2, end-i+2) );
    USPayOff                    = max( K - STree(1:end-i+1, end-i+1), 0 );
    PTree(1:end-i+1, end-i+1)   = max( EUValue, USPayOff );
    
end

end

