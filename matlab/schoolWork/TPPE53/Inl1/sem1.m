clc
clearvars
%readvals
[num,txt,raw] = xlsread("data.xlsx", "snap");
%%
%seminarium
clc

S = num(1,1);
T = num(11,1);
K = num(7,1);
r = num(26,1)/100;
vol = num(8,1)/100;

Smin = 2000;
Smax = 1000;
N = 8000; %tid
M = 1000; %pris

% [C_EFDM,G,delta_EFDM] = explicit_diff(T, N, vol, r, S, K, M, Smax, Smin);
% [C_BS, delta_BS] = BS(T,vol,S,K,r);

d1 = (log(S/K) + (r+0.5*vol^2)*T)/(vol*sqrt(T));
d2 = d1 - vol*sqrt(T);
[C,f,l,i] = explicit_diff(T, N, vol, r, S, K, M, Smax, Smin);

% Delta
dS = (Smax-Smin)/M;
delta_num = (f(i-1,2) - f(i+1,2))/(2*dS);
delta_an = normcdf(d1);

% Theta
dt = T/N;
theta_num = (f(i,2)-f(i,1))/dt;
theta_an = -S*normpdf(d1)*vol/(2*sqrt(T)) - r*K*exp(-r*T)*normcdf(d2);

% Vega
dvol = 0.01/100;
C_f = explicit_diff(T, N, vol-dvol, r, S, K, M, Smax, Smin);
C_g = explicit_diff(T, N, vol+dvol, r, S, K, M, Smax, Smin);
vega_num = (C_g-C_f)/(2*dvol);
vega_an = S*sqrt(T)*normpdf(d1);

% Rho
dr = 0.01/100;
C_f = explicit_diff(T, N, vol, r-dr, S, K, M, Smax, Smin);
C_g = explicit_diff(T, N, vol, r+dr, S, K, M, Smax, Smin);
rho_num = (C_g-C_f)/(2*dr);
rho_an = K*T*exp(-r*T)*normcdf(d1);

%%
%1a och 1d
clc

S = num(1,1);
T = num(11,1);
K = num(7,1);
r = num(26,1)/100;
vol = num(8,1)/100;

Smin = 2000;
Smax = 1000;
N = 8000; %tid
M = 1000; %pris

[C_EFDM,G,delta_EFDM] = explicit_diff(T, N, vol, r, S, K, M, Smax, Smin);
[C_BS, delta_BS] = BS(T,vol,S,K,r);
%%
%1b
clc
S = num(1,1);
T = num(11,1);
K = num(7,1);
r = num(26,1)/100;
vol = num(8,1)/100;

Smin = 1000;
Smax = 2000;
N = 4000; %diskretisering av pris
M = 40; %tid

tic
[C_Explicit] = generic_diff(T, N, vol, r, S, K, M, Smax, Smin, 1, "");
toc
tic
[C_Implicit] = generic_diff(T, N, vol, r, S, K, M, Smax, Smin, 0, "");
toc
tic
[C_CrankN] = generic_diff(T, N, vol, r, S, K, M, Smax, Smin, 0.5 , "");
toc
C_BlackSM = BS(T,vol,S,K,r);
%%
%1c

%parametrar för alla optioner
clc
S = num(1,1);
K = num(7,1:5)';
T = num(11,1);
vol = (num(8,1:5)/100)';
r = num(26,1)/100;

Smin = 1000;
Smax = 2000;
N = 4000; %diskretisering av pris
M = 40; %tid

%Implicit FDM, C = C_EFDM, C_BS, error
C = zeros(5,3);
for i=1:5
    C(i, 1) = generic_diff(T, N, vol(i), r, S, K(i), M, Smax, Smin, 0, "");
    C(i, 2) = BS(T,vol(i),S,K(i),r);
    C(i,3) = C(i,1)/C(i,2)-1;
end
%skriv till excel för lösning med solvern
% xlswrite("data.xlsx", C(:,1), "IV", "A2:A6");
IV = xlsread("data.xlsx", "IV");
IV = IV(:,4);
plot(K,IV/100)
%%
%1d
%Se 1a ovan.

%2
clc
S = num(1,1);
T = num(11,1);
K = num(7,1);
r = num(26,1)/100;
vol = num(8,1)/100;

Smin = 1000;
Smax = 2000;
N = 4000; %diskretisering av pris
M = 40; %tid

[C_AON_Implicit] = generic_diff(T, N, vol, r, S, K, M, Smax, Smin, 0, "AON");

%Analytisk värdering
d1 = (log(S/K) + (r+0.5*vol^2)*T)/(vol*sqrt(T));
c_AON = S*exp(-r*T)*normcdf(d1);