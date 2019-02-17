function payoff = get_payoff_as(Nsim, N, K, S0, iv, rf, dt)

payoff1 = zeros(Nsim, 1);

for j=1:Nsim
    
    Bflag = false;
    B = S0*0.9;
    St1 = zeros(N,1);
    St1(1) = S0;
    
    for i=2:N
        
        St1(i)=St1(i-1)*exp((rf-0.5*iv^2)*dt+iv*sqrt(dt)*normrnd(0,1));
        
        if mod(i-3,5) == 0
            if St1(i) < B
                Bflag = true;
            elseif St1(i) > B/0.9
                B = 0.9*St1(i);
            end
            
        end
        
    end
   % plot(St);
    if ~Bflag
        payoff1(j) = max(St1(end) - K,0);
    end
    
end

payoff2 = zeros(Nsim, 1);

for j=1:Nsim
    
    Bflag = false;
    B = S0*0.9;
    St2 = zeros(N,1);
    St2(1) = S0;
    
    for i=2:N
        
        St2(i) = St2(i-1)*exp((rf-0.5*iv^2)*dt-iv*sqrt(dt)*normrnd(0,1));
        
        if mod(i-3,5) == 0
            
            if St2(i) < B
                Bflag = true;
            elseif St2(i) > B/0.9
                B = 0.9*St2(i);
            end
            
        end
        
    end
    
    if ~Bflag
        payoff2(j) = max(St2(end) - K,0);
    end
    
end
payoff = (payoff1 + payoff2)/2;
end

