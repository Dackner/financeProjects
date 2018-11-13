function returns = genScenariosLatin(nu, sigma, corr, t, nSamples)

% 

nAssets = length(nu);

xi = lhsnorm(zeros(nAssets,1), corr, nSamples);

returns = exp(repmat(nu * t, nSamples, 1) + ...
	      repmat(sigma * sqrt(t), nSamples, 1) .* xi);
