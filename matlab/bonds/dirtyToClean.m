function Pc = dirtyToClean(Pd, N, k, m, Tp)

%CLEANTODIRTY Returns the dirty price given the clean price

Pc = Pd - (1-Tp)*k*N/m;

end

