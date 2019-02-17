function [wealthHistory, dateHistory, transCostHistory] = runSP(prices, ...
    simLength, nSamples, isValidation, estPeriod, Corr, Variance, XOPT, ...
    Df, transCost, transCostSP, dt, t, interestRate, borrowing, shorting, ...
    tradeFreq)

rng('default')
%set params
nDates = size(prices,1);
nAssets = size(prices,2);
dates = [1:nDates];
wealth = 1; % Initial wealth
estLength = estPeriod*252; %TODO: ta bor kanske

initialHolding = zeros(1, nAssets + 1);
initialHolding(1, nAssets + 1) = 1; % Only cash

% Save history of portfolio performance
wealthHistory = zeros(1, simLength+1);
dateHistory = zeros(1, simLength+1);
transCostHistory = zeros(1, simLength);

if isValidation
    SP.inHolding = initialHolding;
    SP.tCost = transCostSP;
    SP.borrowing = borrowing;
    SP.shorting = shorting;
    SP.rf = interestRate;
    requiredGap = 0.001;
    xOpt = XOPT{1};
    [relDelta, ~, ~] = SP_OptPess('t', Corr{1}, xOpt(1,:), sqrt(Variance(1,:)), xOpt(5,:), t, nSamples, Df(1), SP);
    if relDelta>requiredGap
        error(strcat('SP-solution is not good enough. Increase nSamples. Relative delta is: ', num2str(relDelta)))
    else
        display(strcat('Relative delta is this: ', num2str(relDelta)))
    end
    return;
end

i = 1;

for iDate = nDates-simLength:nDates-1
    
    curDate = dates(iDate);
    dateHistory(i) = curDate;
    wealthHistory(i) = wealth;


        
    xOpt = XOPT{i};
    if mod(i+tradeFreq-1,tradeFreq)==0    
    scenarioReturns = antitheticSampling('t', Corr{i}, xOpt(1,:), sqrt(Variance(i,:)), xOpt(5,:), t, nSamples, Df(i));
    [buySell, ~ ] = logOptimizePortfolio(scenarioReturns, initialHolding, transCostSP, t, interestRate, borrowing, shorting, nSamples);
    else
        buySell = zeros(size(buySell));
    end
    
    newHolding = initialHolding;
    newHolding(1:nAssets) = newHolding(1:nAssets) + buySell;
    newHolding(nAssets+1) = newHolding(nAssets+1) - sum(buySell) - ...
        transCost*sum(abs(buySell));
    holdingHistory(curDate,:) = newHolding;
    transCostHistory(i) = transCost*wealth*sum(abs(buySell));

    
    curReturn = prices(iDate+1, :) ./ prices(iDate, :);
    newHolding(1:nAssets) = newHolding(1:nAssets) .* curReturn;
    newHolding(nAssets+1) = newHolding(nAssets+1) * exp(interestRate * dt);
    
    wealth = wealth * sum(newHolding);
    initialHolding = newHolding / sum(newHolding);

    disp(i)
    i = i + 1;
end

wealthHistory(i) = wealth;
dateHistory(i) = dates(nDates);

% Use an equally weighted portfolio as "index" (note that no transaction costs are paid)
equalWeights = 1/nAssets*ones(nAssets,1);
returns = log(prices(2:end,:)./prices(1:end-1,:));
wealthHistoryIndex = (exp(cumsum(returns(nDates-simLength-1:nDates-1,:))) * equalWeights)';

wealthHistory(i) = wealth;
dateHistory(i) = dates(nDates);

figure(1);
plot(dateHistory, wealthHistory, dateHistory, wealthHistoryIndex);
% datetick('x','yyyy')     % Change x-axis to dates
legend('SP','Equal weighted index', 'Location', 'Best')

figure(2);
plot(dateHistory(1:end-1), transCostHistory);
datetick('x','yyyy')     % Change x-axis to dates

fprintf('Total transaction cost = %f\n',sum(transCostHistory));


returnHistory = log(wealthHistory(2:end)./wealthHistory(1:end-1));
returnHistoryIndex = log(wealthHistoryIndex(2:end)./wealthHistoryIndex(1:end-1));

[TS, c] = testSignificanceForJensensAlpha(returnHistory, returnHistoryIndex, interestRate*dt)


end
