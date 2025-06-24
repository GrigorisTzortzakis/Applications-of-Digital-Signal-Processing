
clearvars; close all; clc

% Parameters
N = 10000;       
n = 0:N-1;      
K = 1000;        
sigma2 = 0.1;    
M = 50;          

% Generate K realizations of U(n) 
U = zeros(K,N);
X = zeros(K,N);
for k = 1:K
    phi = 2*pi*rand;                     
    U(k,:) = sin(2*pi/1000 * n + phi);   
    W = sqrt(sigma2)*randn(1,N);         
    X(k,:) = U(k,:) + W;                 
end

% Estimate autocovariance sequence 
r = zeros(M,1);

for lag = 0:M-1
    
    tmp = U(:,1+lag:N) .* U(:,1:N-lag);
    r(lag+1) = mean(tmp(:));
end

% Build the M×M Toeplitz autocovariance matrix R_UU
R = toeplitz(r);

%  Eigen‐decomposition 
[Q,L] = eig(R);                         
[lam_sorted, idx] = sort(diag(L),'descend');
h = Q(:, idx(1));                      

% Apply the eigenfilter to each noisy realization
Y = zeros(K,N);
for k = 1:K
    Y(k,:) = filter(h, 1, X(k,:));
end


figure;
subplot(3,1,1);
plot(0:M-1, h, 'LineWidth',1.5);
title('Eigenfilter \ith\rm(n) (principal eigenvector)');
xlabel('n'); ylabel('h(n)');

subplot(3,1,2);
plot(n, U(1,:), 'b', n, Y(1,:), 'r');
legend('Original U_1','Filtered Y_1');
title('Example realization before & after filtering');

subplot(3,1,3);
plot(0:M-1, r, 'k','LineWidth',1.5);
title('Estimated autocovariance r_{UU}(k)');
xlabel('lag k'); ylabel('r_{UU}(k)');
