
% Parameters
nFrames   = 800;
keepRank  = 10;
fps       = 15;

% 1) Load the video
S = load('boostrap.mat','video');
if ~isfield(S,'video') || ndims(S.video)~=3
    error('boostrap.mat must contain a 3-D numeric ''video'' array.');
end
vid = S.video;               % H×W×T
[H,W,T] = size(vid);

%  first 800 frames
nF = min(nFrames, T);
vid800 = vid(:,:,1:nF);      

%  Form data matrix X 
N = H*W;
X = reshape(vid800, N, nF)'; 

%  Compute  SVD
[U,Smat,V] = svd(X, 'econ');  % U: nF×r, Smat: r×r, V: N×r

%  Zero out all but top 10 singular values
r = size(Smat,1);
S2 = Smat;
if keepRank < r
    S2(keepRank+1:end, keepRank+1:end) = 0;
end

% 6) Reconstruct 
X10   = U * S2 * V';         
vid10 = reshape(X10', H, W, nF);


fprintf('Playing boostrap rank-%d approx (first %d frames)...\n', keepRank, nF);
player = implay(vid10, fps);
pause(0.2); 
set(player.Parent, 'Position', get(0,'ScreenSize'));
