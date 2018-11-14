function [mu] = estExpectedBlackLitterman(muP, Sigma, P, q, Omega)

muP = muP';
q = q';

H = Sigma\eye( size(Sigma) ) + P'*( Omega\P );
mu = H\( Sigma\muP + P'*( Omega\eye(size(Omega))*q ) );
mu = mu';