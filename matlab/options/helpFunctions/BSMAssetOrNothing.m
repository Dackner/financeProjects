function [C, P, d1, d2] = BSMAssetOrNothing(T, vol, S, K, r, div)

%BSMPLAINVANILLA Returns value of call and put Asset-Or-Nothing (eupropean)
%options. Assuming countiuous dividend yield.

    d1  = (log(S/K) + (r - div + 0.5*vol^2)*T)/(vol*sqrt(T));
    d2  = d1 - vol*sqrt( T );
    C   = S*exp( -div*T )*normcdf( d1 );
    P   = S*exp( -div*T )*normcdf( -d1 );
    
end

