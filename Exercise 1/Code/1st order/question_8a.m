clear; clc;

% Parameters
N       = 100;         % number of realizations
M       = 50;          % length of each realization
A       = 3/sqrt(2);   % amplitude factor
omega   = pi/5;        % signal frequency

% Two different noise variances 
sigma2_list = [0.1, 1.0];


figure; hold on; grid on;
xlabel('n'); ylabel('\mu(n)');
title('Estimated Ensemble Mean of X(n) for Two Noise Powers');

for k = 1:length(sigma2_list)
    sigma2 = sigma2_list(k);

    % Generate realizations
    X = zeros(N, M);
    for i = 1:N
        phi = (2*rand - 1)*pi;     % random phase 
        n   = 0:(M-1);
        s   = A * exp(1j*(omega*n + phi));
        w   = sqrt(sigma2/2)*(randn(1,M) + 1j*randn(1,M));
        X(i,:) = s + w;
    end

    % Estimate ensemble mean 
    mu_hat = mean(X, 1);  
   
    plot(0:M-1, real(mu_hat), 'o-',  'DisplayName', sprintf('Re\\{\\mu\\}, \\sigma^2=%.1f', sigma2));
    plot(0:M-1, imag(mu_hat), 's--', 'DisplayName', sprintf('Im\\{\\mu\\}, \\sigma^2=%.1f', sigma2));
end

