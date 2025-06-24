

clear; clc; close all;

%   autocorrelation matrix Rxx (3×3)
Rxx = [ 6,                1.92705 - 1j*4.58522,  -3.42705 - 1j*3.49541;
        1.92705 + 1j*4.58522, 6,                1.92705 - 1j*4.58522;
       -3.42705 + 1j*3.49541,  1.92705 + 1j*4.58522, 6               ];

%  Eigendecomposition 
[V,D] = eig(Rxx);
[~, idx] = sort(diag(D));
u_noise = V(:, idx(1));    

%  Build polynomial P(z) 
p = flipud(u_noise);       % coefficient vector [u3(1); u3(2); u3(3)]

%  Frequency grid 
Nw    = 1024;
omega = linspace(0, 2*pi, Nw);

%  Evaluate
z      = exp(1j*omega);
P_eval = polyval(p, z);
P_inv  = 1 ./ (abs(P_eval).^2);


figure;
plot(omega, P_inv, 'LineWidth', 1.5);
xlabel('\omega (rad/sample)');
ylabel('P_{inv}(e^{j\omega})');
title('Q6: P_{inv}(e^{j\omega}) = 1 / |P(e^{j\omega})|^2');
grid on;
xlim([0 2*pi]);
xticks(0:pi/4:2*pi);
xticklabels({'0','\pi/4','\pi/2','3\pi/4','\pi','5\pi/4','3\pi/2','7\pi/4','2\pi'});
