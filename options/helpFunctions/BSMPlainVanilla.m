function [C, P, d1, d2] = BSMPlainVanilla(T,vol,S,K,r)

%BSMPLAINVANILLA Returns value of call and put plain vanilla options.

    d1 = (log(S/K) + (r+0.5*vol^2)*T)/(vol*sqrt(T));
    d2 = d1 - vol*sqrt(T);
    C = S*normcdf(d1) - normcdf(d2)*K*exp(-r*T);
    P = normcdf(-d2)*K*exp(-r*T) - S*normcdf(-d1);
    
end

