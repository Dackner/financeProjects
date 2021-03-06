function [CTree, PTree] = binomialAssetOrNothingEU(STree, K, r, dt, q)

%BINOMIALASSETORNOTHING Returns a binomial tree of call and put
%Asset-Or-Nothing (european) options

CTree = zeros(size(STree));
PTree = CTree;

%Call option payoff at maturity
CTree(1:end, end) = STree(1:end, end).*( STree(1:end, end) >= K );

%Put option payoff at maturity
PTree(1:end, end) = STree(1:end, end).*( STree(1:end, end) <= K );

%Traverse
for i = 2:length(STree)
    
    CTree(1:end-i+1, end-i+1) = exp( -r*dt )*( q*CTree(1:end-i+1, end-i+2) + (1-q)*CTree(2:end-i+2, end-i+2) );
    PTree(1:end-i+1, end-i+1) = exp( -r*dt )*( q*PTree(1:end-i+1, end-i+2) + (1-q)*PTree(2:end-i+2, end-i+2) );
    
end

end

