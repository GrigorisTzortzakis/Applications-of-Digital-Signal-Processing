
files    = {'boostrap.mat','campus.mat','lobby.mat'};
nFrames  = 800;
keepRank = 3;
fps      = 15;

for i = 1:numel(files)
    fname = files{i};
    fprintf('\n=== %s: first %d frames, rank-%d approx ===\n', fname, nFrames, keepRank);

    % Load the  video 
    S = load(fname,'video');
    if ~isfield(S,'video') || ndims(S.video)~=3
        warning('%s has no 3-D ''video'' array – skipping.', fname);
        continue
    end
    vid = S.video;            % H × W × T
    [H, W, T] = size(vid);

    %  Truncate 
    nF = min(nFrames, T);
    vid800 = vid(:,:,1:nF);   

    %  Form  matrix X 
    N = H*W;
    X = reshape(vid800, N, nF)';  

    %  Compute  SVD
    [U, Smat, V] = svd(X, 'econ');   
    r = size(Smat,1);

    
    S2 = Smat;
    if keepRank < r
        S2(keepRank+1:end, keepRank+1:end) = 0;
    end

    %  Reconstruct 
    Xk = U * S2 * V';               

    %  Reshape 
    vidk = reshape(Xk', H, W, nF);

   
    fprintf('Playing %s (rank-%d approx)...\n', fname, keepRank);
    player = implay(vidk, fps);
    pause(0.2);
    set(player.Parent, 'Position', get(0,'ScreenSize'));
end
