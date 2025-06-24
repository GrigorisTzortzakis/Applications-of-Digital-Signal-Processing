
clear; clc;


load('question8_realizations.mat','X');


N = size(X,1);
Rxx_full = (1/N) * (X') * conj(X);


Rxx2  = Rxx_full(1:2,  1:2);
Rxx10 = Rxx_full(1:10, 1:10);
Rxx20 = Rxx_full(1:20, 1:20);
Rxx30 = Rxx_full(1:30, 1:30);
Rxx50 = Rxx_full(1:50, 1:50);

save('Rxx_submatrices.mat','Rxx2','Rxx10','Rxx20','Rxx30','Rxx50');
