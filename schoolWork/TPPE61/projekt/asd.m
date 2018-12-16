[r, S] = kalmanFilter(inS);

figure
subplot(3,1,1)
plot(r(1,:));
subplot(3,1,2)
plot(S(1,:))
subplot(3,1,3)
plot(inS(:,1))

figure 
hold on
plot(S(10,:))
plot(inS(:,10))
legend('smooth', '-');

stdOrigin = sqrt(var(diff(log(inS))));
stdSmooth = sqrt(var(r'));
%%

close all
x = [0:0.1:10];
y = f(x);
plot(x,y);
axis(  [0 10 0 10]  )
legend('y = 3 + 3*exp(-x)')

function y = f(x)

    y = 3 + 3*exp(-x);

end