

Ms    = [2, 10, 20, 30, 50];          
omega = linspace(-pi, pi, 1000);     
nW    = length(omega);

for ii = 1:length(Ms)
    M   = Ms(ii);
    Rxx = Rxx_full(1:M, 1:M);        

    % eigen-decomposition and sort by descending eigenvalue
    [V, D]   = eig(Rxx);
    [~, ord] = sort(diag(D), 'descend');
    V        = V(:, ord);

    % build steering‐matrix once
    E    = exp(-1j*(0:M-1)' * omega);  % M×nW
    
    
    Qsum = zeros(1, nW);
    for m = 2:M
        nm   = V(:, m);               
        Pm   = E' * nm;               
        Qsum = Qsum + abs(Pm).^2;
    end

    % MUSIC pseudo‐spectrum
    Qmusic = 1 ./ Qsum;              

    
    figure;
    plot(omega, Qmusic, 'LineWidth', 1.2);
    title(...
      sprintf('$Q_{\\mathrm{MUSIC}}^{%d}(e^{j\\omega})$', M), ...
      'Interpreter', 'latex' ...
    );
    xlabel('$\omega\ (\mathrm{rad})$','Interpreter','latex');
    ylabel(...
      '$\displaystyle \frac{1}{\sum_{m=2}^{M}\bigl|P_{M,m}(e^{j\omega})\bigr|^2}$', ...
      'Interpreter', 'latex' ...
    );
    xlim([-pi pi]);
    grid on;
end
