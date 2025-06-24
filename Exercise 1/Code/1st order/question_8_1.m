clear; clc;

% Fixed parameters
N       = 100;         % number of realizations
M       = 50;          % full matrix size
A       = 3/sqrt(2);   % amplitude
omega   = pi/5;        % signal frequency
Ms      = [2, 10, 20, 30, 50];

% Two noise powers 
sigma2_list = [0.1, 1.0];

for sIdx = 1:length(sigma2_list)
    sigma2 = sigma2_list(sIdx);
    
    %  Generate data 
    X = zeros(N, M);
    for i = 1:N
        phi = (2*rand-1)*pi;
        n   = 0:(M-1);
        s   = A * exp(1j*(omega*n + phi));
        w   = sqrt(sigma2/2)*(randn(1,M) + 1j*randn(1,M));
        X(i,:) = s + w;
    end
    
    % Estimate autocorrelation and extract sub-blocks 
    mu_hat   = mean(X, 1);
    Xc       = X - mu_hat;
    Rxx_full = (Xc.' * conj(Xc)) / N;
    for k = 1:numel(Ms)
        m         = Ms(k);
        Rxx_sub{k} = Rxx_full(1:m, 1:m);
    end
    
    fprintf(' Results for \\sigma^2 = %.2f ====\n', sigma2);
    
    %  Eigen-decomposition on each sub-block 
    for k = 1:numel(Ms)
        m  = Ms(k);
        Rm = Rxx_sub{k};
        
        [V,D]    = eig(Rm);
        [lambda, idx] = sort(real(diag(D)), 'descend');
        V        = V(:, idx);
        
        fprintf('\nM = %2d\n', m);
        fprintf('  λ = [ %s]\n', sprintf('%.4f ', lambda));
        
        % steering (signal) eigenvector
        fprintf('  e%d = [', m);
        for i = 1:m
            fprintf(' %.4f%+.4fj', real(V(i,1)), imag(V(i,1)));
        end
        fprintf(' ]''\n');
        
        % noise subspace dimension
        fprintf('  Noise subspace n%d is %d×%d  (cols 2…%d)\n', m, m, m-1, m);
    end
end
