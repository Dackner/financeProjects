function [C, P, d1, d2] = BSMCashOrNothing(T, vol, S, K, r, div)

%BSMPLAINVANILLA Returns value of call and put Cash-Or-Nothing (eupropean)
%options. Assuming continous dividend yield. Nominal payout of 1 [currency of underlying] per option.

    d1  = (log( S/K ) + (r - div + 0.5*vol^2)*T)/(vol*sqrt( T ));
    d2  = d1 - vol*sqrt( T );
    C   = exp( -r*T )*normcdf( d2 );
    P   = exp( -r*T )*normcdf( -d2 );
    
end

