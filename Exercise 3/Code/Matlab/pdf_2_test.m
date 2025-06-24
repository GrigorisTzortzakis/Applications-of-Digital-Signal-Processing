clear; close all; clc

%%   constants  
patchSize = 8;                  % 8×8 patch
T0        = 10;                 % sparsity
err       = 1e-4;               % ‖r‖₂ threshold in OMP
scaleF    = 0.25;               % down‑sampling
stride    = patchSize;          % non‑overlapping
SNRlist   = [0 20 50 100];      % dB
missing   = 0.50;               % 50% inpainting mask
rng('default')

%%  load dictionary / test list  
load D_trained.mat    % D : 64×100
testDir   = fullfile(pwd,'dataset','test');
test_list = dir(fullfile(testDir,'*.jpg'));

%%    denoising 
fprintf('===== DENOISING =====\n')
MSEden = zeros(numel(test_list), numel(SNRlist));

for imIdx = 1:numel(test_list)
    name = test_list(imIdx).name;
    I0   = imresize( ...
              rgb2gray(im2double(imread(fullfile(testDir,name)))), ...
              scaleF);
    [H,W] = size(I0);
    rows  = 1:stride:H-patchSize+1;
    cols  = 1:stride:W-patchSize+1;

    noisyImgs = cell(1,numel(SNRlist));
    recImgs   = cell(1,numel(SNRlist));

    for s = 1:numel(SNRlist)
        snrTarget = SNRlist(s);
        Psignal   = mean(I0(:).^2);
        Pnoise    = Psignal/10^(snrTarget/10);
        noisy     = I0 + sqrt(Pnoise)*randn(size(I0));

        Irec = zeros(H,W);
        for r = rows
            for c = cols
                v   = noisy(r:r+patchSize-1, c:c+patchSize-1);
                v   = v(:);
                nrm = norm(v); if nrm<1e-8, nrm=1; end
                x   = GenOMP(D, v/nrm, T0, err);          % 100×1
                patchRec = reshape(D*x * nrm, patchSize, patchSize);
                Irec(r:r+patchSize-1, c:c+patchSize-1) = patchRec;
            end
        end

        MSEden(imIdx,s)   = mean((I0(:)-Irec(:)).^2);
        noisyImgs{s}      = noisy;
        recImgs{s}        = Irec;
    end

    
    figure('Name',['Denoising: ' name],'NumberTitle','off');
    for s = 1:numel(SNRlist)
      row = s;
      subplot(numel(SNRlist),3,(row-1)*3 + 1)
        imshow(I0,[]),    title(sprintf('Orig @ %ddB', SNRlist(s)))
      subplot(numel(SNRlist),3,(row-1)*3 + 2)
        imshow(noisyImgs{s},[]), title('Noisy')
      subplot(numel(SNRlist),3,(row-1)*3 + 3)
        imshow(recImgs{s},[]),   title('Denoised')
    end
end

%%   inpainting 
fprintf('===== INPAINTING =====\n')
MSEinp = zeros(numel(test_list), numel(SNRlist));

for imIdx = 1:numel(test_list)
    name = test_list(imIdx).name;
    I0   = imresize( ...
              rgb2gray(im2double(imread(fullfile(testDir,name)))), ...
              scaleF);
    [H,W] = size(I0);
    rows  = 1:stride:H-patchSize+1;
    cols  = 1:stride:W-patchSize+1;

    maskedImgs = cell(1,numel(SNRlist));
    recImgs2   = cell(1,numel(SNRlist));

    for s = 1:numel(SNRlist)
        Psignal   = mean(I0(:).^2);
        Pnoise    = Psignal/10^(SNRlist(s)/10);
        IwithGaps = I0 + sqrt(Pnoise)*randn(size(I0));
        mask      = rand(size(I0)) > missing;
        IwithGaps(~mask) = 0;

        Irec = zeros(H,W);
        for r = rows
            for c = cols
                patch = IwithGaps(r:r+patchSize-1, c:c+patchSize-1);
                omega = mask(  r:r+patchSize-1, c:c+patchSize-1);
                vec   = patch(:);
                msk   = omega(:);

                if all(msk==0)
                    fullPatch = patch;
                else
                    ysub = vec(msk);
                    nrm  = norm(ysub); if nrm<1e-8, nrm=1; end
                    x    = GenOMP(D(msk,:), ysub/nrm, T0, err);
                    fullPatch = reshape(D*x * nrm, patchSize, patchSize);
                end
                Irec(r:r+patchSize-1, c:c+patchSize-1) = fullPatch;
            end
        end

        MSEinp(imIdx,s)   = mean((I0(:)-Irec(:)).^2);
        maskedImgs{s}     = IwithGaps;
        recImgs2{s}       = Irec;
    end

   
    figure('Name',['Inpainting: ' name],'NumberTitle','off');
    for s = 1:numel(SNRlist)
      row = s;
      subplot(numel(SNRlist),3,(row-1)*3 + 1)
        imshow(I0,[]),    title(sprintf('Orig @ %ddB', SNRlist(s)))
      subplot(numel(SNRlist),3,(row-1)*3 + 2)
        imshow(maskedImgs{s},[]), title('Masked + noise')
      subplot(numel(SNRlist),3,(row-1)*3 + 3)
        imshow(recImgs2{s},[]),   title('Recovered')
    end
end

%%  Print MSE 
fprintf('\nMSE Denoising (rows=images / cols=SNR[dB]):\n')
denTable = array2table(MSEden, 'VariableNames', compose('dB_%d',SNRlist), ...
                       'RowNames',{test_list.name});
disp(denTable)

fprintf('\nMSE Inpainting (rows=images / cols=SNR[dB]):\n')
inpTable = array2table(MSEinp, 'VariableNames', compose('dB_%d',SNRlist), ...
                       'RowNames',{test_list.name});
disp(inpTable)



figure('Name','Denoising MSE vs SNR','NumberTitle','off');
plot(SNRlist, MSEden','-o','LineWidth',1.5)
xlabel('SNR (dB)'), ylabel('MSE')
title('Denoising: MSE per Image')
legend(test_list.name, 'Interpreter','none','Location','best')
grid on


figure('Name','Inpainting MSE vs SNR','NumberTitle','off');
plot(SNRlist, MSEinp','-o','LineWidth',1.5)
xlabel('SNR (dB)'), ylabel('MSE')
title('Inpainting: MSE per Image')
legend(test_list.name, 'Interpreter','none','Location','best')
grid on
