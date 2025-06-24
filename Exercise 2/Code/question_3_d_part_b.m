
%  checks
assert(exist('Y','var')==1, 'Y not found – run your eigenfilter (Q2) first.');
assert(exist('n','var')==1, 'n not found – define your sample indices.');

%  imagesc of Y
figure;
imagesc(n, 1:K, Y);
axis xy;              
colorbar;
xlabel('n'); 
ylabel('Realization index k');
title(' All realizations of filtered Y(n)');


figure;
mesh(n, 1:K, Y);
xlabel('n');
ylabel('k');
zlabel('Y(n,k)');
title(' Mesh of all filtered realizations Y(n)');
