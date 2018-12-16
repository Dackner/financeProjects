function [sigma, corr] = estVolGarch(returns, dt, xOpt, dates, curDate, estPeriod)

[activeReturns] = determineActiveReturns(dates, returns, dt, curDate, estPeriod);
m = size(activeReturns,1);

covar = cov(returns); % Initialize

for i = 1:size(returns,1)
  covar = xOpt(2) + xOpt(3)*covar + xOpt(4)*returns(i,:)'*returns(i,:)/dt;
end
  
sigma = sqrt(diag(covar)');
corr = covar./(sigma'*sigma);

