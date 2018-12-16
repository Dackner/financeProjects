%% Get data and Kalman Filter
clear
[inData, outData, evaluationData] = splitData();
[rKin, pKin] = kalmanFilter(inData);
[rKout, pKout] = kalmanFilter(outData);


%% Get parameters for GARCH and EWMA and the likelihood values
% GG = Gaussian GARCH
% TG = student t GARCH
% GE = Gaussian EWMA
% TE = student t EWMA

[xOptGG, outOfSamplelikelihoodGG, llGG] = mlEWMAandGARCH(rKin, rKout, 1);
[xOptTG, outOfSamplelikelihoodTG, llTG] = mlEWMAandGARCH(rKin, rKout, 2); % This model is the best according to tests below.
[xOptGE, outOfSamplelikelihoodGE, llGE] = mlEWMAandGARCH(rKin, rKout, 3);
[xOptTE, outOfSamplelikelihoodTE, llTE] = mlEWMAandGARCH(rKin, rKout, 4);

%% Perform likelihood ratio test to choose best model
% choose alpha as significance level and first input to function
% "univariateLikelihoodRatioTest" is used as reference.

alpha = 0.05;
TS = zeros(3,size(rKin,2));
for i = 1:size(rKin,2)
    [TS(:,i), c] = univariateLikelihoodRatioTest(llTG(:,i), llGG(:,i), llGE(:,i), llTE(:,i), alpha);
end

%% Perform AIC-BIC test to choose best model
testrK = [rKin;rKout];

[paramGG, loglikelihoodGG] = mlEWMAandGARCH(testrK, testrK, 1);
[paramTG, loglikelihoodTG] = mlEWMAandGARCH(testrK, testrK, 2);
[paramGE, loglikelihoodGE] = mlEWMAandGARCH(testrK, testrK, 3);
[paramTE, loglikelihoodTE] = mlEWMAandGARCH(testrK, testrK, 4);

%% Calculate AIC and BIC
T = size(testrK,1);
AIC = zeros(4,size(testrK,2));
BIC = zeros(4,size(testrK,2));

for i = 1:size(rKin,2)
    [AIC(1,i), BIC(1,i)] = AICBIC(loglikelihoodGG(i), size(paramGG,1) - 1, T);
end
for i = 1:size(rKin,2)
    [AIC(2,i), BIC(2,i)] = AICBIC(loglikelihoodTG(i), size(paramTG,1) - 1, T);
end
for i = 1:size(rKin,2)
    [AIC(3,i), BIC(3,i)] = AICBIC(loglikelihoodGE(i), size(paramGE,1) - 1, T);
end
for i = 1:size(rKin,2)
    [AIC(4,i), BIC(4,i)] = AICBIC(loglikelihoodTE(i), size(paramTE,1) - 1, T);
end


%% QQ-plot
dt = 1/252;
xi=zeros(size(rKout));

for i=1:size(rKout,2)
    v = varGARCH(xOptTG(:,i),rKout(:,i),dt);
    xi(:,i) = (rKout(:,i)-xOptTG(1,i)*dt)./(sqrt(v(1:end-1))*sqrt(dt));
    figure(i);
    df = xOptTG(end,i);
    pd = makedist('tLocationScale', 'mu', 0, 'sigma', 1, 'nu', df);
    qqplot(xi(:,i), pd); 
    title(['QQ plot GARCH(1,1) Student T logarithmic returns, asset: ', num2str(i)]);
end

% For QQ-plot
% for i=1:size(rKout,2)
%     v = varEWMA(xOptGE(:,i),rKout(:,i),dt);
%     xi(:,i) = (rKout(:,i)-xOptGE(1,i)*dt)./(sqrt(v(1:end-1))*sqrt(dt));
%     figure(i);
%     qqplot(xi(:,i)); 
%     title(['QQ plot EWMA Gaussian normalized logarithmic returns, asset: ', num2str(i)]);
% end


%% Inference for margins
[TSCopula, cCopula] = inferenceForMargins(rKin, rKout, xOptTG); % Student's t Copula is the best fit for data.



%% Prints

% Loglikelihood print
format = '%20s %20s %20s %20s %20s\n';
format2 = '%20s %20s %20s %20s\n';
fprintf(format,'Loglikelihood', 'Gaussian GARCH', 'Students t GARCH', 'Gaussian EWMA',...
    'Students t EWMA');
for i = 1:size(rKin,2) 
    fprintf('%20s', ['T', num2str(i)]);
    fprintf('%20s %4.2f', outOfSamplelikelihoodGG(i));
    fprintf('%20s %4.2f', outOfSamplelikelihoodTG(i));
    fprintf('%20s %4.2f', outOfSamplelikelihoodGE(i));
    fprintf('%20s %4.2f', outOfSamplelikelihoodTE(i));
    fprintf('\n');
end
fprintf('\n');

% TS
fprintf(format2,' ', 'Gaussian GARCH', 'Gaussian EWMA',...
    'Students t EWMA');
for i = 1:size(rKin,2) 
    fprintf('%20s', ['T', num2str(i)]);
    fprintf('%20s %4.2f', TS(1,i));
    fprintf('%20s %4.2f', TS(2,i));
    fprintf('%20s %4.2f', TS(3,i));
    fprintf('\n');
end
fprintf('\n');


% AIC print
fprintf(format,'AIC', 'Gaussian GARCH', 'Students t GARCH', 'Gaussian EWMA',...
    'Students t EWMA');
for i = 1:size(rKin,2) 
    fprintf('%20s', ['T', num2str(i)]);
    fprintf('%20s %4.2f', AIC(1,i));
    fprintf('%20s %4.2f', AIC(2,i));
    fprintf('%20s %4.2f', AIC(3,i));
    fprintf('%20s %4.2f', AIC(4,i));
    fprintf('\n');
end
fprintf('\n');

% BIC print
fprintf(format,'BIC', 'Gaussian GARCH', 'Students t GARCH', 'Gaussian EWMA',...
    'Students t EWMA');
for i = 1:size(rKin,2) 
    fprintf('%20s', ['T', num2str(i)]);
    fprintf('%20s %4.2f', BIC(1,i));
    fprintf('%20s %4.2f', BIC(2,i));
    fprintf('%20s %4.2f', BIC(3,i));
    fprintf('%20s %4.2f', BIC(4,i));
    fprintf('\n');
end
fprintf('\n');



