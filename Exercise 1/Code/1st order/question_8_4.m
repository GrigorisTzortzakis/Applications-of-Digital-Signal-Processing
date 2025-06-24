clear; clc;

% Fixed parameters
N       = 100;         % number of realizations
M       = 50;          % signal length
A       = 3/sqrt(2);   % amplitude
omega0  = pi/5;        % signal frequency

% Two noise variances 
sigma2_list = [0.1, 1.0];

% Frequency grid
numFreqs = 1000;
omega    = linspace(0, 2*pi, numFreqs);

for sIdx = 1:length(sigma2_list)
    sigma2 = sigma2_list(sIdx);

    %  Generate data and estimate Rxx 
    X = zeros(N, M);
    for i = 1:N
        phi = (2*rand-1)*pi;
        n   = 0:(M-1);
        s   = A * exp(1j*(omega0*n + phi));
        w   = sqrt(sigma2/2)*(randn(1,M) + 1j*randn(1,M));
        X(i,:) = s + w;
    end
    mu_hat   = mean(X,1);
    Xc       = X - mu_hat;
    Rxx      = (Xc.' * conj(Xc)) / N;

    %  Eigen‐decompose and extract noise‐subspace 
    [V, D]   = eig(Rxx);
    [~, idx] = sort(real(diag(D)), 'descend');
    V        = V(:, idx);
    noiseVecs = V(:, 2:M);   % columns 2…M

    %  Compute trig‐polynomials P
    P = zeros(M-1, numFreqs);
    steering = exp(-1j*(0:(M-1))' * omega);   
    for mIndex = 1:(M-1)
        nm = noiseVecs(:, mIndex);            
        P(mIndex, :) = steering' * nm;        
    end

 
    figure;
    plot(omega, abs(P(1, :)), 'LineWidth', 1.2);
    grid on;
    xlabel('\omega (rad)');
    ylabel('|P^{(M,2)}(e^{j\omega})|');
    title(sprintf('Trig‑Poly P^{(M,2)} for \\sigma^2 = %.1f', sigma2));
end
