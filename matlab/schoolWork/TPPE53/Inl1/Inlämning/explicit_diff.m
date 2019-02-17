function [C,G,delta] = explicit_diff(T, N, vol, r, S, K, M, Smax, Smin)

J = [Smin:(Smax-Smin)/M:Smax];
I = [0:T/N:T];
G = zeros(M+1, N+1);
dt=T/N;
ds=(Smax-Smin)/M;
%randvillkor
G(1,:) = Smax - K*exp(-r*(T-I));
G(:,N+1) = max(fliplr(J)-K,0);
G(M+1,:) = max(Smin - K*exp(-r*(T-I)), 0);

%rekursion
J = fliplr(J);
for j=N:-1:1  
    for i=2:M
        a=((1/dt)-(vol*J(i)/ds)^2)/(r+(1/dt));
        b=(r*J(i)/(2*ds)+0.5*(vol*J(i)/ds)^2)/(r+(1/dt));
        c=((0.5*(vol*J(i)/ds)^2)-r*J(i)/(2*ds))/(r+(1/dt));
        G(i,j)=a*G(i,j+1)+b*G(i-1,j+1)+c*G(i+1,j+1);
    end
end

[S_diff index] = min(abs(J-S));
C = G(index,1);
delta = (G(index-1, 2) - G(index+1, 2))/(2*ds);

end

