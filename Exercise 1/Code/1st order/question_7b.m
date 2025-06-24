

% parameters
N      = 100;         % number of realizations
M      = 50;          % length of each realization
sigma2 = 0.5;         % noise variance
A      = 3/sqrt(2);   % amplitude factor
omega  = pi/5;        % signal frequency


% Preallocate
X = zeros(N, M);

% Generate realizations
for i = 1:N
    phi    = (2*rand - 1)*pi;  % random phase 
    n      = 0:(M-1);
    s      = A * exp(1j*(omega*n + phi));               
    w      = sqrt(sigma2/2)*(randn(1,M) + 1j*randn(1,M));
    X(i,:) = s + w;
end

% Estimate stochastic mean 

Rxx = (X.' * conj(X)) / N;   % M×M matrix

figure;
subplot(1,2,1);
imagesc(real(Rxx));
axis square; colorbar;
title('Re\{R_{XX}\}');
xlabel('q'); ylabel('p');

subplot(1,2,2);
imagesc(imag(Rxx));
axis square; colorbar;
title('Im\{R_{XX}\}');
xlabel('q'); ylabel('p');
