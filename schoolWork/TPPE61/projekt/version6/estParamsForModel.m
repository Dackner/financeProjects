function [rhoStudT, df, sigma, xOpt] = estParamsForModel(dates, returns, dt, curDate, estPeriod)

% returns måste vara filtrerad!!!!!!!!
[activeReturns] = determineActiveReturns(dates, returns, dt, curDate, estPeriod);
%m = size(activeReturns,1);
tic
[xOpt, ~, ~] = mlEWMAandGARCH(activeReturns, activeReturns, 2);
toc
xi = zeros(size(activeReturns));

for i=1:size(activeReturns,2)
    v = varGARCH(xOpt(:,i),activeReturns(:,i),dt);
    xi(:,i) = (activeReturns(:,i)-xOpt(1,i)*dt)./(sqrt(v(1:end-1))*sqrt(dt));
end

DF = repmat(xOpt(end, 1:end), size(xi,1) ,1);
U     = tcdf(xi, DF);
[rhoStudT, df]  = copulafit('t', U, 'Method', 'ApproximateML');

covar = cov(activeReturns); % Initialize

for i = 1:size(activeReturns,1)
  covar = xOpt(2) + xOpt(3)*covar + xOpt(4)*activeReturns(i,:)'*activeReturns(i,:)/dt;
end

sigma = sqrt((1/dt)*diag(covar)');

end

