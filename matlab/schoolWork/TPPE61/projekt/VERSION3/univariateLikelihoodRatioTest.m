function [TS, c] = univariateLikelihoodRatioTest(h0, h11, h12, h13, alpha)
% Likelihood ratio test - univariate Trello: 3a. Returns TS, test statistic
% and c, the lower bound of the critical region.
%   Input h0 is used as reference for likelihood ratio test
%   h11 h12 h13 are the likelihood values for each model
%   alpha is the significance level

d_1 = h0 - h11;
d_2 = h0 - h12;
d_3 = h0 - h13;

d1 = mean(d_1);
d2 = mean(d_2);
d3 = mean(d_3);

s1 = sqrt( var(d_1)/length(d_1) );
s2 = sqrt( var(d_2)/length(d_2) );
s3 = sqrt( var(d_3)/length(d_3) );

TS = [d1/s1;d2/s2;d3/s3];
c = norminv(1 - alpha);

end

