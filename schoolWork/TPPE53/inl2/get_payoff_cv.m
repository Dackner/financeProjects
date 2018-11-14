function payoff = get_payoff_cv(Nsim, N, K, S0, iv, rf, dt);
payoff = zeros(Nsim, 1);
payoff_pv = zeros(Nsim, 1);

for j=1:Nsim
    
    Bflag = false;
    B = S0*0.9;
    St = zeros(N,1);
    St(1) = S0;
    
    for i=2:N
        
        St(i) = St(i-1)*exp((rf-0.5*iv^2)*dt+iv*sqrt(dt)*normrnd(0,1));
        
        if mod(i-3,5) == 0
            
            if St(i) < B
                Bflag = true;
            elseif St(i) > B/0.9
                B = 0.9*St(i);
            end
            
        end
        
    end

    if ~Bflag
        payoff(j) = max(St(end) - K,0);
    end
    
    payoff_pv(j) = max(St(end) - K,0);
    
end

Y = payoff;
Z = payoff_pv;
c = -cov(Y, Z)/var(Z);

payoff = Y + c(1,2)*(Z-mean(Z));
end

