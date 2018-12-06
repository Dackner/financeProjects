A = ones(10000,10000);
B = diag(1:10000);
b = (1:10000)';
tic

(A*B)*b;

toc
%%
A = sparse(A);
B = sparse(B);

tic

A*B;

toc