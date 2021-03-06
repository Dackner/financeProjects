%% Data
clear
[num,txt,raw] = xlsread('data', 'snap');

%%
% close all

Sraw    = cell2mat(raw(2:6785, 2:6));
[N,M]   = size(Sraw);
N       = N-1; %only returns.

% fix data preliminary
S               = Sraw;
S(Sraw == 0)    = NaN;
sNotNaN         = S( sum( isnan( S ), 2 ) == 0, : ); %to be used for R = var(z)

% define state model
scaleQ  = 1;
Q       = scaleQ*eye(M);    %model noise
x       = zeros(N,M)';      %state variables to be estimated

scaleR  = 10000;
z       = diff(log(S))';    %observed states
% R       = scaleR*cov(z');   %measurement noise
% R       = scaleR*corr(z');
R       = scaleR*diag( var( ( diff( log( sNotNaN ) )' )' ) ); % 
%For saving P
P = cell(N,1);

%starting guesses
x(:,1)  = z(:,1);
P{1}    = eye(M);

for t = 2:N
    
    %predict
    xHat = x(:,t-1);
    PHat = P{t-1} + Q;
    
    %update (only if not nan) otherwise just predict
    if sum(isnan(z(:,t))) == 0
        
        v       = z(:,t) - xHat;
        K       = PHat*inv( PHat + R );
        x(:,t)  = xHat + K*v;
        P{t}    = PHat - K*( PHat + R )*K';

    else
        
        x(:,t)  = xHat;
        P{t}    = PHat;
        
    end
    disp(t)
end

%smoothing parameters
Ps = cell(N,1);
xs = zeros(size(x));

%starting guesses for smoothing
Ps(end) = P(end);
xs(end) = x(end);

for k = 1:N-1
    
    %smoothing
    t       = N-k;
    PHat    = P{t} + Q;
    xs(:,t) = x(:,t) + P{t}*( inv( PHat )*( xs(:,t+1) - x(:,t) ) );
    Ps{t}   = P{t} + P{t}*inv( PHat )*( Ps{t+1} - PHat )*( P{t}*PHat )';
    
end

%% Plot log-returns
close all
figure
hold on;
plot(z(1,:)');
plot(x(1,:)');
plot(xs(1,:)');
legend('Raw', 'Filtered', 'Smoothed');
hold off;

figure(2)
hold on;
plot(z(2,:)');
plot(x(2,:)');
plot(xs(2,:)');
legend('Raw', 'Filtered', 'Smoothed');
hold off;

figure(3)
hold on;
plot(z(3,:)');
plot(x(3,:)');
plot(xs(3,:)');
legend('Raw', 'Filtered', 'Smoothed');
hold off;

figure(4)
hold on;
plot(z(4,:)');
plot(x(4,:)');
plot(xs(4,:)');
legend('Raw', 'Filtered', 'Smoothed');
hold off;

figure(5)
hold on;
plot(z(5,:)');
plot(x(5,:)');
plot(xs(5,:)');
legend('Raw', 'Filtered', 'Smoothed');
hold off;

%% Plot prices
close all
z(isnan(z)) = 0;

SS = logRetToPrices(S(1,:), z);
SSf = logRetToPrices(S(1,:), x);
SSs = logRetToPrices(S(1,:), xs);

figure
hold on;
plot(SS(1,:)');
plot(SSf(1,:)');
plot(SSs(1,:)');
legend('Raw', 'Filtered', 'Smoothed');
hold off;

figure
hold on;
plot(SS(2,:)');
plot(SSf(2,:)');
plot(SSs(2,:)');
legend('Raw', 'Filtered', 'Smoothed');
hold off;

figure
hold on;
plot(SS(3,:)');
plot(SSf(3,:)');
plot(SSs(3,:)');
legend('Raw', 'Filtered', 'Smoothed');
hold off;

figure
hold on;
plot(SS(4,:)');
plot(SSf(4,:)');
plot(SSs(4,:)');
legend('Raw', 'Filtered', 'Smoothed');
hold off;

figure
hold on;
plot(SS(5,:)');
plot(SSf(5,:)');
plot(SSs(5,:)');
legend('Raw', 'Filtered', 'Smoothed');
hold off;
