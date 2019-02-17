function [ rK, pK ] = kalmanFilter( S, scaleQ, scaleR )
%kalmanFilter Trello: 0. Returns Kalman-smoothed logarithmic returns rK and
%prices pK
%   In-parameter S(i,j) is raw asset prices in ascending time sequence for
%   timestamps i and assets j.

[N,M]   = size(S);
N = N -1; %only retiurns

% find missing data and replace with NaN
sNotNaN         = S( sum( isnan( S ), 2 ) == 0, : ); %to be used for R = var(z)

% define state model
%scaleQ  = 1E-4;
Q       = scaleQ*eye(M);    %model noise
x       = zeros(N,M)';      %state variables to be estimated

%scaleR  = 1E1;
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

xSs = logRetToPricesForKalman(S(1,:), xs);

rK = xs.';
pK = xSs.';

end
% end
% % Plot log-returns
% close all
% 
% for i = 1:M
%     
%     figure(i)
%     hold on;
%     plot(z(i,:)');
%     plot(x(i,:)');
%     plot(xs(i,:)');
%     legend('Raw', 'Filtered', 'Smoothed');
%     title(i);
%     hold off;
%     
% end


%  Plot prices
% close all
% z(isnan(z)) = 0;
% 
% SS = logRetToPrices(S(1,:), z);
% SSf = logRetToPrices(S(1,:), x);
% SSs = logRetToPrices(S(1,:), xs);
% 
% for i = 1:M
%     
%     figure(i)
%     hold on;
%     plot(SS(i,:)');
%     plot(SSf(i,:)');
%     plot(SSs(i,:)');
%     legend('Raw', 'Filtered', 'Smoothed');
%     title(i);
%     hold off;
%     
% end
% 
% end