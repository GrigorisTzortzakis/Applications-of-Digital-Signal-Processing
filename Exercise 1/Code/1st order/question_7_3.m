
clear; close all; clc;

% Parameters
N      = 100;                    % number of realizations
Mlist  = [2, 10, 20, 30, 50];    % values of M
M0     = max(Mlist);             % maximum sequence length
A_true = 3/sqrt(2);              % true amplitude
sigma2 = 0.5;                    % noise variance
omega  = pi/5;                   % signal frequency

% Simulate N realizations of the process
phases = -pi + 2*pi*rand(N,1);   % random phases
n      = 0:(M0-1);               % time indices
X      = zeros(N, M0);
for k = 1:N
    X(k,:) = A_true * exp(1j*(omega*n + phases(k))) + sqrt(sigma2)*randn(1,M0);
end

% Estimate the autocorrelation matrix 
R_est = (X') * X / N;


A_est = zeros(size(Mlist));

% Loop over each M and compute |A|
for idx = 1:length(Mlist)
    M   = Mlist(idx);
    Rm  = R_est(1:M,1:M);         
    vals = sort(eig(Rm), 'descend');
    
    lambda_max     = vals(1);
    if M > 1
        noise_var = mean(vals(2:end));
    else
        noise_var = 0;
    end
    
    
    A_est(idx) = sqrt( max((lambda_max - noise_var)/M, 0) );
end


for idx = 1:length(Mlist)
    fprintf('M = %2d: Estimated |A| = %.4f\n', Mlist(idx), A_est(idx));
end
