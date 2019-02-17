%% Dummy data
clear
n = 2; %takes a long time to do fit stud't with many series.
% U = rand(8000, n);
C = [1 0; 0 1];
inR     = mvnrnd([0;0], C, 8000);
inU     = normpdf(inR);
outR    = mvnrnd([0;0], C, 8000);
outU    = normpdf(outR);
%% MLE of copulas in-saple
rhoGauss        = copulafit('Gaussian', inU);
[rhoStudT, df]  = copulafit('t', inU);
%% Compute likelihoods (this is in-sample)
LGauss = copulapdf('Gaussian', outU, rhoGauss);
LStudT = copulapdf('t', outU, rhoStudT, df);

lGauss = log(LGauss);
lStudT  = log(LStudT);

logLikelihoodGauss = sum(lGauss);
logLikelihoodStudT = sum(lStudT);

%% Likelihood ratio test
d_ = lGauss - lStudT;
d = mean(d_);
s = sqrt( var(d_)/length(d_) ); 
TS = d/s;
alpha = normcdf(TS);

% A = copularnd('t',RHO,NU,N);