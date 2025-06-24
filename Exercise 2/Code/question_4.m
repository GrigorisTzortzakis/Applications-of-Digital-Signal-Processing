
%  Load the data
data = load('U.mat');       
U = data.U;                 

%  Center the data 
[M, K] = size(U);
U_mean = mean(U, 2);       
U_zero = U - U_mean;        

%  Compute eigenvalues 

[~, S, ~] = svd(U_zero, 'econ');
lambda = diag(S).^2 / K;    % eigenvalues of CUU

%  Compute total signal energy
total_energy = sum(lambda);

% Compute relative error 
P_max = length(lambda);
relative_error = zeros(P_max,1);
for P = 1:P_max
    relative_error(P) = sum(lambda(P+1:end)) / total_energy;
end


figure;
plot(1:P_max, relative_error, 'LineWidth', 2);
xlabel('Number of Components P');
ylabel('Relative Transmission Error \epsilon(P)');
title('Relative Transmission Error vs P (Noiseless Channel)');
grid on;
