
%Load data

nLastDates = 1000; 
wealth = 1; % Initial wealth

initialHolding = zeros(1, nAssets + 1);
initialHolding(1, nAssets + 1) = 1; % Only cash

transCost = 0.001;             % Transaction cost that is paid
transCostSP = transCost*3.0;   % Transaction cost used in the simulation

tSim = 1/252;
t = 1/252;           % Time for Monte-Carlo simulations
nSamples = 100;      % Number of scenarios in Monte-Carlo
interestRate = 0.02;
borrowing = false;
shorting = false;


estPeriodVol = 1;    % Period in years
estPeriodMu = 10;

wealthHistory = zeros(1, nLastDates+1);
dateHistory = zeros(1, nLastDates+1);
transCostHistory = zeros(1, nLastDates);
i = 1;
kalmanRollinWindow = kalmanFilter(evaluationData);

for iDate = nDates-nLastDates:nDates-1

  curDate = dates(iDate);

  wealthHistory(i) = wealth;
  dateHistory(i) = curDate;
  
%   [sigma, corr] = estVolGarch(rKin, dt, xOpt);
    [rhoStudT, df, sigma, xOpt] = estParamsForModel()

  scenarioReturns = antitheticSampling('t', rhoStudT, xOpt(1,:), sigma, xOpt(5,:), dt, nSamples, df);
  scenarioPrices = logRetToPricesForSP(inData(curDate,:),scenarioReturns);
  
  buySell = logOptimizePortfolio(scenarioPrices,initialHolding, transCostSP, t, interestRate,borrowing, shorting, nSamples);

  newHolding = initialHolding;
  newHolding(1:nAssets) = newHolding(1:nAssets) + buySell;
  newHolding(nAssets+1) = newHolding(nAssets+1) - sum(buySell) - ...
      transCost*sum(abs(buySell));
  holdingHistory(curDate,:) = newHolding;
  transCostHistory(i) = transCost*wealth*sum(abs(buySell));
    
  curReturn = prices(iDate+1, :) ./ prices(iDate, :);
  newHolding(1:nAssets) = newHolding(1:nAssets) .* curReturn;
  newHolding(nAssets+1) = newHolding(nAssets+1) * exp(interestRate * tSim);
  
  wealth = wealth * sum(newHolding);
  initialHolding = newHolding / sum(newHolding);
  i = i + 1;

end
figure
plot(holdingHistory)

logPortAndEqualPort;

returnHistory = log(wealthHistory(2:end)./wealthHistory(1:end-1));
returnHistoryIndex = log(wealthHistoryIndex(2:end)./wealthHistoryIndex(1:end-1));
[coeff,coeffCI] = regress(returnHistory,[ones(size(returnHistory,2),1),(returnHistoryIndex'-interestRate)]);


alphaJ = returnHistory'-coeffCI(2)*(returnHistoryIndex'-interestRate)-interestRate

f = returnHistory - returnHistoryIndex;
f_ = mean(f);
s2 = var(f);
s = sqrt(s2/nDates);
TS = f_/s;


C = corr.*(sigma*sigma');
w = ones(nAssets,1)/nAssets;
mu = xOpt(1,:)-sigma.^2/2;
beta = C*w/(w'*C*w);
rf = exp(interestRate*dt)-1;
excessReturn = rf + beta' .* (mu-rf);
