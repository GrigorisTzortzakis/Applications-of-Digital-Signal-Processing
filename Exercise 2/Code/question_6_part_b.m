
clear; close all; clc;


N      = 1e4;     
K      = 100;     
M      = 50;      
sigW2  = 0.05;    
rng default;      


%  weak-sense-stationary
a = [1 -1.5 0.7];           % stable  denominator
b = 1;                      % numerator
driver = randn(K,N);        % white Gaussian input
U = filter(b,a,driver,[],2);
U = U - mean(U,2);          

%  white noise 
W = sqrt(sigW2)*randn(K,N);


X = U + W;


segLen = N - M + 1;
Umat   = zeros(M,K*segLen);
for k = 1:K
    blk  = buffer(U(k,:),M,M-1,'nodelay');   
    cols = (k-1)*segLen + (1:segLen);
    Umat(:,cols) = blk;
end
Ruu = (Umat*Umat.') / size(Umat,2);

[V,D]   = eig(Ruu,'vector');
[~,idx] = max(D);
h = V(:,idx) / norm(V(:,idx));              % eigen-filter 


Y = filter(h,1,X,[],2);



Xmat = zeros(M,K*segLen);
for k = 1:K
    blk  = buffer(X(k,:),M,M-1,'nodelay');
    cols = (k-1)*segLen + (1:segLen);
    Xmat(:,cols) = blk;
end
Cxx = (Xmat*Xmat.') / size(Xmat,2);

figure('Position',[80 60 1200 850]);

subplot(3,2,1);
imagesc(Cxx); axis square; colorbar;
title('(a)  Estimated covariance C_{XX}');
xlabel('lag'); ylabel('lag');

subplot(3,2,2);
imagesc(X); colormap jet; colorbar;
title('(b)  All realisations of X = U + W');
xlabel('n'); ylabel('realisation #');

subplot(3,2,3);
plot(mean(X,1),'LineWidth',1.2); grid on;
title('(c)  Ensemble mean of X');
xlabel('n');

subplot(3,2,4);
imagesc(Y); colormap jet; colorbar;
title('(d)  All realisations of Y_k = filter(h,1,X_k)');
xlabel('n'); ylabel('realisation #');

subplot(3,2,5);
plot(mean(Y,1),'LineWidth',1.2); grid on;
title('(e)  Ensemble mean of Y (after eigen-filter)');
xlabel('n');

subplot(3,2,6);
stem(h,'filled'); grid on;
title('Eigen-filter h');
xlabel('tap #');
