clear; clc;

%% Parameters
N      = 100;        % number of realizations
M      = 50;         % full length
sigma2 = 0.5;        % noise variance
A      = 3/sqrt(2);  % amplitude factor
omega  = pi/5;       % signal frequency

%% Generate N realizations of X(n)
X = zeros(N, M);
n = 0:(M-1);
for i = 1:N
    phi    = (2*rand - 1)*pi;                    
    s      = A * exp(1j*(omega*n + phi));       
    w      = sqrt(sigma2/2)*(randn(1,M) + 1j*randn(1,M)); 
    X(i,:) = s + w;                              
end

%% Estimate 50×50 autocorrelation matrix (Hermitian)
Rxx = (X' * X) / N;      

%% Extract exactly five M×M blocks for M = [2,10,20,30,50]
Ms = [2, 10, 20, 30, 50];
Rxx_sub = cell(size(Ms));
for k = 1:numel(Ms)
    m = Ms(k);
    Rxx_sub{k} = Rxx(1:m, 1:m);
    fprintf('Created Rxx_sub{%d} of size %dx%d\n', k, m, m);
end
