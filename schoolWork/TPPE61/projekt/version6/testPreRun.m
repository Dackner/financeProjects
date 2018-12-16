clear
clc
close all


[inData, outData, evaluationData] = splitData();
%[rKin, pKin] = kalmanFilter(inData);

simLength = 12;% size(evaluationData,1); %days
estPeriod = 1; %years
data = [inData; outData; evaluationData];

[Corr, XOPT, Variance, Df] = preRun(data, simLength, estPeriod);
% runSP(evaluationData, simLength);
% save('Corr', 'Corr');
% save('XOPT', 'XOPT');
% save('Variance', 'Variance');
% save('Df', 'Df');