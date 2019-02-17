%% Get data from excel
clearvars
clc
data=xlsread("inl2.xlsx", "snap");
%% Uppgift 1
clc
close all
voldata = data(2:11  ,1:2);
Pdata = [data(2:26, 4), data(2:26, 6)];
Rk = data(2, 9)/100;
voldata(1:end,2) = voldata(1:end,2)/100;

delta = 0.5;
flat_sigma = interpolation(voldata, delta);
P = interpolation(Pdata, delta);

f = ((P(1:end-1, 2)./P(2:end, 2)).^(1./(P(2:end, 1)-P(1:end-1, 1)))) - 1;

N = size(flat_sigma, 1);
cap_m = zeros(N, 1);

for i = 1:N
    capl_b = zeros(i, 1);
    for j = 1:i
        capl_b(j) = black_76(1, delta, P(j+1,2), f(j), flat_sigma(i,2), Rk, flat_sigma(j,1));
    end
    cap_m(i) = sum(capl_b);
end

capl_m = zeros(N, 1);
capl_m(1) = cap_m(1);

for i = 2:N
    capl_m(i) = cap_m(i)-cap_m(i-1);
end

forward_sigma = zeros(N,1);
for i = 1:N
    forward_sigma(i) = black_76_iv(capl_m(i), "caplet", 1, delta, P(i+1, 2), f(i), Rk, flat_sigma(i,1));
end
hold on
plot(flat_sigma(:,1), forward_sigma);
plot(flat_sigma(:,1), flat_sigma(:,2));
plot(flat_sigma(:,1), cumsum(forward_sigma)./((1:length(forward_sigma))'));
ylabel("Cap volatility")
xlabel("Maturity")
hold off
legend('Forward volatility', 'Flat volatility', 'Cum. avg. of forward volatility');

%% Uppgift 2
clc
close all

S0 = data(10,13);
iv = data(2,13);
rf = data(4,13);
N = data(9,13)-22; %22 dagar för 11 helger (begränsar oss för ytterligare helgdagar)
K = data(7, 13);

dt = 1/252;
Nsim = 10000;

%Ingen variansreducering
tic
[payoff, payoff_pv] = get_payoff(Nsim, N, K, S0, iv, rf, dt);
f = exp(-rf*(N-1)*dt)*mean(payoff);
f_plain_vanilla = exp(-rf*(N-1)*dt)*mean(payoff_pv);
var_orig = var(payoff);
toc

% Nsim = 1000;
% Antitetisk Sampling
tic
payoff_as = get_payoff_as(Nsim, N, K, S0, iv, rf, dt);
f_as = exp(-rf*(N-1)*dt)*mean(payoff_as);
var_as = var(payoff_as);
toc

%Control Variate Method
tic
payoff_cv = get_payoff_cv(Nsim, N, K, S0, iv, rf, dt);
f_cv = exp(-rf*(N-1)*dt)*mean(payoff_cv);
var_cv = var(payoff_cv);
toc
%% Uppgift 3
clc
close all

% Q1
K = 100;
t_outer = 1;
t_inner = 3;
mu_1= 0.0015*12;
mu_2 = 0.0005*12;

NouterLSMC = 3000;
NInnerPerOuterLSMC = 16;
tic
[S_outerLSMC, S_innerLSMC] = gen_scenarios(t_outer, t_inner, NouterLSMC, NInnerPerOuterLSMC, mu_1, mu_2);
toc

NouterFN = 3000;
NInnerPerOuterFN = 3000;

tic
[S_outerFN, S_innerFN] = gen_scenarios(t_outer, t_inner, NouterFN, NInnerPerOuterFN, mu_1, mu_2);
toc

[callLSMC, callFN, VaRLSMC, VaRFN] = LSMC_eval(K, S_outerLSMC, S_innerLSMC, S_outerFN, S_innerFN);
% hist(sort(callLSMC),100)
%% Q2 extragrejer
clearvars
clc

K = 140;
t_outer = 1;
t_inner = 3;
mu_1= 0.0015*12;
mu_2 = 0.0005*12;

tic
NouterLSMC = 3000;
NInnerPerOuterLSMC = 16;

[S_outerLSMC, S_innerLSMC] = gen_scenarios(t_outer, t_inner, NouterLSMC, NInnerPerOuterLSMC, mu_1, mu_2);

NouterFN = 3000;
NInnerPerOuterFN = 0;

[S_outerFN, S_innerFN] = gen_scenarios(t_outer, t_inner, NouterFN, NInnerPerOuterFN, mu_1, mu_2);

call = Asian_option(K, S_innerLSMC);

X = S_outerLSMC.^(0:1:3);
Beta = X\(call);
X_FN = S_outerFN.^(0:1:3);
callLSMC = X_FN*Beta;
toc