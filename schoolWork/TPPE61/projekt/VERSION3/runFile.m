%% Get data and Kalman Filter
clear
[inData, outData, evaluationData] = splitData();
[rKin, pKin] = kalmanFilter(inData);

%% Get params for the Copula
[xOpt, ~, ~] = mlEWMAandGARCH(rKin, rKin, 2);

dt = 1/252;
xiIn = zeros(size(rKin));

for i=1:size(rKin,2)
    vIn = varGARCH(xOpt(:,i),rKin(:,i),dt);
    xiIn(:,i) = (rKin(:,i)-xOpt(1,i)*dt)./(sqrt(vIn(1:end-1))*sqrt(dt));
end

range = 1:3000; % Rank deficient when using full data
inU = tpdf(xiIn(range,:), xOpt(end));
[rhoStudT, df]  = copulafit('t', inU, 'Method', 'ApproximateML');

%% Generate scenarios
nDates = size(evaluationData,1);
nAssets = size(evaluationData,2);
dates = [1:nDates];
prices = evaluationData;

runSP;
