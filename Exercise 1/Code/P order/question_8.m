

clearvars; close all; clc;

%% Process parameters
P = 5;                       % Number of complex exponentials
M = 50;                      % Length of each realization (samples)
N = 100;                     % Number of realizations
sigma2_W = 0.75;             % Variance of white Gaussian noise
omegas = [0.2, 0.4, 0.5, 0.75, 0.88] * pi;  % Angular frequencies

%% Preallocate storage
X = complex(zeros(N, M));    % Matrix to hold all realizations
n = 0:(M-1);                  % Time index vector

%% Set random seed for reproducibility
rng(12345);

%% Main loop: generate each realization
for k = 1:N
    %  Draw random phases 
    phi = -pi + 2*pi*rand(1, P);
    
    %  Compute complex amplitudes 
    A = (1 ./ 2.^(0:(P-1))) .* exp(1j * phi);
    
    % Build the signal component 
    S = zeros(1, M);
    for i = 1:P
        S = S + A(i) * exp(1j * omegas(i) * n);
    end
    
    % Generate white Gaussian noise
    W = sqrt(sigma2_W) * randn(1, M);
    
    % Compose the final process X(n)
    X(k, :) = S + W;
end


save('question8_realizations.mat', 'X', 'omegas', 'sigma2_W');


fprintf('Generated %d realizations of length %d.\n', N, M);
fprintf('Size of X: %d x %d\n', size(X,1), size(X,2));
