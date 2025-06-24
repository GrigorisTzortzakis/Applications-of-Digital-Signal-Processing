
% Load the data
load('U.mat');           
[M, N] = size(U);

% Zero-mean each component over realizations
U0 = U - mean(U, 2);

%  Covariance estimate CUU 
CUU = (U0 * U0.') / N;

%  Eigen-decomposition
[Q, Lambda] = eig(CUU);
lambda = diag(Lambda);

%  Sort eigenvalues in descending order
[lambda_sorted, idx] = sort(lambda, 'descend');
Q_sorted = Q(:, idx);

% Test for various P
P_list = [1, 5, 10, 20, 50];

fprintf(' P   MeanE2         SumDiscarded   Difference\n');
fprintf('----------------------------------------------\n');
for k = 1:length(P_list)
    P = P_list(k);
    
    % Project & reconstruct
    Ccoeff = Q_sorted(:, 1:P).' * U0;       % [P x N]
    Uhat   = Q_sorted(:, 1:P) * Ccoeff;     % [M x N]
    
    % Residual
    E = U0 - Uhat;                          % [M x N]
    
    % Empirical mean squared error
    meanE2 = mean(sum(E.^2, 1));
    
    % Theoretical residual energy
    sum_lambda = sum(lambda_sorted(P+1:end));
    
   
    diff = abs(meanE2 - sum_lambda);
    fprintf('%2d  %12.6e  %12.6e  %12.6e\n', P, meanE2, sum_lambda, diff);
end
