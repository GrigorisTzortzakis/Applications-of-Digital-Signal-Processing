

clearvars; close all; clc;

% Load the five Rxx submatrices
load('Rxx_submatrices.mat','Rxx2','Rxx10','Rxx20','Rxx30','Rxx50');

M_list = [2,10,20,30,50];
R_list = {Rxx2, Rxx10, Rxx20, Rxx30, Rxx50};
w      = linspace(-pi,pi,1024);

for idx = 1:numel(M_list)
    M   = M_list(idx);
    Rxx = R_list{idx};

    %% 7.1 Eigen-decomposition
    [V,D]       = eig(Rxx);
    [lambda,si] = sort(real(diag(D)),'descend');
    V           = V(:,si);
    U_noise     = V(:,2:end);

    %% 7.2 Noise variance & histogram
    noise_eigs = real(lambda(2:end));
    sigma2_est = mean(noise_eigs);
    figure; histogram(noise_eigs,20);
    title(sprintf('M=%d: Noise eigenvalues',M));
    xlabel('Eigenvalue'); ylabel('Count');
    mu1 = mean(noise_eigs - sigma2_est);
    mu2 = mean((noise_eigs - sigma2_est).^2);
    fprintf('M=%2d | σ²≈%.4f | μ1=%.4e | μ2=%.4e\n',M,sigma2_est,mu1,mu2);

    %% 7.3 Estimate |A|
    A_est = sqrt((lambda(1) - sigma2_est)/M);
    fprintf('M=%2d | |A|≈%.4f\n\n',M,A_est);

    %% 7.4 
    E  = exp(-1j*(0:M-1).' * w);    % M×length(w)
    Pm = zeros(M-1, numel(w));
    for m = 1:(M-1)
        Pm(m,:) = (E' * U_noise(:,m)).';
    end

    %% 7.5 Root-finding + conditional kmeans
    p_coef = flipud(U_noise(:,1));
    rts    = roots(p_coef);
    if numel(rts) > 1
        Xdata  = [real(rts), imag(rts)];
        labels = kmeans(Xdata, 2, 'Replicates', 5);
        centers= arrayfun(@(c) mean(abs(rts(labels==c))),1:2);
        [~,bc] = min(abs(centers - 1));
        sig_r  = rts(labels==bc);
        [~,ir] = min(abs(abs(sig_r)-1));
        w_est  = angle(sig_r(ir));
    else
        w_est = angle(rts);
    end
    fprintf('M=%2d | ω≈%.4f rad\n\n',M,w_est);

    %% 7.6 
    figure; hold on;
    for m = 1:(M-1)
        plot(w, 1./abs(Pm(m,:)).^2);
    end
    title(sprintf('M=%d: Q_{M,m}(e^{jω})',M));
    xlabel('ω [rad]'); ylabel('Q'); hold off;

    %% 7.7 MUSIC spectrum
    figure;
    Q_MUSIC = 1 ./ sum(abs(Pm).^2,1);
    plot(w, 10*log10(Q_MUSIC));
    title(sprintf('M=%d: MUSIC',M));
    xlabel('ω [rad]'); ylabel('Magnitude (dB)');

    %% 7.8 EV spectrum
    figure;
    weights = 1 ./ noise_eigs;
    Q_EV = 1 ./ (weights.' * abs(Pm).^2);
    plot(w, 10*log10(Q_EV));
    title(sprintf('M=%d: EV',M));
    xlabel('ω [rad]'); ylabel('Magnitude (dB)');
end

fprintf('Completed steps 7.1–7.8 for all M values.\n');
