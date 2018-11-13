function returns = genScenariosRegular(nu, sigma, corr, t, nSamples)

% 

nAssets = length(nu);

C = chol(corr);

xi = (C' * randn(nAssets, nSamples))';

returns = exp(repmat(nu * t, nSamples, 1) + ...
	      repmat(sigma * sqrt(t), nSamples, 1) .* xi);
