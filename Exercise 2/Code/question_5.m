

%  Load  data
load('U.mat');      
[M, N] = size(U);

% Compute covariance and eigen decomposition
CUU = (1/N) * (U * U');
[Q, L] = eig(CUU);
[lambda, idx] = sort(diag(L), 'descend');
Q = Q(:, idx);

%  Project onto eigenbasis
C = Q' * U;  

% Set noise variance and P range
sigma2 = 0.01;           
sigma = sqrt(sigma2);
P_vals = 0:50:M;

% Preallocate error array
MSE_comp = zeros(size(P_vals));
MSE_full = M * sigma2;

%  Loop over P_vals
for k = 1:length(P_vals)
    P = P_vals(k);
    if P == 0
        err = -U;
    else
        noiseC = sigma * randn(P, N);
        C_noisy = C(1:P, :) + noiseC;
        Uhat = Q(:, 1:P) * C_noisy;
        err = Uhat - U;
    end
    MSE_comp(k) = mean(sum(err.^2, 1));
end


figure;
plot(P_vals, MSE_comp, 'b-o', 'LineWidth', 1.5);
hold on;
plot(P_vals, MSE_full * ones(size(P_vals)), 'r--', 'LineWidth', 1.5);
grid on;
xlabel('Number of transmitted coefficients P');
ylabel('Mean-squared error');
legend('Compressed + noisy send','Full-dimension send','Location','northeast');
title(sprintf('MSE vs P (noise variance sigma^2 = %.3f)', sigma2));
