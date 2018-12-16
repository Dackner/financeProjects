cov = rhoStudT./(sigma'.*sigma);
cInv = (cov\eye(size(cov)));
xt = cInv*(xOpt(1,:)'-((ones(1,14)*cInv*xOpt(1,:)'-1)/(ones(1,14)*cInv*ones(14,1)))*ones(14,1));
