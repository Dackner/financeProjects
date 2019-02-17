function [C, P, d1, d2] = BSMPlainVanilla(T, vol, S, K, r, div)

%BSMPLAINVANILLA Returns value of call and put plain vanilla options.
%Assuming continuous dividend yield.

    d1  = (log( S/K ) + (r - div + 0.5*vol^2)*T)/(vol*sqrt( T ));
    d2  = d1 - vol*sqrt( T );
    C   = S*exp( -div*T )*normcdf( d1 ) - K*exp( -r*T )*normcdf( d2 );
    P   = K*exp(-r*T)*normcdf(-d2) - S*exp( -div*T )*normcdf(-d1);
    
end

