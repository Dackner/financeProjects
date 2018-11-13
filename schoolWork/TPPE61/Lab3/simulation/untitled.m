A = ones(10000);
B = A;
b = ones(10000,1);

tic
(A*B)*b;
toc

tic 
A*(B*b);
toc

tic
A*B*b;
toc