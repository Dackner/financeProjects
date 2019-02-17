% Plottar mot likaviktad portfölj

% Use an equally weighted portfolio as "index" (note that no transaction costs are paid)
equalWeights = 1/nAssets*ones(nAssets,1);
returns = log(prices(2:end,:)./prices(1:end-1,:));
wealthHistoryIndex = (exp(cumsum(returns(nDates-nLastDates-1:nDates-1,:))) * equalWeights)';

wealthHistory(i) = wealth;
dateHistory(i) = dates(nDates);

figure(1);
plot(dateHistory, wealthHistory, dateHistory, wealthHistoryIndex);
datetick('x','yyyy')     % Change x-axis to dates
legend('SP','Equal weighted index', 'Location', 'Best')

figure(2);
plot(dateHistory(1:end-1), transCostHistory);
datetick('x','yyyy')     % Change x-axis to dates

fprintf('Total transaction cost = %f\n',sum(transCostHistory));
