function S = GBM(t, N, S0, mu, sigma, dt, Z)
S = S0*exp((mu - 0.5*sigma^2).*repmat((1:1:t/dt)', [1,N])*dt + sigma*sqrt(dt).*cumsum(Z));
end