
%  Set the matrix dimension
M = 50;


A = randn(M) + 1j * randn(M);
Rxx = (A * A') / M;

% Perform eigen-decomposition of Rxx
[V, D] = eig(Rxx);

%  Sort eigenvalues in descending order (largest first)
[~, idx] = sort(diag(D), 'descend');
V = V(:, idx);
D = D(idx, idx);

%  Extract noise-subspace eigenvectors 
noiseVecs = V(:, 2:M);

% Create a frequency grid 
numFreqs = 1000;
omega = linspace(0, 2*pi, numFreqs);

% Compute each trigonometric polynomial
P = zeros(M-1, numFreqs);
for mIndex = 1:(M-1)
    nm = noiseVecs(:, mIndex);         
    for k = 1:numFreqs
        w = omega(k);
        steering = exp(-1j * (0:(M-1))' * w);  
        P(mIndex, k) = steering' * nm;        
    end
end


figure;
plot(omega, abs(P(1, :)));
xlabel('\omega (rad)');
ylabel('|P^{(M,2)}(e^{j\omega})|');
title('Trigonometric Polynomial P^{(M,2)}');
grid on;
