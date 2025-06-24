

clear; clc;

% Parameters
N       = 100;         % number of realizations
M_full  = 50;          % full record length
sigma2W = 0.5;         % noise variance
phi     = 2*pi*rand(N,1) - pi;  % random phases 
n       = 0:(M_full-1);         
omega   = linspace(-pi, pi, 1000);
Ms      = [2, 10, 20, 30, 50];

% Generate N realizations of length M_full
X = zeros(N, M_full);
for k = 1:N
    
    s = (3/sqrt(2)) * exp(1j*(pi/5 * n + phi(k)));
    w = sqrt(sigma2W) * randn(1, M_full);  
    X(k,:) = s + w;
end

% Estimate covariance matrix Rxx_

Rxx_full = (1/N) * (X' * X);

% Loop over M and compute Q
for ii = 1:length(Ms)
    M   = Ms(ii);
    Rxx = Rxx_full(1:M,1:M);              

    % eigen‑decomposition and sort descending
    [V,D]    = eig(Rxx);
    [lams,idx] = sort(diag(D), 'descend');
    V        = V(:,idx);
    lams     = lams(idx);

    % build steering matrix E 
    E = exp(-1j*(0:M-1)' * omega);

    % accumulate weighted noise power
    Qsum = zeros(1, length(omega));
    for m = 2:M
        nm   = V(:, m);                
        Pm   = E' * nm;                
        Qsum = Qsum + (1/lams(m)) * abs(Pm).^2;
    end

    % EV pseudo‑spectrum
    Qev = 1 ./ Qsum;

    
    figure;
    plot(omega, real(Qev), 'LineWidth', 1.2);
    grid on; xlim([-pi pi]);
    title( sprintf('$Q_{\\mathrm{EV}}^{%d}(e^{j\\omega})$', M), ...
           'Interpreter','latex' );
    xlabel('$\omega\ (\mathrm{rad})$','Interpreter','latex');
    ylabel(['$\displaystyle \frac{1}{\sum_{m=2}^{M}\!\frac{1}{\lambda_m}\,' ...
            '\bigl|P_{M,m}(e^{j\omega})\bigr|^2}$'], ...
           'Interpreter','latex');
end
