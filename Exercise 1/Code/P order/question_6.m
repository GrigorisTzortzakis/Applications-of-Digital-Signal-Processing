

clear; clc;

%  Define the given autocorrelation matrix Rxx (3×3)
Rxx = [ 6,                1.92705 - 1j*4.58522,  -3.42705 - 1j*3.49541;
        1.92705 + 1j*4.58522, 6,                1.92705 - 1j*4.58522;
       -3.42705 + 1j*3.49541,  1.92705 + 1j*4.58522, 6               ];

%  Eigendecomposition of Rxx
[V,D] = eig(Rxx);
[eigVals, idx] = sort(diag(D));    % sort eigenvalues ascending
sigma2_w = eigVals(1);             % smallest eigenvalue = noise variance
u_noise = V(:, idx(1));            % corresponding noise‐subspace eigenvector

%  Build polynomial p(z)
p = flipud(u_noise);               % yields [u3; u2; u1]
z_roots = roots(p);                % find its roots
omega_all = mod(angle(z_roots), 2*pi);  % two candidate frequencies

%  Extract rxx(0) and rxx(1)
r00 = real(Rxx(1,1));    % =6
r01 = Rxx(1,2);

%  Try both assignments of the two roots to ω1,ω2
pairs     = [1 2; 2 1];
best_err  = Inf;
best_x    = [];
best_w    = [];

for k = 1:2
    idx_perm = pairs(k,:);
    w1 = omega_all(idx_perm(1));
    w2 = omega_all(idx_perm(2));
    
    
    Mmat = [ 1,              1;
             exp(1j*w1), exp(1j*w2) ];
    bvec = [ r00 - sigma2_w;
             r01 ];
    x = Mmat \ bvec;   % x(1)=|A1|^2, x(2)=|A2|^2
    
    % Keep the solution with real positive x and minimal imaginary part
    err = norm(imag(x));
    if all(real(x) > 0) && err < best_err
        best_err = err;
        best_x   = real(x);
        best_w   = [w1; w2];
    end
end

% Compute amplitudes and pick the best ω
A1     = sqrt(best_x(1));
A2     = sqrt(best_x(2));
omega1 = best_w(1);
omega2 = best_w(2);


fprintf('White‑noise variance: sigma2_w = %.4f\n', sigma2_w);
fprintf('Signal freq. ω1 = %.4f rad/sample\n', omega1);
fprintf('Signal freq. ω2 = %.4f rad/sample\n', omega2);
fprintf('Amplitudes: |A1| = %.4f, |A2| = %.4f\n', A1, A2);
