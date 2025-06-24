
close all; clc;

% Check 
assert(exist('R','var')==1, 'Variable R (RUU) not found. Run Q2 first.');
assert(exist('sigma2','var')==1, 'Variable sigma2 not found. Run Q2 first.');
assert(exist('M','var')==1, 'Variable M not found. Run Q2 first.');

%  Form the noisy covariance estimate
Cxx = R + sigma2 * eye(M);

% Plot with imagesc
figure;
imagesc(1:M, 1:M, Cxx);
axis tight; 
colorbar;
xlabel('n'); 
ylabel('m');
title('Estimated C_{XX} = R_{UU} + \sigma^2 I');

% Plot with mesh
figure;
mesh(1:M, 1:M, Cxx);
xlabel('n'); 
ylabel('m'); 
zlabel('C_{XX}(m,n)');
title('Mesh of Estimated C_{XX}');
