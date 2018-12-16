function[buySell]=logOptimizePortfolio(scenarioPrices, initialHolding, transCost,t,interestRate,borrowing,shorting, nSamples)				     
objGamma = 0;
[B, b, xl, xu, E, el, eu] = buildMatlabModel(transCost, t, interestRate, scenarioPrices, initialHolding, borrowing, shorting);
prob = ones(nSamples, 1) / nSamples;
[buySell,f] = primalDual2StageSimple(prob, B, b, xl, xu, E, el, eu, objGamma);
buySell = buySell';
if (transCost ~= 0)
    n = length(initialHolding)-1;
    buySell = buySell(1:n) - buySell(n+1:2*n);
end