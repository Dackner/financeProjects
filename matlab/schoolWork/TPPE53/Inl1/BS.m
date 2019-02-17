function [C, delta] = BS(T,vol,S,K,r)
    d1 = (log(S/K) + (r+0.5*vol^2)*T)/(vol*sqrt(T));
    d2 = d1 - vol*sqrt(T);
    C = S*normcdf(d1) - normcdf(d2)*K*exp(-r*T);
    delta = normcdf(d1);
end

