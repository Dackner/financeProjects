clc
if (~exist('data')) % Only load data once
    [data,txt] = xlsread('labML', 'assetHistory');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input data statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S = data(end:-1:1,1);
dates = datenum(txt(end:-1:3,1));
figure(1);
plot(dates, S);
datetick('x','yyyy')     % Change x-axis to dates

dt=1/252; % parameters on yearly basis

r = log(S(2:end)./S(1:end-1));
rs = (r-mean(r))/std(r);

figure(2);
plot(sort(rs),((1:length(rs))-0.5)/length(rs), '.');
title('CDF of standardized logarithmic returns');

figure(3);
qqplot(rs);
title('QQ plot of standardized logarithmic returns');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GARCH model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[xOpt, ll] = mlGARCH(r,dt);

logLikelihood = sum(ll);

nu     = xOpt(1);
beta0  = xOpt(2);
beta1  = xOpt(3);
beta2  = xOpt(4);
v = varGARCH(xOpt,r,dt);
xi = (r-nu*dt)./(sqrt(v(1:end-1))*sqrt(dt));

figure(4);
qqplot(xi);
title('QQ plot GARCH(1,1) normalized logarithmic returns');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercise
% Determine for both historical data and implied from GARCH the average return and the volatility:
% avgReturnHist, volHist, avgReturnImplied and volImplied
% Determine AIC and BIC for GARCH: AIC and BIC

avgReturnHist = mean(r)/dt;
volHist = sqrt(var(r)/dt);
avgReturnImplied = nu;
volImplied  = sqrt(beta0/(1-beta1-beta2));

k = size(xOpt,1);
T = size(v,1);
AIC = 2*k - 2*logLikelihood;
BIC = k*log(T) - 2*logLikelihood;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('%40s = %f%%\n', 'Average historical logarithmic return', avgReturnHist*100);
fprintf('%40s = %f%%\n', 'Estimated historical logarithmic return', avgReturnImplied*100);

fprintf('%40s = %f%%\n', 'Average historical volatility', volHist*100);
fprintf('%40s = %f%%\n', 'Estimated long run volatility', volImplied*100);

fprintf('%40s %f \n', 'Log likelihood', logLikelihood);
fprintf('%40s %f \n', 'AIC', AIC);
fprintf('%40s %f \n', 'BIC', BIC);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified GARCH model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[xOptMod, llMod] = mlModGARCH(r,dt);

logLikelihoodMod = sum(llMod);

nuMod = xOptMod(1);
beta0Mod  = xOptMod(2);
beta1Mod  = xOptMod(3);
beta2Mod  = xOptMod(4);
alpha0Mod = xOptMod(5);
alpha1Mod = xOptMod(6);

v = varModGARCH(xOptMod,r,dt);
xi = (r-nu*dt)./(sqrt(v(1:end-1))*sqrt(dt));

figure(5);
qqplot(xi);
title('QQ plot GARCH(1,1) mod normalized logarithmic returns');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercise
% Determine AIC and BIC for modGARCH: AICMod and BICMod

