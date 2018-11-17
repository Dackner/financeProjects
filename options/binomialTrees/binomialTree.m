function tree = binomialTree(u, d, S0, T, dt)

%BINOMIALTREE Returns a binomial tree of size T/dt

if mod(T, dt) ~= 0 
   error('T is not divisible by dt, tree cannot be built.'); 
end

n = floor(T/dt) + 1;
tree = zeros(n);
tree(1,1) = S0;

for i = 2:n 
    
    tree(1, i) = tree(1, i-1) * u;
    tree(2:end, i) = tree(1:end-1,i-1)*d;
    
end

end

