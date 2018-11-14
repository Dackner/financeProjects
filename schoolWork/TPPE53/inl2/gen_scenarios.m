function [S_outer, S_inner] = gen_scenarios(t_outer, t_inner, Nouter, NInnerPerOuter, mu_outer, mu_inner)
% This function performs a nested MC simulation of a Black-Scholes stock process. t_outer
% and t_inner denotes the time horizon in years for the outer and inner simulations,
% respectively. It returns the value S_outer and S_inner of the stock process at the
% endpoint of the outer and inner scenarios, respectively.
% Outer scenarios:

S0 = 100;
sigma = 0.016*sqrt(12);
t = t_outer*12;
dt = 1/12;
Z = normrnd(0, 1, [t, Nouter]);
S = GBM(t_outer, Nouter, S0, mu_outer, sigma, dt, Z);
S_outer = S(t,:); % end value of outer scenarios, used as starting value for inner scenarios t, N, S0, mu, sigma, dt, Z
S_outer = S_outer.';

% Inner scenarios:
t = t_inner*12;
[no_outer_scenarios, n] = size(S_outer);
S_inner = zeros(t, NInnerPerOuter, Nouter);
for i=1:no_outer_scenarios
    Z = normrnd(0,1,[t, NInnerPerOuter]);
    S = GBM(t_inner, NInnerPerOuter, S_outer(i), mu_inner, sigma, dt, Z);
    S_inner(:,:,i) = S;
end