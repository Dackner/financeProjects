clearvars
clc
[x,y,w] = xlsread('data','SNAP');
disp('Data loaded');
%%
clc
close all
tic

dates = w(3:end,1);
T = cell2mat(w(1,2:11));
s = cell2mat(w(3:end,2:11))/100;

r0 = bootstrap(s);
dt = 0.2;
x = (dt:dt:10)';
r = zeros(size(x,1),size(r0,1));

for i = 1:size(r0,1)
    par = nelsonfit(1:1:10, r0(i,:)');
    r(:,i) = nelsonfun(x, par); 
end
r = r';

% r = spline(1:1:10, r0, 1:dt:10);

figure
plot(x, r(1,:));

z = log(1+r);
f = (1/dt)*(z(:, 2:end).*(2*dt:dt:10) - z(:, 1:end-1).*(dt:dt:10-dt));
figure

plot(x(2:end), f(1,:))

df = f(2:end, :) - f(1:end-1, :); 
C = cov(df);
[Q,D] = eig(C);
B = fliplr(Q(:,end-5:end));
A = rot90(rot90(D(end-5:end, end-5:end)));

FL = B'*f';

figure
hold on
plot(x(2:end), B(:,1:3))
legend("shift", "twist", "butterfly");
hold off

figure
hold on
plot(x(2:end), B(:,4:6))
legend("4", "5", "6");
hold off

expl_variance = sum(sum(A))/sum(sum(D));

toc

%%
figure(1)
surf(f);
%%
figure(2)
N = size(f,1);
for i = 1:size(f,1)
   plot(x(2:end), f(N-i+1,:));
   title(dates{N-i+1});
   pause(0.0001);
end

