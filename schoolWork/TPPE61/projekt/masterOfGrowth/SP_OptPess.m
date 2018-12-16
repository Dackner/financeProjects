function [relDelta, ubdConf, lbdConf] = SP_OptPess(family, corr, nu, sigma, df, t, nSamples, dfCop, SP)
%OPTPESS Trello: 10 Performs optimistic and pessimistic approximation of
%2-stage stochastic programming problem
%   Detailed explanation goes here


% Number of SP solutions in approximation
Nubd = 1000;
Nlbd = 1000;
n = size(nu,2);
% A SP-solution (wAll) in the original objective is a optimistic solution
wAll = zeros(n, Nubd);
% Optimistic estimates
ubdAll = zeros(Nubd,1);
for i=1:Nubd
    % Scenario generation: Gaussian if no dfCop, else student-t
    if ~exist('dfCop','var')
        [scenarioReturnsInSample] = antitheticSampling(family, corr, nu, sigma, df, t, nSamples);
    else
        [scenarioReturnsInSample] = antitheticSampling(family, corr, nu, sigma, df, t, nSamples, dfCop);
    end
    [wAll(:,i), ubdAll(i)] = logOptimizePortfolio(scenarioReturnsInSample, SP.inHolding, SP.tCost, t, SP.rf, SP.borrowing, SP.shorting, nSamples);
end
% estStatistics(nu, sigma, corr, t, log(scenarioReturnsInSample));

w = mean(wAll,2);
lbdAll = zeros(Nlbd,1);
for i=1:Nlbd
    % Scenario generation: Gaussian if no dfCop, else student-t
    if ~exist('dfCop','var')
        [scenarioReturnsOutOfSample] = antitheticSampling(family, corr, nu, sigma, df, t, nSamples);
    else
        [scenarioReturnsOutOfSample] = antitheticSampling(family, corr, nu, sigma, df, t, nSamples, dfCop);
    end
    R = exp(SP.rf*t);
    W = scenarioReturnsOutOfSample*w+(1-(1+SP.tCost)*sum(w))*R;
    p = 1/nSamples;
    lbdAll(i) = p*sum(log(W));
end


ubdStdErr = std(ubdAll)/sqrt(Nubd);
ubd = mean(ubdAll);

lbdStdErr = std(lbdAll)/sqrt(Nlbd);
lbd = mean(lbdAll);
z = norminv(0.975);
relDelta = (ubd/lbd)-1;

lbdConf = [lbd-z*lbdStdErr, lbd+z*lbdStdErr];
ubdConf = [ubd-z*ubdStdErr, ubd+z*ubdStdErr];
plotLbdUbd(lbd, z*lbdStdErr, ubd, z*ubdStdErr);
legend('','pess','','','opt','');




end

