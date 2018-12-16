function returns = antitheticSampling(family, corr, nu, sigma, df, t, nSamples, dfCop)
%antitheticSampling Trello: 4. Returns scenarios for stochastic optimization
%   Input dfCop if Student T copula. Leave empty to choose Gaussian copula
%   t specifies time for Monte-Carlo simulation. 1/252 to perform daily
%   generation
%   nu is expected return
%   In parameter family = 't' or 'Gaussian' specifies copula
%   corr is correlation of assets
%   df is vector specifying univariate distr. If 0, then Gaussian, otherwise student-t
%   nSamples specifies number of samples. Even numbers required

if (mod(nSamples,2) ~= 0)
    error('Number of scenarios have to be even');
end

% If degrees of freedom are input to the function, perform Student-t
if ~exist('dfCop','var')
    p = copularnd(family, corr, nSamples/2);
else
    p = copularnd(family, corr, dfCop, nSamples/2);
end

% Creating returns based on Copula probability and univariate distribution
xi = zeros(size(p));
for ass=1:size(p,2)
    if df(ass)~=0
        xi(:,ass) = tinv(p(:,ass),df(ass));
    else
        xi(:,ass) = norminv(p(:,ass),nu(ass),sigma(ass));
    end
end

xi = [xi;-xi];

returns = exp(repmat(nu * t, nSamples, 1) + ...
    repmat(sigma * sqrt(t), nSamples, 1) .* xi);
end