function S = generateGBMRegular(S0, sigma, dt, T, r, Nsim)

%GENERATEGBMREGULAR Returns geometric brownian motion trajectories.

n       = floor( T/dt );
xi      = norminv(rand(Nsim, n));
dt      = dt*ones(Nsim, n);
lnS0    = log( S0 )*ones(Nsim, n);

lnS     = lnS0 + cumsum( (r-0.5*sigma^2).*dt + sigma.*sqrt( dt ).*xi, 2);
S       = exp(lnS);

end

