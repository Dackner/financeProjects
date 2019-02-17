function [l]=likelihoodNormal(x,r,dt,varianceFunction)
% Computes the log likelihood value for each realization of a normally distributed variable

nu = x(1);
v = varianceFunction(x,r,dt);
v = v(1:end-1); %don't use v(T);

l = -0.5*(log(2*pi*v*dt) + ((r-nu*dt).^2)./(v*dt));

