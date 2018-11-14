function [C,H] = generic_diff(T, N, vol, r, S, K, M, Smax, Smin, theta, type)
    Xmin = log(Smin);
    Xmax = log(Smax);
    J = [0:T/(M+1):T];
    I = [Xmin:(Xmax-Xmin)/(N+1):Xmax];
    H = zeros(N+2, M+2);
    dt = T/(M+1);
    dx = (Xmax-Xmin)/(N+1);
    
    %randvillkor
    if type == "AON"
        H(N+2, :) = S.*(exp(Xmax) >= K);
        H(:, M+2) = S.*(exp(I) >= K);
    else
        H(N+2, :) = exp(Xmax) - K*exp(-r*(T-J));
        H(:, M+2) = max(exp(I)-K,0);
    end
    %rand i Smin är 0.
        
    %statiska parameter
    v = vol^2;
    b = r - 0.5*v;
    alpha = dt/(dx^2);
    
    c = -alpha*v;
    u = 0.5*alpha*(v + dx*b);
    l = 0.5*alpha*(v - dx*b); 
    
    %B
    r1 = l*(H(1, 1:M+1)*(1 - theta) + H(1, 2:M+2)*theta);
    r2 = u*(H(N+2, 1:M+1)*(1 - theta) + H(N+2, 2:M+2)*theta);
    B = [r1; zeros(N,M+1); r2];
    
    %M
    l_ = l*ones(N,1);
    c_ = c*ones(N,1);
    u_ = u*ones(N,1);
    
    l_d = diag(l_);
    c_d = diag(c_);
    u_d = diag(u_);
    
    M_ =[zeros(1,N); l_d(1:N-1,:)] + c_d + [zeros(N,1) u_d(:,1:N-1)];
    
    %loop
    I_ = eye(N,N);
    for j = M+1:-1:1
        A = ((1+r*dt)*I_ - (1-theta)*M_);
        b_ = (theta*M_ + I_)*H(2:N+1, j+1);
        H(2:N+1, j) = A\b_; 
    end
    
    [S_diff index] = min(abs(exp(I)-S));
    C = H(index,1);
end