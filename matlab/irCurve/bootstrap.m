function [r] = bootstrap(s)

r = zeros(size(s));
ss = zeros(size(s,1),1);
r(:,1) = s(:,1);

for T=2:size(s,2)
    r(:,T) = ((1 + s(:, T))./(1-sum(s(:, 1:T-1).*( (1 + r(:,1:T-1)).^(-[1:1:T-1]) ),2))).^(1/T) - 1;
end

end

