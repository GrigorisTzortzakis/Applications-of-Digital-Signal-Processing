
clear; clc; close all

%  parameters
N       = 10000;        % number of samples per realization
n       = (0:N-1)';     % time index
fs      = 1000;         % sinusoid denominator
sigma2W = 0.1;          % noise variance
sigmaW  = sqrt(sigma2W);
M       = 50;           % filter length 
Ks      = [10, 50, 100];% values of K to examine

for idx = 1:numel(Ks)
    K = Ks(idx);

    %  Generate K realizations 
    U = zeros(K, N);
    X = zeros(K, N);
    for k = 1:K
        phi        = 2*pi*rand;
        U(k, :)    = sin(2*pi/fs * n + phi);
        X(k, :)    = U(k, :) + sigmaW*randn(1, N);
    end

    %  Estimate the autocorrelation of X and build Rxx
    r_x = zeros(M, 1);
    for lag = 0:M-1
        r_x(lag+1) = mean( X(:, 1+lag:end) .* X(:, 1:end-lag), 'all' );
    end
    Rxx = toeplitz(r_x);

    %  Eigen‐decompose 
    [Q, L] = eig(Rxx);
    [~, ix] = max(diag(L));
    h = Q(:, ix);

    % Filter each realization 
    Y = zeros(K, N);
    for k = 1:K
        Y(k, :) = filter(h, 1, X(k, :));
    end

    
    figure('Name', sprintf('Eigenfilter Q4 — K = %d', K));

  
    subplot(2,3,1);
    imagesc(Rxx); 
    colorbar;
    title('Estimated C_{XX}');
    xlabel('Lag'); ylabel('Lag');

   
    subplot(2,3,2);
    plot(n, X(1:min(5,K), :)');
    title('Sample X(n) realizations');
    xlabel('n'); ylabel('X');

  
    subplot(2,3,3);
    plot(n, mean(X,1));
    title('Mean\{X(n)\}');
    xlabel('n'); ylabel('E\{X\}');

   
    subplot(2,3,5);
    plot(n, Y(1:min(5,K), :)');
    title('Sample Y(n) realizations');
    xlabel('n'); ylabel('Y');

   
    subplot(2,3,6);
    plot(n, mean(Y,1));
    title('Mean\{Y(n)\}');
    xlabel('n'); ylabel('E\{Y\}');
end
