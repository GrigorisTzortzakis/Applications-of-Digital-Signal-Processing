
clear; clc;

% Parameters
K       = 1000;      % number of realizations
N       = 10000;     % length of each realization 
fs      = 1000;      % period denominator in the sine argument
sigma2W = 0.1;       % noise variance
sigmaW  = sqrt(sigma2W);

% Time‐index vector
n = (0:N-1)';       

% Random phases
phi = 2*pi * rand(1, K);    

% Preallocate output
X = zeros(N, K);

% Generate AWGN noise matrix 
W = sigmaW * randn(N, K);

% Vectorized construction of X:

S = sin( 2*pi/fs * n + phi );  

% Add noise
X = S + W;


figure;
plot(n(1:200), X(1:200, 1:5)); 
xlabel('n'); ylabel('X(n)');
legend('real 1','2','3','4','5');
title('First 5 realizations of X(n)');