k = size(xOptMod,1);
T = size(v,1);
AICMod = 2*k - 2*logLikelihoodMod;
BICMod = k*log(T) - 2*logLikelihoodMod;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('%40s %f \n', 'Log likelihood', logLikelihoodMod);
fprintf('%40s %f \n', 'AIC', AICMod);
fprintf('%40s %f \n', 'BIC', BICMod);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Split data (in-sample and out-of-sample)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nHalf = round(length(r)/2);
rIn = r(1:nHalf);
rOut = r(nHalf+1:end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercise
% For both GARCH and modGARCH determine:
% In-sample log likelihood, AIC and BIC: logLikelihoodIn, logLikelihoodModIn, AICIn, AICModIn, BICIn, BICModIn
% Out-of-sample log likelihood, AIC and BIC: logLikelihoodOut, logLikelihoodModOut
% Test statistic: testStatistic

%GARCH

    %insample

[xOptIn, llIn] = mlGARCH(rIn,dt);
logLikelihoodIn = sum(llIn);
v = varGARCH(xOptIn,rIn,dt);

k = size(xOptIn,1);
T = size(v,1);
AICIn = 2*k - 2*logLikelihoodIn;
BICIn = k*log(T) - 2*logLikelihoodIn;

    %outofsample

[xOptOut, llOut] = mlGARCH(rOut,dt);
logLikelihoodOut = sum(llOut);
v = varGARCH(xOptOut,rOut,dt);

k = size(xOptOut,1);
T = size(v,1);
AICOut = 2*k - 2*logLikelihoodOut;
BICOut = k*log(T) - 2*logLikelihoodOut;

%mod GARCH

    %insample

[xOptModIn, llModIn] = mlModGARCH(rIn,dt);
logLikelihoodModIn = sum(llModIn);
v = varGARCH(xOptModIn,rIn,dt);

k = size(xOptModIn,1);
T = size(v,1);
AICModIn = 2*k - 2*logLikelihoodModIn;
BICModIn = k*log(T) - 2*logLikelihoodModIn;

    %outofsample

[xOptModOut, llModOut] = mlModGARCH(rOut,dt);
logLikelihoodModOut = sum(llModOut);
v = varGARCH(xOptModOut,rOut,dt);

k = size(xOptModOut,1);
T = size(v,1);
AICModOut = 2*k - 2*logLikelihoodModOut;
BICModOut = k*log(T) - 2*logLikelihoodModOut;

%teststatistik

d_ = llModOut - llOut;
d = mean(d_);
T = size(d_,1);
s = sqrt((1/(T-1))*sum((d_ - d).^2))/sqrt(T);

testStatistic = d/s;
normcdf(testStatistic);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convexity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m = 8; % Test different starting solutions
n = length(xOptMod);
xAll = zeros(m,n);
fAll = zeros(m,1);

rng('default'); % Initialize random number generator
for i=1:m
    x1 = rand(n,1);
    [xAll(i,:), llTmp] = mlModGARCH(r,dt,x1);
    fAll(i) = sum(llTmp);
end
fprintf('%15s', 'Log likelihood');
fprintf('%12s', 'nu'); fprintf('%12s', 'beta0'); fprintf('%12s', 'beta1'); fprintf('%12s', 'beta2');
fprintf('%12s', 'alpha0'); fprintf('%12s\n', 'alpha0');
for i=1:m
    fprintf('%15f', fAll(i));
    for j=1:n
        fprintf('%12f', xAll(i,j));
    end
    fprintf('\n');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Summarize results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fprintf('\n');
fprintf('%25s %20s %20s\n', 'Properties', 'Average return', 'Volatility')
fprintf('%25s %20f %20f\n', 'Historical', avgReturnHist, volHist);
fprintf('%25s %20f %20f\n\n', 'Implied from GARCH(1,1)', avgReturnImplied, volImplied);

fprintf('%30s %20s %20s\n', 'Evaluation', 'GARCH', 'mod GARCH')
fprintf('%30s %20f %20f\n', 'nu', xOpt(1), xOptMod(1));
fprintf('%30s %20f %20f\n', 'beta0', xOpt(2), xOptMod(2));
fprintf('%30s %20f %20f\n', 'beta1', xOpt(3), xOptMod(3));
fprintf('%30s %20f %20f\n', 'beta2', xOpt(4), xOptMod(4));
fprintf('%30s %20s %20f\n', 'alpha1', 'N.A.', xOptMod(5));
fprintf('%30s %20s %20f\n\n', 'alpha2', 'N.A.', xOptMod(6));

fprintf('%30s %20s %20s\n', 'Evaluation', 'GARCH', 'mod GARCH')
fprintf('%30s %20f %20f\n', 'Log likelihood', logLikelihood, logLikelihoodMod);
fprintf('%30s %20f %20f\n', 'AIC', AIC, AICMod);
fprintf('%30s %20f %20f\n', 'BIC', BIC, BICMod);
fprintf('%30s %20f %20f\n', 'In-sample log likelihood', logLikelihoodIn, logLikelihoodModIn);
fprintf('%30s %20f %20f\n', 'In-sample AIC', AICIn, AICModIn);
fprintf('%30s %20f %20f\n', 'In-sample BIC', BICIn, BICModIn);
fprintf('%30s %20f %20f\n', 'Out-of-sample log likelihood', logLikelihoodOut, logLikelihoodModOut);

fprintf('\n');
fprintf('%30s %20f %20f\n', 'Test statistic', testStatistic, normcdf(testStatistic));

