clear; close all; clc;
rootDir   = pwd;
trainDir  = fullfile(rootDir,'dataset','train');
testDir   = fullfile(rootDir,'dataset','test');

%% Parameters
patchSize = 8;            % 8×8 
numAtoms  = 100;          % K
T0        = 10;           % sparsity
err       = 1e-4;         % error
numEpochs = 100;          % epochs
scaleF    = 0.25;         % down-sampling
stride    = 16;           % sample
rng('default');

%% Training set
train_list = dir(fullfile(trainDir,'*.jpg'));


tmp = imresize(rgb2gray(im2double( ...
      imread(fullfile(trainDir,train_list(1).name)))),scaleF);
[H,W]  = size(tmp);
maxPer = numel(1:stride:H-patchSize+1)*numel(1:stride:W-patchSize+1);
Y      = zeros(patchSize^2, maxPer*numel(train_list));

col = 1;
for k = 1:numel(train_list)
    img = imresize(rgb2gray(im2double( ...
          imread(fullfile(trainDir,train_list(k).name)))),scaleF);

    for r = 1:stride:H-patchSize+1
        for c = 1:stride:W-patchSize+1
            v = reshape(img(r:r+patchSize-1,c:c+patchSize-1),[],1);
            n = norm(v,2);
            if n<1e-8, continue, end
            Y(:,col) = v/n;  col = col+1;
        end
    end
end
Y = Y(:,1:col-1);                       

%% Start
D = randn(patchSize^2,numAtoms);  D = D./vecnorm(D);
X = zeros(numAtoms,size(Y,2));

%% Train dictionary
fprintf('Training dictionary…\n');
tic;
[MSE,D,X] = DictionaryLearning(D,Y,err,T0,numEpochs,X);
fprintf('Συνολικός χρόνος: %.1f sec\n',toc);

save('D_trained.mat','D');  save('MSE_vec.mat','MSE');

%% Error 
figure;
semilogy(1:numEpochs , MSE , 'LineWidth',1.4); grid on;
xlabel('epoch'); ylabel('log_{10}(‖Y-DX‖_F^2)');
title('Συνολικό σφάλμα ανά epoch');

%% See dictionary
rng('default');                      
D0 = randn(patchSize^2,numAtoms);  D0 = D0./vecnorm(D0);

figure('Name','Dictionary evolution');
subplot(1,2,1);
montage(reshape(D0,patchSize,patchSize,1,[]),'Size',[10 10]);
title('Initial dictionary');

subplot(1,2,2);
montage(reshape(D ,patchSize,patchSize,1,[]),'Size',[10 10]);
title('Trained dictionary');

%%  TESTING  
test_list = dir(fullfile(testDir,'*.jpg'));
fprintf('\nReconstruction MSE στο testing set:\n');

for k = 1:numel(test_list)
    Iorig = im2double(rgb2gray( ...
            imread(fullfile(testDir,test_list(k).name))));
    Iorig = imresize(Iorig,scaleF);
    [H,W] = size(Iorig);

    Irec  = zeros(H,W);
    rows  = 1:patchSize:(H-patchSize+1);      
    cols  = 1:patchSize:(W-patchSize+1);

    for r = rows
        for c = cols
            vec = reshape(Iorig(r:r+patchSize-1,c:c+patchSize-1),[],1);
            nrm = norm(vec,2);  if nrm<1e-8, nrm = 1; end
            coeff = GenOMP(D, vec/nrm, T0, err);       
            patchR = reshape(D*coeff,patchSize,patchSize)*nrm;
            Irec(r:r+patchSize-1,c:c+patchSize-1) = patchR;
        end
    end

    mse = mean((Iorig(:)-Irec(:)).^2);
    fprintf('  %-12s  %.5f\n',test_list(k).name,mse);

    
    figure('Name',test_list(k).name);
     subplot(1,2,1); imshow(Iorig,[]); title('Original');
     subplot(1,2,2); imshow(Irec ,[]); title('Reconstruction');
end