
%% Fetch data
clearvars
%

%% Params
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

u = exp( sigma*sqrt(dt) );
d = 1/u;
q = (exp( r*dt ) - d)/(u - d);

STree = binomialTree(u, d, S0, T, dt);
%% Plain Vanillas
clc

%EU
[CTree ,PTree] = binomialPlainVanillaEU(STree, K, r, dt, q);
C = CTree(1,1);
P = PTree(1,1);

%US
[CTree ,PTree] = binomialPlainVanillaUS(STree, K, r, dt, q);
CUS = CTree(1,1);
PUS = PTree(1,1);

%Comparisons
[CBSM, PBSM] = BSMPlainVanilla(T, sigma, S0, K, r, 0);

comparisonEUBSM = [C, CBSM, P, PBSM]    %Should be equal
comparisonEUUS  = [C, CUS, P, PUS]      %Call should be equal (with r > 0), US Put greater or equal 

%% AssetOrNothings
clc

%EU
[CTree ,PTree] = binomialAssetOrNothingEU(STree, K, r, dt, q);
C = CTree(1,1);
P = PTree(1,1);

%US
[CTree ,PTree] = binomialAssetOrNothingUS(STree, K, r, dt, q);
CUS = CTree(1,1);
PUS = PTree(1,1);


%Comparisons
[CBSM, PBSM] = BSMAssetOrNothing(T, sigma, S0, K, r, 0);

comparisonEUBSM = [C, CBSM, P, PBSM]    %Should be equal, but hard to price through dicretizised methods. Should have really small dt for this
comparisonEUUS  = [C, CUS, P, PUS]      %Should be EU <= US

%% CashOrNothings

clc

%EU
[CTree ,PTree] = binomialCashOrNothingEU(STree, K, r, dt, q);
C = CTree(1,1);
P = PTree(1,1);

%US
[CTree ,PTree] = binomialCashOrNothingUS(STree, K, r, dt, q);
CUS = CTree(1,1);
PUS = PTree(1,1);


%Comparisons
[CBSM, PBSM] = BSMCashOrNothing(T, sigma, S0, K, r, 0);
% 
comparisonEUBSM = [C, CBSM, P, PBSM]    %Should be equal, but hard to price through dicretizised methods. Should have really small dt for this
comparisonEUUS  = [C, CUS, P, PUS]      %Should be EU <= US American options like this one are weird though.
