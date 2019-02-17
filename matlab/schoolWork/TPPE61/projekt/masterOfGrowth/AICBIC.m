function [aic, bic] = AICBIC(l, k, T)
% AIC and BIC Trello: 3b. Returns AIC and BIC.
%   Input l is the likelihood value
%   k is the number of parameters
%   T is the number of scenarios

aic = 2*k - 2*l;
bic = k*log(T) - 2*l;

end

