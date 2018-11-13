function [w, obj] = unboundedOpt(scenarioReturns, R, gamma)

% Matrix computation of gradient and hessian (to improve speed)
% f    = p*A;
% grad = p*A'*dU;
% hess = p*A'*(repmat(d2U, 1, n).*A);

beta = 0.99;
eps = 1E-10;
c = scenarioReturns;
p = 1/size(c,1);
n = size(c,2);

%matrix representation
A = c - R;

%newton
w = [.2 .2 0.2 .2 0.2]'; %start sol
grad = 1;
It = -1;
lambda = 1;

while norm(grad) > eps
    
    %calc U, f and grad
    U = evalU(A*w+R, gamma);
    obj = sum(p'*U(:,1));
    grad = p*A'*U(:,2);
    H = p*A'*(repmat(U(:,3), 1, n).*A);
    
    %print info
%     It = It + 1;
%     [It,obj];
    
    %perform newton step
    s = -H\grad;
    
    %update lambda
    lambda = updateLambda(A, w, R, s, beta);
    w = w + lambda*s;
    
   
end

end




%some helper functions
function U = evalU(z, gamma)
%U1: U, U2: dU, U3: d2U
n = length(z);
U = zeros(n,3);

if gamma > 1
    
    error("Invalid gamma for util func");
    
else
    
    if gamma == 0
        
        U(:,1) = log(z);
        U(:,2) = 1./z;
        U(:,3) = -1./(z.^2);
        
    else
        
        U(:,1) = (1/gamma).*z.^gamma;
        U(:,2) = z.^(gamma-1);
        U(:,3) = (gamma-1).*z.^(gamma-2);
        
    end
    
end

end


function l = updateLambda(A, w, R, s, beta)

x = A*w+R;
y = A*s;
z = x./(-y);
index = y < 0;
l = min( beta * min(z(index)), 1);

end
