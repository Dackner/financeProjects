function Bd = cleanToDirty(Bc, N, k, m, Tp)

%CLEANTODIRTY Returns the dirty price given the clean price

Bd = Bc + (1-Tp)*k*N/m;

end

