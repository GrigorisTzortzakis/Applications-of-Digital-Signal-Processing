
Ms    = [2, 10, 20, 30, 40, 50];
omega = linspace(-pi, pi, 1000);    % frequency grid
nW    = length(omega);

for ii = 1:length(Ms)
    M   = Ms(ii);
  
    Rxx = Rxx_full(1:M, 1:M);       

    % eigen-decomposition, sort eigenvalues descending
    [V, D]   = eig(Rxx);
    [~, ord] = sort(diag(D), 'descend');
    V        = V(:, ord);

    figure; hold on
    for m = 2:M
        nm = V(:, m);              

     
        E  = exp(-1j*(0:M-1)' * omega);  

        Pm = E' * nm;              

        % pseudo-spectrum
        Qm = 1 ./ abs(Pm).^2;       
        plot(omega, Qm)
    end

    title(sprintf('Q_{M,m}(e^{j\\omega}) for M = %d', M))
    xlabel('\omega (rad)')
    ylabel('1 / |P_{M,m}(e^{j\omega})|^2')
    xlim([-pi pi])
    grid on
    hold off
end
