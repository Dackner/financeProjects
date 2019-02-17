%% Get data and Kalman Filter
clear
close all

[inData, outData, evaluationData] = splitData();
[rKin, pKin] = kalmanFilter(inData);

%%

data = [inData; outData; evaluationData];
simLength = size(evaluationData,1);
nSamples = 5000;      % Number of scenarios in Monte-Carlo
isValidation = false;
estPeriod = 2; %yrs
transCost = 0.001;             % Transaction cost that is paid
transCostSP = transCost*.1;   % Transaction cost used in the simulation
dt = 1/252;
t = 80/252;           % Time for Monte-Carlo simulations
tradeFreq = 80;        % Time between trades in days
interestRate = 0.01;
borrowing = false;
shorting = false;

if ~exist('XOPT.mat', 'file') 
   preRun(data, simLength, estPeriod);
else
   load XOPT;
   load Variance;
   load Df;
   load Corr;
   simLength = length(XOPT);
end

runSP(data, simLength, nSamples, isValidation, estPeriod, Corr, Variance, ...
    XOPT, Df, transCost, transCostSP, dt, t, interestRate, borrowing,...
    shorting, tradeFreq);
