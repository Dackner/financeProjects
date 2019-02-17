%% Get data and Kalman Filter
clear
close all


[inData, outData, evaluationData] = splitData();
%[rKin, pKin] = kalmanFilter(inData);

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

%% Backtesting
simLength = 3000; %days
estPeriod = 1; %years
data = [inData; outData; evaluationData];

preRun(data, simLength, estPeriod);
% runSP(evaluationData, simLength);

%% Out of sample data

outOfSample = [outData; evaluationData];

runSP(outOfSample, length(evaluationData));



