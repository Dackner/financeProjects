function [] = runSP(prices, simLength)
%
%

% Load data
nDates = size(prices,1);
nAssets = size(prices,2);
dates = [1:nDates];
wealth = 1; % Initial wealth

initialHolding = zeros(1, nAssets + 1);
initialHolding(1, nAssets + 1) = 1; % Only cash

transCost = 0.001;             % Transaction cost that is paid
transCostSP = transCost*1;   % Transaction cost used in the simulation

dt = 1/252;
t = 7/252;           % Time for Monte-Carlo simulations
tUpdate = 1/4;
nSamples = 1000;      % Number of scenarios in Monte-Carlo
interestRate = 0.02;
borrowing = false;
shorting = false;


estPeriodVol = 1;    % Period in years
if length(prices)-simLength-estPeriodVol/dt<1
    error('simLength must be lower than length of price series - 252')
end

% Save history of portfolio performance
wealthHistory = zeros(1, simLength+1);
dateHistory = zeros(1, simLength+1);
transCostHistory = zeros(1, simLength);

% Estimate parameters
[rKal, pKal] = kalmanFilter(prices);
% Counter of simulations
i = 1;

% Kalman filter series




for iDate = nDates-simLength:nDates-1
    
    curDate = dates(iDate);
    dateHistory(i) = curDate;
    wealthHistory(i) = wealth;
    
    if (i==1 || mod(i+6,126)==0)
        
        
        [rhoStudT, df, sigma, xOpt] = estParamsForModel(dates, rKal, dt, curDate, estPeriodVol);
    end
    
    % If weekly, then trade
    if mod(i+6,7)==0
        
        
        
        % Update models
        
        
        
        scenarioReturns = antitheticSampling('t', rhoStudT, xOpt(1,:), sigma, xOpt(5,:), t, nSamples, df);
        
        buySell = logOptimizePortfolio(scenarioReturns, initialHolding, transCostSP, t, interestRate, borrowing, shorting, nSamples);
        
        newHolding = initialHolding;
        newHolding(1:nAssets) = newHolding(1:nAssets) + buySell;
        newHolding(nAssets+1) = newHolding(nAssets+1) - sum(buySell) - ...
            transCost*sum(abs(buySell));
        holdingHistory(curDate,:) = newHolding;
        transCostHistory(i) = transCost*wealth*sum(abs(buySell));
        
    end
    
    curReturn = prices(iDate+1, :) ./ prices(iDate, :);
    newHolding(1:nAssets) = newHolding(1:nAssets) .* curReturn;
    newHolding(nAssets+1) = newHolding(nAssets+1) * exp(interestRate * t);
    
    wealth = wealth * sum(newHolding);
    initialHolding = newHolding / sum(newHolding);
    
    
    i = i + 1;




wealthHistory(i) = wealth;
dateHistory(i) = dates(nDates);

% Use an equally weighted portfolio as "index" (note that no transaction costs are paid)
equalWeights = 1/nAssets*ones(nAssets,1);
returns = log(prices(2:end,:)./prices(1:end-1,:));
wealthHistoryIndex = (exp(cumsum(returns(nDates-simLength-1:nDates-1,:))) * equalWeights)';

wealthHistory(i) = wealth;
dateHistory(i) = dates(nDates);

end

figure(1);
plot(dateHistory, wealthHistory, dateHistory, wealthHistoryIndex);
% datetick('x','yyyy')     % Change x-axis to dates
legend('SP','Equal weighted index', 'Location', 'Best')

figure;
plot(dateHistory(1:end-1), transCostHistory);
datetick('x','yyyy')     % Change x-axis to dates

fprintf('Total transaction cost = %f\n',sum(transCostHistory));



% figure
% plot(holdingHistory)
% 
% logPortAndEqualPort;
% 
returnHistory = log(wealthHistory(2:end)./wealthHistory(1:end-1));
returnHistoryIndex = log(wealthHistoryIndex(2:end)./wealthHistoryIndex(1:end-1));
% [coeff,coeffCI] = regress(returnHistory,[ones(size(returnHistory,2),1),(returnHistoryIndex'-interestRate)]);
% 
% 
% alphaJ = returnHistory'-coeffCI(2)*(returnHistoryIndex'-interestRate)-interestRate
% 
% f = returnHistory - returnHistoryIndex;
% f_ = mean(f);
% s2 = var(f);
% s = sqrt(s2/nDates);
% TS = f_/s;


% 
% 
% C = rhoStudT.*(sigma*sigma');
% w = ones(nAssets,1)/nAssets;
% mu = xOpt(1,:)-sigma.^2/2;
% beta = C*w/(w'*C*w);
% rf = exp(interestRate*dt)-1;
% excessReturn = rf + beta' .* (mu-rf);
% excessReturn = rf + beta' .* (mu-rf);

end
