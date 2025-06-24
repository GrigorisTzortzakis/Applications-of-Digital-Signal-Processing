% Parameters
nFrames   = 800;
keepRank  = 10;
fps       = 15;

% Load video
S = load('lobby.mat','video');
if ~isfield(S,'video') || ndims(S.video)~=3
    error('lobby.mat must contain a 3-D numeric ''video'' array.');
end
vid = S.video;
[H,W,T] = size(vid);

%  Truncate
nF = min(nFrames, T);
vid800 = vid(:,:,1:nF);

%  Build X
N = H*W;
X = reshape(vid800, N, nF)';

%  SVD
[U,Smat,V] = svd(X, 'econ');

%  Zero out
r = size(Smat,1);
S2 = Smat;
if keepRank < r
    S2(keepRank+1:end, keepRank+1:end) = 0;
end

%  Reconstruct and reshape
X10   = U * S2 * V';
vid10 = reshape(X10', H, W, nF);


fprintf('Playing lobby rank-%d approx (first %d frames)...\n', keepRank, nF);
player = implay(vid10, fps);
pause(0.2);
set(player.Parent, 'Position', get(0,'ScreenSize'));
