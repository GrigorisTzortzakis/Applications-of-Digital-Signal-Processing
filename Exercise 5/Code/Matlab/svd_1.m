% List of files 
files = {'boostrap.mat','campus.mat','lobby.mat'};

for i = 1:numel(files)
    fname = files{i};
    fprintf('\n=== Processing %s ===\n', fname);

    % Load  video array
    S = load(fname, 'video');
    if ~isfield(S,'video') || ~isnumeric(S.video) || ndims(S.video)~=3
        warning('  File %s does not contain a 3-D numeric ''video'' array. Skipping.', fname);
        continue
    end
    vid = S.video;               % H × W × T
    [H, W, T] = size(vid);
    N = H * W;

    % Reshape into X of size T × N
    X = reshape(vid, H*W, T)';   % now T × N

    % Compute the full SVD 
    [U, Sigma, V] = svd(X');

  
    fprintf('  Original video:   %d × %d × %d  →  X is %d × %d\n', H, W, T, size(X,1), size(X,2));
    fprintf('  U size:    %d × %d   (should be N × N = %d × %d)\n', size(U,1), size(U,2), N, N);
    fprintf('  Sigma size: %d × %d   (should be N × T = %d × %d)\n', size(Sigma,1), size(Sigma,2), N, T);
    fprintf('  V size:    %d × %d   (should be T × T = %d × %d)\n', size(V,1), size(V,2), T, T);
end
