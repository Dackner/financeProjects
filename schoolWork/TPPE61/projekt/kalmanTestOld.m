%% Random walk
clearvars
close all
M = 1000;
N = 6;
y0 = 0;
xi = norminv( rand(M, N) );
y = cumsum( xi );
y(floor(length(y))/2) = y(floor(length(y))/2-1) + 10;
x = zeros( M, N );

% plot(1:1000, y)
C = cov(y);
y = y';
x = x';

%%
close all
%xt = A*xt-1 + wt
%yt = H*xt + vt
cQ = 1;
cR = 1;
Q  = cQ*C;
R  = cR*C;

A = eye(N);
H = eye(N);
P = C;



for i = 1:length(y)-1
    
    x(:,i+1)    = A*x(:,i);
    P           = A*P*A' + Q;
    
    
    K           = P*H'*inv( H*P*H' + R );
    x(:, i+1)   = x(:, i) + K*( y(:, i+1) - x(:, i) );
    P           = P - K*H*P; 
    
end



hold on
plot(y(1,:));
plot(x(1,:));

legend('original', 'filtered');
