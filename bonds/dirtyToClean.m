function Bc = dirtyToClean(Bd, N, k, m, Tp)

%CLEANTODIRTY Returns the dirty price given the clean price

Bc = Bd - (1-Tp)*k*N/m;

end

