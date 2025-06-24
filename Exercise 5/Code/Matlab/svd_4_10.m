
files      = {'boostrap.mat','campus.mat','lobby.mat'};
nTotal     = 800;   
blockSize  = 100;  
keepRank   = 10;    
fps        = 15;   
for i = 1:numel(files)
    fname = files{i};
    fprintf('\n=== %s: frames 1–%d, blocks of %d, rank-%d keep ===\n', ...
            fname, nTotal, blockSize, keepRank);

    %  Load video 
    S = load(fname,'video');
    if ~isfield(S,'video') || ndims(S.video)~=3
        warning('%s has no 3-D ''video'' array – skipping.', fname);
        continue
    end
    vidFull = S.video;          
    [H,W,T_full] = size(vidFull);
    
   
    nF = min(nTotal, T_full);
    vid    = vidFull(:,:,1:nF); 
    clear vidFull;
    
    %  Prepare reconstruction buffer
    vid_rec = zeros(H, W, nF, 'like', vid);
    
    %  Process in 100-frame blocks
    nBlocks = ceil(nF / blockSize);
    N = H*W;
    
    for b = 1:nBlocks
        i1 = (b-1)*blockSize + 1;
        i2 = min(b*blockSize, nF);
        nb = i2 - i1 + 1;        
        block = vid(:,:,i1:i2);           
        
        % Form data matrix X 
        X = reshape(block, N, nb)';       
        
        %  SVD
        [U,Smat,V] = svd(X, 'econ');      
        r = size(Smat,1);
        
     
        S2 = Smat;
        if keepRank < r
            S2(keepRank+1:end, keepRank+1:end) = 0;
        end
        
        % Reconstruct block
        Xk       = U * S2 * V';           
        block_k  = reshape(Xk', H, W, nb);
        
        
        vid_rec(:,:,i1:i2) = block_k;
    end
    
    fprintf('Playing reconstructed %s (frames 1–%d)...\n', fname, nF);
    player = implay(vid_rec, fps);
    pause(0.2);
    set(player.Parent, 'Position', get(0,'ScreenSize'));
end
