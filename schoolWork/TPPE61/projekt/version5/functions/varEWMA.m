function [v]=varEWMA(x,r,dt)

lambda  = x(2);

v=zeros(length(r)+1,1);
v(1)=(std(r))^2/dt;

for i=1:length(r)
  v(i+1) = lambda*v(i) + (1-lambda)/dt*r(i)^2;
end
