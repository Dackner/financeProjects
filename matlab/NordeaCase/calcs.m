%% Corr of swe rates data
[NUM,TXT,RAW]=xlsread('dataCase', 'SWEBMKSNAP');


R = cell2mat( RAW(4:246, 3:10 ) )/100;
R = flipud(R);
%% Corr of swe rates
CORR_R = corr(diff(R));
% xlswrite('dataCase.xlsx', CORR , 'IRANALYSIS')



%% Corr currencies data 1M
clear
[NUM,TXT,RAW]=xlsread('dataCase', 'CURRDATASNAP');
C = cell2mat( RAW(3:262, 1:4 ) );
C = flipud(C);
C(:,1) = C(:,1)/100;

D = zeros(size(C,1)-1, size(C,2));
D(:,1) = diff(C(:,1));
D(:,2:4) = ( C(2:end, 2:4) - C(1:end-1, 2:4) )./C(1:end-1, 2:4);

%%
CORR_C_S = corr(diff(C));

%% Corr currencies data 1M
clear
[NUM,TXT,RAW]=xlsread('dataCase', 'CURRLONGSNAP');
C_L = cell2mat( RAW(3:262, 1:4 ) );
C_L = flipud(C_L);

%%
CORR_C_L = corr(diff(C_L));
%% Corr currencies data NEW
clear
[NUM,TXT,RAW]=xlsread('dataCase', 'CURRSNAPNEW');
C_N = cell2mat( RAW(3:244, 1:9 ) );
C_N = flipud(C_N);
C_N(:,1:6) = C_N(:,1:6)/100;
%%
CORR_C_N = corr(diff(C_N));
% xlswrite('dataCase.xlsx', CORR_C_N , 'CURRANALYSIS')