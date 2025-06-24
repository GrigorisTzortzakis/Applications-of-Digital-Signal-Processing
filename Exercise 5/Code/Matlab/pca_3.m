
files    = {'boostrap.mat','campus.mat','lobby.mat'};
nFrames  = 800;         
numPCs   = 3;           
fps      = 15;          

for i = 1:numel(files)
    fname = files{i};
    fprintf('\n=== %s: PCA reconstruct using top %d PCs on first %d frames ===\n', ...
            fname, numPCs, nFrames);

    %  Load video 
    S   = load(fname,'video');
    vid = S.video;                  
    [H,W,T] = size(vid);
    nF = min(nFrames,T);            

 
    %  Build data matrix  X  
    N  = H*W;                       
    X  = reshape(vid(:,:,1:nF), N, nF);   
    clear vid                       

    %  Mean-centre along pixels
    mu = mean(X,2);                 
    X0 = X - mu;                    


    %  PCA via SVD
    [pcs, S, ~] = svd(X0,'econ');    
    eigvals     = diag(S).^2 / (nF-1);

    % keep the top-numPCs columns
    pcs   = pcs(:,1:numPCs);        
    scores = pcs' * X0;             

   
    %  Reconstruct 
    Xk0 = pcs * scores;            
    Xk  = Xk0 + mu;                 

    
    %  Reshape 
    vid_rec = reshape(Xk, H, W, nF); % H × W × nF

  
    fprintf('Playing reconstructed %s...\n', fname);
    player = implay(vid_rec, fps);
    pause(0.2);
    set(player.Parent,'Position',get(0,'ScreenSize'));
end
