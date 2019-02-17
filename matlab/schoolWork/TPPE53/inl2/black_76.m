function [c, p] = black_76(L, delta, P, F, sigma, Rk, t)
    d1 = (log(F/Rk) + 0.5*(sigma.^2).*t)./(sigma.*sqrt(t));
    d2 = d1 - sigma.*sqrt(t);
    c = L*delta*P*(F*normcdf(d1) - Rk*normcdf(d2));
    p = L*delta*P*(Rk*normcdf(-d2) - F*normcdf(-d1));
end

