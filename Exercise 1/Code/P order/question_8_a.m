

clearvars; close all; clc;

%% Parameters
P        = 5;            % Number of exponentials
M        = 50;           % Samples per realization
N        = 100;          % Number of Monte Carlo runs
sigma2_W = 0.75;         % Noise variance
n        = 0:(M-1);      % Time index
rng(12345);              % For reproducibility

% Frequency sets 
freqSets = { ...
    [0.2, 0.4, 0.5, 0.75, 0.88], ...  % Original
    [0.1, 0.25, 0.5, 0.65, 0.9], ...  % Widely spaced
    [0.3, 0.33, 0.36, 0.39, 0.42]     % Closely spaced
};
setLabels = {'Original','Wide','Close'};
numSets   = numel(freqSets);

% Frequency grid for MUSIC/EV spectra
w_grid = linspace(-pi, pi, 2048).';

% Preallocate RMSE storage
methods = {'Root','MUSIC','EV'};
RMSE = zeros(numSets, numel(methods));

for s = 1:numSets
    trueOmegas = sort(freqSets{s} * pi);  % 1×P
    errRoot  = zeros(N, P);
    errMUSIC = zeros(N, P);
    errEV    = zeros(N, P);
    
    for k = 1:N
        %%  Generate one realization X
        phi = -pi + 2*pi*rand(1,P);
        A   = (1 ./ 2.^(0:P-1)) .* exp(1j*phi);
        S   = zeros(1, M);
        for i = 1:P
            S = S + A(i)*exp(1j*trueOmegas(i)*n);
        end
        W = sqrt(sigma2_W)*randn(1,M);
        X = S + W;
        
        %%  Estimate autocorrelation matrix (single snapshot)
        Rxx = X.' * conj(X);
        
        %%  Eigen-decomposition
        [V, D] = eig(Rxx);
        [lambda, idx] = sort(real(diag(D)),'descend');
        V = V(:, idx);
        U_noise = V(:, P+1:end);
        noise_eigs = lambda(P+1:end);
        
        %% Root-finding estimator
        pcoef = flipud(U_noise(:,1));
        rts   = roots(pcoef);
        if numel(rts) > 1
            labels = kmeans([real(rts), imag(rts)], 2, 'Replicates', 5);
            centers = arrayfun(@(c) mean(abs(rts(labels==c))),1:2);
            [~,bc] = min(abs(centers - 1));
            sig_r  = rts(labels==bc);
            [~,ir] = min(abs(abs(sig_r)-1));
            sel_roots = sig_r(ir);
        else
            sel_roots = rts;
        end
        % Pick the P roots nearest |z|=1
        [~, sortIdxR] = sort(abs(abs(rts)-1));
        estRoots = angle(rts(sortIdxR(1:P)));  % P×1
        estRoots = sort(estRoots).';           % 1×P
        errRoot(k,:) = abs((estRoots - trueOmegas) / pi);
        
        %% MUSIC estimator
        E = exp(-1j*(0:M-1).' * w_grid.');  % M×2048
        Psum = zeros(length(w_grid),1);
        for m = 1:(M-P)
            Pm = E' * U_noise(:,m);         % 2048×1
            Psum = Psum + abs(Pm).^2;       % 2048×1
        end
        Qm = 1 ./ Psum;                     % 2048×1
        [~, locs] = findpeaks(Qm, 'NPeaks', P, 'SortStr', 'descend');
        estMUSIC = sort(w_grid(locs)).';    % 1×P
        errMUSIC(k,:) = abs((estMUSIC - trueOmegas) / pi);
        
        %% EV estimator
        weights = 1 ./ noise_eigs;          % (M-P)×1
        Psum_ev = zeros(length(w_grid),1);
        for m = 1:(M-P)
            Pm = E' * U_noise(:,m);
            Psum_ev = Psum_ev + weights(m)*abs(Pm).^2;
        end
        Qev = 1 ./ Psum_ev;                 % 2048×1
        [~, locs2] = findpeaks(Qev, 'NPeaks', P, 'SortStr', 'descend');
        estEV = sort(w_grid(locs2)).';
        errEV(k,:) = abs((estEV - trueOmegas) / pi);
    end
    
    % Compute RMSE for each method
    RMSE(s,1) = sqrt(mean(errRoot(:).^2));
    RMSE(s,2) = sqrt(mean(errMUSIC(:).^2));
    RMSE(s,3) = sqrt(mean(errEV(:).^2));
end

%% Display results
fprintf('RMSE (normalized to π) for each method and frequency set:\n');
T = array2table(RMSE, 'VariableNames', methods, 'RowNames', setLabels)
