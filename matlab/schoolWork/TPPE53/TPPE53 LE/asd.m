%3.8
clc;
clearvars;
mu  = 0;
s = 0.018;
muY = 10;
sY = 1;

n = 1000;
x = normrnd(0,1,n,1);
Xi = exp(10*x-0.5*10^2);
I = x <= 1;

P = (1/n)*sum(Xi.*I);
LL = 14*10^9;
P_ = (1-P)^LL
P*LL
%%