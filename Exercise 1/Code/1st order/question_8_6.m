clear; clc;

% Fixed parameters
N            = 100;         % number of realizations
Mfull        = 50;          % full process length
A            = 3/sqrt(2);   % signal amplitude
omega0       = pi/5;        % signal frequency
Ms           = [2, 10, 20, 30, 40, 50];
omega        = linspace(-pi, pi, 1000);   % frequency grid
sigma2_list  = [0.1, 1.0];   

% Pre‑generate random phases
phi = 2*pi*rand(1,N) - pi;

for sIdx = 1:length(sigma2_list)
    sigma2 = sigma2_list(sIdx);
    
    %  Generate N realizations under this noise level 
    X = zeros(N, Mfull);
    for k = 1:N
        signal = A * exp(1j*(omega0 * (0:Mfull-1) + phi(k)));
        noise  = sqrt(sigma2/2)*(randn(1,Mfull) + 1j*randn(1,Mfull));
        X(k,:) = signal + noise;
    end
    
    %  Estimate full autocorrelation matrix 
    X0       = X - mean(X,1);
    Rxx_full = (X0' * conj(X0)) / N;
    
    %  Loop over each M and plot Q
    for ii = 1:length(Ms)
        M   = Ms(ii);
        Rxx = Rxx_full(1:M,1:M);
        
        % eigendecompose & sort
        [V,D]   = eig(Rxx);
        [~,ord]= sort(real(diag(D)),'descend');
        V       = V(:,ord);
        
        figure; hold on;
        for m = 2:M
            nm = V(:,m);   
            
            % steering matrix
            E = exp(-1j*(0:M-1)' * omega);
            
            Pm= E' * nm;              
            Qm= 1 ./ abs(Pm).^2;      
            
            plot(omega, Qm, 'LineWidth',1);
        end
        hold off;
        grid on;
        xlim([-pi pi]);
        xlabel('\omega (rad)');
        ylabel('Q_{M,m}(e^{j\omega}) = 1/|P|^2');
        title(sprintf('Q_{M,m}(e^{j\\omega}), M=%d, \\sigma^2=%.1f', M, sigma2));
    end
end
