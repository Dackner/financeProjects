function [S1, S2] = generateGBMRegular(S0, sigma, dt, T, r, Nsim)

%GENERATEGBMREGULAR Returns geometric brownian motion trajectories for using
%Antithetic Sampling.

n       = floor( T/dt );
xi      = norminv(rand(Nsim, n));
dt      = dt*ones(Nsim, n);
lnS0    = log( S0 )*ones(Nsim, n);

lnS1     = lnS0 + cumsum( (r-0.5*sigma^2).*dt + sigma.*sqrt( dt ).*xi, 2);
lnS2     = lnS0 + cumsum( (r-0.5*sigma^2).*dt - sigma.*sqrt( dt ).*xi, 2);
S1       = exp(lnS1);
S2       = exp(lnS2);

%TODO: Is this correct?
end