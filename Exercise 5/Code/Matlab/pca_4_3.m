
files      = {'boostrap.mat','campus.mat','lobby.mat'};
nTotal     = 800;      
blockSize  = 100;       
keepRank   = 3;        
fps        = 15;        

for i = 1:numel(files)
    fname = files{i};
    fprintf('\n=== %s: frames 1–%d, blocks of %d, top-%d PCs kept ===\n', ...
            fname, nTotal, blockSize, keepRank);

    % Load video 
    S = load(fname,'video');
    if ~isfield(S,'video') || ndims(S.video)~=3
        warning('%s has no 3-D variable ''video'' – skipping.', fname);
        continue
    end
    vidFull = S.video;                     
    [H,W,T_full] = size(vidFull);

   
    nF  = min(nTotal, T_full);
    vid = vidFull(:,:,1:nF);               
    clear vidFull;

    % Pre-allocate reconstruction buffer 
    vid_rec = zeros(H, W, nF, 'like', vid);

   
    % Block-wise PCA
    nBlocks = ceil(nF / blockSize);
    N = H * W;                              

    for b = 1:nBlocks
        i1 = (b-1)*blockSize + 1;
        i2 = min(b*blockSize, nF);
        nb = i2 - i1 + 1;                 

        %  vectorise frames
        block = vid(:,:,i1:i2);             
        X     = reshape(block, N, nb)';     

        %  PCA via SVD 
        %  mean-centre across frames (columns)
        mu = mean(X, 1);                   
        X0 = X - mu;                        

        %  SVD of centred data  
        [U,Smat,V] = svd(X0, 'econ');       

        % zero out all but the first keepRank singular values
        if keepRank < size(Smat,1)
            Smat(keepRank+1:end, keepRank+1:end) = 0;
        end

        % reconstruct 
        Xk = U * Smat * V' + mu;            

        % reshape 
        block_k = cast(reshape(Xk', H, W, nb), 'like', vid_rec);
        vid_rec(:,:,i1:i2) = block_k;
    end

 
    fprintf('Playing reconstructed %s (frames 1–%d)...\n', fname, nF);
    player = implay(vid_rec, fps);
    pause(0.2);
    set(player.Parent, 'Position', get(0,'ScreenSize'));
end
