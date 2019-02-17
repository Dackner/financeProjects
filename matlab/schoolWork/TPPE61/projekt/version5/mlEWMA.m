function [xOpt, ll] = mlEWMA(r,dt,likelihoodFunction)


optionvec=optimset('MaxFunEvals',2000,'Display','iter','TolX',1e-12,'TolFun',1e-7,'Algorithm','interior-point');
%% x = [ nu  lambda  df]
x0  = [ 0.1 ; 0.94 ; 1 ]; %Initial solution
lb  = [-Inf ; 0     ; 0  ];
ub  = [ Inf ; 1   ; Inf  ];
A   = [ 0     0      0  ];
b   = [0];

% Solve min  f(x)
%       s.t. Ax <= b
%            lb <= x <= ub
[xOpt,f,exitflag,output,lambda,grad,hessian] = fmincon(@(x) negLikelihood(x,r,dt,@varEWMA,likelihoodFunction),x0,A,b,[],[],lb,ub,[],optionvec);

ll = likelihoodNormal(xOpt,r,dt,@varEWMA);

