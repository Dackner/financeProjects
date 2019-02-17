function call = Asian_option(K, S_inner)
% Returns the value of a Asian arithmetic call option with strike K for stock values
% S_inner, and averages over each set of inner scenarios.

[T, NInnerPerOuter, Nouter] = size(S_inner);
call = zeros(Nouter, NInnerPerOuter);

t_obs = 12; %observation period of 1 year

for i=1:Nouter
    
    for k=1:NInnerPerOuter
        call(i,k) = max(mean(S_inner(T-t_obs:T,k,i))-K,0);
    end
    
end

call = mean(call,2);

end
