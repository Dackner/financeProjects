%Input: Optimal return, Equally weighted return and riskfree rate
%Output: Beta

function [beta] = jensensalpha(optR,ewR, rf)

%regression
[fun, error] = fit(ewR-rf, optR, 'poly1');
coeff = coeffvalues(fun);
beta = coeff(1);

end
