
% Parameters
N = 100;        % number of realizations
M = 50;         % length of each realization
sigma2 = 0.5;   % noise variance
A = 3/sqrt(2);  % amplitude factor
omega = pi/5;   % signal frequency

% Preallocate
X = zeros(N, M);

% Generate realizations
for i = 1:N
    phi = (2*rand - 1)*pi;        % random phase 
    n = 0:(M-1);
    s = A * exp(1j*(omega*n + phi));    
    
    w = sqrt(sigma2/2)*(randn(1,M) + 1j*randn(1,M));
    X(i,:) = s + w;
end

% Estimate stochastic mean 
mu_hat = mean(X, 1);  % 1×M vector

figure;
plot(0:M-1, real(mu_hat), 'o-','DisplayName','Re\{\mu\}');
hold on;
plot(0:M-1, imag(mu_hat), 's-','DisplayName','Im\{\mu\}');
grid on;
xlabel('n'); ylabel('\mu(n)');
title('Estimated Ensemble Mean of X(n)');
legend;
