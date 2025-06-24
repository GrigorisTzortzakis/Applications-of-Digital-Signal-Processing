clear; clc;

% Fixed parameters
N       = 100;         % number of realizations
M_full  = 50;          % full vector length
A       = 3/sqrt(2);   % amplitude
omega   = pi/5;        % signal frequency
Ms      = [2, 10, 20, 30, 50];


sigma2_list = [0.1, 1.0];

for sIdx = 1:length(sigma2_list)
    sigma2 = sigma2_list(sIdx);
    
    %  Generate the N realizations for this noise level 
    X = zeros(N, M_full);
    for i = 1:N
        phi = (2*rand - 1)*pi;
        n   = 0:(M_full-1);
        s   = A * exp(1j*(omega*n + phi));
        w   = sqrt(sigma2/2)*(randn(1,M_full) + 1j*randn(1,M_full));
        X(i,:) = s + w;
    end
    
    %  Estimate and center 
    mu_hat   = mean(X,1);
    Xc       = X - mu_hat;
    
    %  Full autocorrelation 
    Rxx_full = (Xc.' * conj(Xc)) / N;
    
    fprintf(' Noise σ² = %.2f ===\n', sigma2);
    
    %  For each M sub‑matrix, compute histograms & moments of noise‐eigs 
    for m = Ms
        Rm        = Rxx_full(1:m,1:m);
        lambda    = sort(real(eig(Rm)), 'descend');
        noiseEigs = lambda(2:end);           % λ₂…λ_M
        
        % Estimate σ²_W
        sigma2_w = mean(noiseEigs);
        
        % Plot PDF histogram
        figure;
        histogram(noiseEigs, 'Normalization', 'pdf');
        title(sprintf('Noise‐Eigenvalue PDF (M=%d, σ²=%.2f)', m, sigma2));
        xlabel('\lambda'); ylabel('PDF');
        
        % Central moments
        mu1 = mean(noiseEigs);
        m1  = mean(noiseEigs - mu1);             
        m2  = mean((noiseEigs - mu1).^2);         
        
        fprintf(' M=%2d:  est σ²_W = %.4f,  1st cm = %.2e,  2nd cm = %.2e\n', ...
                m, sigma2_w, m1, m2);
    end
end
