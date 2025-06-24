
% Load U.mat 
data = load('U.mat');
U = data.U;              
[M, N] = size(U);

% Compute eigen-decomposition 
[Q, S, ~] = svd(U, 'econ');  
lambda = diag(S).^2 / (N-1);   

%  Choose P 
P = 20;  

%  Compute noiseless 
U_hat = Q(:,1:P) * (Q(:,1:P)' * U);
rel_err_noiseless = mean( sum((U_hat - U).^2, 1) ./ sum(U.^2, 1) );

%  Define a range of SNRs 
SNR_dB = 30:-10:-30;        
numSNR = length(SNR_dB);
rel_err_snr = zeros(1, numSNR);

%  add AWGN to the compressed signal and measure error
for k = 1:numSNR
    snr_lin = 10^(SNR_dB(k)/10);
    err = zeros(1, N);
    for i = 1:N
        u_hat = U_hat(:,i);
        u    = U(:,i);
        signal_power = mean(u_hat.^2);
        sigma_w2 = signal_power / snr_lin;
        w = sqrt(sigma_w2) * randn(M,1);
        y = u_hat + w;
        err(i) = norm(y - u)^2 / norm(u)^2;
    end
    rel_err_snr(k) = mean(err);
end


figure;
conds = ["Noiseless", strcat(string(SNR_dB),' dB')];
plot(1:(numSNR+1), [rel_err_noiseless, rel_err_snr], '-o','LineWidth',1.5);
xticks(1:(numSNR+1));
xticklabels(conds);
xlabel('Channel condition');
ylabel('Relative transmission error');
title(sprintf('Relative Error vs. Channel (P = %d)', P));
grid on;
