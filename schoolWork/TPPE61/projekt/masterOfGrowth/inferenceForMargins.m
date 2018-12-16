function [TS, c] = inferenceForMargins(rIn, rOut, xOpt)
dt = 1/252;
xiIn = zeros(size(rIn));
xiOut = zeros(size(rOut));

for i=1:size(rIn,2)
    vIn = varGARCH(xOpt(:,i),rIn(:,i),dt);
    xiIn(:,i) = (rIn(:,i)-xOpt(1,i)*dt)./(sqrt(vIn(1:end-1))*sqrt(dt));
end

for i=1:size(rOut,2)
    vOut = varGARCH(xOpt(:,i),rOut(:,i),dt);
    xiOut(:,i) = (rOut(:,i)-xOpt(1,i)*dt)./(sqrt(vOut(1:end-1))*sqrt(dt));
end

% range = 1:3000; % Rank deficient when using full data
DFin = repmat(xOpt(end, 1:end), size(xiIn,1) ,1);
DFout = repmat(xOpt(end, 1:end), size(xiOut,1) ,1);
inU     = tcdf(xiIn, DFin);
outU    = tcdf(xiOut, DFout);
%% MLE of copulas in-saple
rhoGauss        = copulafit('Gaussian', inU);
[rhoStudT, df]  = copulafit('t', inU, 'Method', 'ApproximateML');
%% Compute likelihoods (this is in-sample)
LGauss = copulapdf('Gaussian', outU, rhoGauss);
LStudT = copulapdf('t', outU, rhoStudT, df);

lGauss = log(LGauss);
lStudT  = log(LStudT);

logLikelihoodGauss = sum(lGauss);
logLikelihoodStudT = sum(lStudT);

%% Likelihood ratio test
alpha = 0.05;
d_ = lStudT - lGauss;
d = mean(d_);
s = sqrt( var(d_)/length(d_) ); 
TS = d/s;
c = norminv(1 - alpha);
end

