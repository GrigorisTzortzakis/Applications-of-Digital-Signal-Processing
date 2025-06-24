
clear; clc;

%  Load 
load('U.mat');    % expects variable U of size [10000 × 100]

% Center each realization
Uc = U - mean(U, 2);    % subtract the mean of each row 

%  Estimate the covariance
K = size(Uc, 2);
C_UU = (Uc * Uc.') / K;  

fprintf('Computed C_UU has size %d × %d\n\n', size(C_UU));

disp('--- Top-left 5×5 block of C_UU ---');
disp(C_UU(1:5,1:5));



