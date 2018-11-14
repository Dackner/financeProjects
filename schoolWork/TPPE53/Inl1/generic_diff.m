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
        H(N+2, :) = exp(Xmax).*(exp(Xmax) >= K);
        H(:, M+2) = exp(I).*(exp(I) >= K);
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
    B = [r1; zeros(N-2,M+1); r2];
    
    %M
    M_ = full(gallery('tridiag',N,l,c,u));
    
    %loop
    I_ = eye(N,N);
    for j = M+1:-1:1
        A = ((1+r*dt)*I_ - (1-theta)*M_);
        b_ = (theta*M_ + I_)*H(2:N+1, j+1) + B(:,j);
        H(2:N+1, j) = A\b_; 
    end
    
    [S_diff index] = min(abs(exp(I)-S));
    C = H(index,1);
end