

% Load the 3-D video array
S = load('boostrap.mat','video');
if ~isfield(S,'video') || ndims(S.video)~=3
    error('boostrap.mat does not contain a 3-D numeric ''video'' array.');
end
vid = S.video;   % H×W×T


player = implay(vid,15);


pause(0.2);


scr = get(0,'ScreenSize');            
set(player.Parent, 'Position', scr);
