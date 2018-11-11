function Pd = cleanToDirty(Pc, N, k, m, Tp)

%CLEANTODIRTY Returns the dirty price given the clean price

Pd = Pc + (1-Tp)*k*N/m;

end

