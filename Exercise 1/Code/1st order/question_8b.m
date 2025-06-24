clear; clc;

% parameters
N      = 100;         % number of realizations
M      = 50;          % length of each realization
A      = 3/sqrt(2);   % amplitude factor
omega  = pi/5;        % signal frequency

% Two noise variances 
sigma2_list = [0.1, 1.0];

% Prepare a 2×2 figure
figure;
for k = 1:length(sigma2_list)
    sigma2 = sigma2_list(k);

    % Generate realizations
    X = zeros(N, M);
    for i = 1:N
        phi    = (2*rand - 1)*pi;  % random phase 
        n      = 0:(M-1);
        s      = A * exp(1j*(omega*n + phi));               
        w      = sqrt(sigma2/2)*(randn(1,M) + 1j*randn(1,M));
        X(i,:) = s + w;
    end

    % Estimate autocorrelation matrix Rxx 
    Rxx = (X.' * conj(X)) / N;

    % Real part subplot
    subplot(2,2,(k-1)*2 + 1);
    imagesc(real(Rxx));
    axis square; colorbar;
    title(sprintf('Re\\{R_{XX}\\}, \\sigma^2=%.1f', sigma2));
    xlabel('q'); ylabel('p');

    % Imaginary part subplot
    subplot(2,2,(k-1)*2 + 2);
    imagesc(imag(Rxx));
    axis square; colorbar;
    title(sprintf('Im\\{R_{XX}\\}, \\sigma^2=%.1f', sigma2));
    xlabel('q'); ylabel('p');
end
