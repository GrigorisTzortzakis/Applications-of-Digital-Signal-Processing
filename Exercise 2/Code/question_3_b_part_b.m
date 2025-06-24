
%  checks
assert(exist('X','var')==1, 'X not found – run Q2 first.');
assert(exist('n','var')==1, 'n not found – define your sample indices.');

%  imagesc
figure;
imagesc(n, 1:K, X);
axis xy;              
colorbar;
xlabel('n'); 
ylabel('Realization index k');
title(' All realizations of X(n)');

%  mesh 
figure;
mesh(n, 1:K, X);
xlabel('n');
ylabel('k');
zlabel('X(n,k)');
title(' Mesh of all realizations of X(n)');
