function [TS, c] = testSignificanceForJensensAlpha(pR, mR, rf)

betap = zeros(floor(length(pR)/7),1);
betam = zeros(floor(length(pR)/7),1);

for j = 1:floor(length(pR)/7)
    [betap(j)] = jensensalpha(pR(7*(j-1)+1:7*j)',mR(7*(j-1)+1:7*j)',rf);
    [betam(j)] = jensensalpha(mR(7*(j-1)+1:7*j)',mR(7*(j-1)+1:7*j)',rf);
end

betap = repmat(betap,1,7);
betam = repmat(betam,1,7);
betap = betap';
betap = betap(:);
betam = betam';
betam = betam(:);

if mod(length(pR)/7,1) ~= 0
        tmp = mod(length(pR)/7,1)*7;
        betap(end-tmp:end+tmp) = betap(end-tmp);
        betam(end-tmp:end+tmp) = betam(end-tmp);
end

alphap = pR'-betap.*(mR'-rf)-rf;
alpham = mR'-betam.*(mR'-rf)-rf;


alpha = 0.05;
f = alphap - alpham;
f_ = mean(f);
s = std(f);
s2 = s/sqrt(length(alphap));
TS = f_/s2;
c = norminv(1 - alpha);


end

