

% Generate N=100 realizations of length Mfull=50
N      = 100;
Mfull  = 50;
phi    = 2*pi*rand(1,N) - pi;
n      = 0:(Mfull-1);
X      = zeros(N, Mfull);
for k = 1:N
    X(k, :) = (3/sqrt(2)) * exp(1j*(pi/5 * n + phi(k))) ...
              + sqrt(0.5)*(randn(1,Mfull) + 1j*randn(1,Mfull));
end

% Estimate sample autocorrelation matrix (50×50)
x_mean   = mean(X, 1);
X0       = X - x_mean;
Rxx_full = (X0' * X0) / N;

% Submatrix sizes and storage
Ms        = [2, 10, 20, 30, 40, 50];
omega_est = zeros(size(Ms));

% Loop over each M
for ii = 1:length(Ms)
    M          = Ms(ii);
    Rxx        = Rxx_full(1:M, 1:M);
    [V,D]      = eig(Rxx);
    [~,ord]    = sort(diag(D), 'descend');
    V          = V(:, ord);

   
    thetas_all = [];
    for m = 2:M
        nm         = V(:, m).';        
        coeffs     = nm(end:-1:1);     
        z          = roots(coeffs);    
        thetas_all = [thetas_all; angle(z)];
    end

   
    if numel(thetas_all) < 2
        if isempty(thetas_all)
            omega_est(ii) = NaN;
        else
            omega_est(ii) = thetas_all(1);
        end
        continue;
    end

    % cluster into two groups
    opts       = statset('MaxIter', 1000);
    [groups,~] = kmeans(thetas_all, 2, 'Replicates', 10, 'Options', opts);

    % pick cluster with smaller variance
    v1 = var(thetas_all(groups==1));
    v2 = var(thetas_all(groups==2));
    if v1 < v2
        best = 1;
    else
        best = 2;
    end

    omega_est(ii) = mean(thetas_all(groups==best));
end


T = table(Ms.', omega_est.', 'VariableNames', {'M','omega1_estimate'});
disp(T);
