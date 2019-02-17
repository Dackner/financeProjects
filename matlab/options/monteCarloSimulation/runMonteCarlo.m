%% Load data
clearvars

%% Parameters
clearvars
clc

BSMPath = '../helpFunctions';
addpath(BSMPath)

T       = 5/12;
% dt      = 0.0002/12;    %Maximum accuracy without breaking rules of matlab 
dt      = 0.01/12;        %OK accuracy for Plain Vanillas
% dt      = 1/12; 
sigma   = 0.2;
r       = 0.05;
S0      = 62;
K       = 60;

Nsim = 10000;

%% asd
clc
close all
[S1, S2] = generateGBMAntitheticSampling(S0, sigma, dt, T, r, Nsim);

payoff = 0.5*( max( S1(1:end,end) - K , 0) + max( S1(1:end,end) - K , 0) );

C = exp(-r*T)*mean(payoff)
 

% plot(dt:dt:T, S');