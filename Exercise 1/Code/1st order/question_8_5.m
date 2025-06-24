clear; clc;

N           = 100;
Mfull       = 50;
n           = 0:(Mfull-1);
Ms          = [2, 10, 20, 30, 40, 50];
sigma2_list = [0.1, 1.0];

% Pre‑generate random phases
phi = 2*pi*rand(1,N) - pi;

for sIdx = 1:length(sigma2_list)
    sigma2 = sigma2_list(sIdx);

    % Generate data
    X = zeros(N, Mfull);
    for k = 1:N
        signal = (3/sqrt(2)) * exp(1j*(pi/5 * n + phi(k)));
        noise  = sqrt(sigma2/2)*(randn(1,Mfull) + 1j*randn(1,Mfull));
        X(k,:) = signal + noise;
    end

    %  Estimate autocorrelation
    x_mean   = mean(X, 1);
    X0       = X - x_mean;
    Rxx_full = (X0' * conj(X0)) / N;

    %  Loop over each M to estimate ω₁
    omega_est = nan(size(Ms));
    for ii = 1:length(Ms)
        M   = Ms(ii);
        Rxx = Rxx_full(1:M,1:M);

        [V,D]  = eig(Rxx);
        [~,ord] = sort(real(diag(D)), 'descend');
        V      = V(:,ord);

        thetas_all = [];
        for m = 2:M
            nm       = V(:,m).';               
            coeffs   = nm(end:-1:1);           
            roots_m  = roots(coeffs);          
            thetas_all = [thetas_all; angle(roots_m)];
        end

        % Handle too‑few‑roots case with if/else
        if isempty(thetas_all)
            omega_est(ii) = NaN;
            continue;
        elseif numel(thetas_all) < 2
            omega_est(ii) = thetas_all(1);
            continue;
        end

        %  K‑means clustering into 2 groups
        opts        = statset('MaxIter',1000);
        [groups,~]  = kmeans(thetas_all, 2, 'Replicates',10, 'Options',opts);
        v1          = var(thetas_all(groups==1));
        v2          = var(thetas_all(groups==2));

        % pick cluster with smaller variance
        if v1 < v2
            bestCluster = 1;
        else
            bestCluster = 2;
        end

        omega_est(ii) = mean(thetas_all(groups==bestCluster));
    end

    
    fprintf('\n--- Estimates of \\omega_1 for \\sigma^2 = %.2f ---\n', sigma2);
    T = table(Ms.', omega_est.', 'VariableNames', {'M', 'omega1_estimate'});
    disp(T);
end
