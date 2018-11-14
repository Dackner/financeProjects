function sigma = black_76_iv(x, type, L, delta, P, F, Rk, t)
s = (0:0.001:100);
[C,P] = black_76(L, delta, P, F, s, Rk, t);
if type == "caplet"
    [M,I] = min(abs(C-x));
    sigma = s(I);
elseif type == "floorlet"
    [M,I] = min(abs(P-x));
    sigma = s(I);
else
    sigma = "Invalid type";
end
        
end

