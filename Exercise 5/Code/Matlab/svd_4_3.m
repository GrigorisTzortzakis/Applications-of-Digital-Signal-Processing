
files      = {'boostrap.mat','campus.mat','lobby.mat'};
nTotal     = 800;        
blockSize  = 100;        
keepRank   = 3;          
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

    %  Trim to first nTotal frames 
    nF       = min(nTotal, T_full);
    vid      = vidFull(:,:,1:nF); 
    clear vidFull
    vid_rec  = zeros(H, W, nF, 'like', vid);

    % Process in blocks
    nBlocks  = ceil(nF / blockSize);
    N        = H * W;                     

    for b = 1:nBlocks
        i1    = (b-1)*blockSize + 1;
        i2    = min(b*blockSize, nF);
        nb    = i2 - i1 + 1;              
        block = vid(:,:,i1:i2);           

        % SVD on block 
        X      = reshape(block, N, nb)';  
        [U,S,V] = svd(X, 'econ');         

        % Zero out all but the first keepRank singular values
        S(keepRank+1:end, keepRank+1:end) = 0;

        % Reconstruct 
        Xk         = U * S * V';
        block_k    = reshape(Xk', H, W, nb);
        vid_rec(:,:,i1:i2) = block_k;
    end

    
    fprintf('Playing reconstructed %s (frames 1–%d, rank-%d)…\n', fname, nF, keepRank);
    player = implay(vid_rec, fps);
    pause(0.2);
    set(player.Parent, 'Position', get(0,'ScreenSize'));
end
