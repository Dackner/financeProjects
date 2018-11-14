function [callLSMC, callFN, VaRLSMC, VaRFN, Beta] = LSMC_eval(K, S_outerLSMC, S_innerLSMC, S_outerFN, S_innerFN)
% Calculates the price and 99.5% VaR of a Arithmetic Asian call option using both the
% full nested MC and LSMC method. Returns the R-square of the LSMC regression.
% S_outerLSMC, S_innerLSMC and S_outerFN, S_innerFN represent the outer and inner
% simulation of the LSMC and full nested set, respetively.

call = Asian_option(K, S_innerLSMC);
X = S_outerLSMC.^(0:1:3);
Beta = X\(call);
X_FN = S_outerFN.^(0:1:3);

callLSMC = X_FN*Beta;
% estimation of full nested call option
tic
callFN = Asian_option(K, S_innerFN); % Actual full nested call option
toc
VaRFN = -prctile(callFN-mean(callFN),0.5); %VaR full nested call option
VaRLSMC = -prctile(callLSMC-mean(callLSMC),0.5); % LSMC estimation of VaR full nested

figure
hold on
plot(sort(callLSMC),'b.')
plot(sort(callFN),'r.');
legend('callLSMC','callFN');
xlabel('Outer Scenario');
ylabel('Value');
hold off
% call option
ss_res = sum((callFN-callLSMC).^2);
ss_tot = sum((callFN - mean(callFN)).^2);
r2 = 1 - (ss_res / ss_tot)
end