% ===== AOC2023 Day 18 [DayBlur] =====

%% Read file, line processing
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(strtrim(data));
N = length(lines);
cmds = ones(N,1);
dists = ones(N,1);
colors = ones(N,6);
for i=1:N
    line = lines{i};
    vals = sscanf(line, '%c %d (#%1x%1x%1x%1x%1x%1x)');
    cmds(i) = vals(1);
    dists(i) = vals(2);
    colors(i,:) = vals(3:8);
end

vdists = dists;
vdists(cmds=='U') = -vdists(cmds=='U');
vdists(cmds=='L'|cmds=='R') = 0;
hdists = dists;
hdists(cmds=='L') = -hdists(cmds=='L');
hdists(cmds=='U'|cmds=='D') = 0;

xlocs = cumsum([0;vdists]);
ylocs = cumsum([0;hdists]);
xlocs = xlocs - min(xlocs) + 2;
ylocs = ylocs - min(ylocs) + 2;

Nr = max(xlocs) + 1;
Nc = max(ylocs) + 1;

basemap = char('.'*ones(Nr,Nc));

%% Part 1
% clc;
tic
map = basemap;
pos = [xlocs(1), ylocs(1)];
for i=1:N+1
    newpos = [xlocs(i), ylocs(i)];
    mins = min([pos;newpos]);
    maxs = max([pos;newpos]);
    map(mins(1):maxs(1),mins(2):maxs(2)) = '#';
    pos = newpos;
end
bordermap = map;

out = [1,1];
while ~isempty(out)
    i = out(1,1);
    j = out(1,2);
    map(i,j) = 'o';
    out = out(2:end,:);
    xs = [i-1 i i i+1];
    ys = [j j-1 j+1 j ];
    for k=1:4
        if xs(k)<1 || xs(k)>Nr || ys(k)<1 || ys(k)>Nc % stay in bounds
            continue;
        end
        if map(xs(k),ys(k)) == '.'
            out(end+1,:) = [xs(k) ys(k)];
        end
    end
    out = unique(out,'rows');
end
part1 = sum(map=='.' | map=='#','all')
toc

%% Part 2
% clc;
tic;
% remapping of commands/dists from colors
cmdchars = 'RDLU';
cmds = cmdchars(colors(:,6)+1);
dists = sum(repmat(16.^(4:-1:0),N,1).*colors(:,1:5),2);

vdists = dists;
vdists(cmds=='U') = -vdists(cmds=='U');
vdists(cmds=='L' | cmds=='R') = 0;
hdists = dists;
hdists(cmds=='L') = -hdists(cmds=='L');
hdists(cmds=='U' | cmds=='D') = 0;

xlocs = cumsum([0;vdists]);
ylocs = cumsum([0;hdists]);
xlocs = xlocs - min(xticks) + 2;
ylocs = ylocs - min(yticks) + 2;

% get unique axis ticks
xticks  = unique(reshape([ xlocs-1, xlocs ],[],1));
yticks = unique(reshape([ ylocs-1, ylocs],[],1));
scalearea = diff([0;xticks;0])*diff([0;yticks;0])';
% xticks  = unique(reshape([ xlocs-1, xlocs, xlocs+1],[],1));
% yticks = unique(reshape([ ylocs-1, ylocs, ylocs+1],[],1));
% scalearea = diff([0;xticks])*diff([0;yticks])';

[ ~, xlocs ] = ismember(xlocs,xticks);
[ ~, ylocs ] = ismember(ylocs,yticks);

Nr = max(xlocs) + 1;
Nc = max(ylocs) + 1;
map = char('.'*ones(Nr,Nc));

pos = [xlocs(1),ylocs(1)];
for i=1:N+1
    newpos = [xlocs(i),ylocs(i)];
    mins = min([pos;newpos]);
    maxs = max([pos;newpos]);
    map(mins(1):maxs(1),mins(2):maxs(2)) = '#';
    pos = newpos;
end

out = [1,1];
while ~isempty(out)
    i = out(1,1);
    j = out(1,2);
    map(i,j) = 'o';
    out = out(2:end,:);
    xs = [i-1 i i i+1];
    ys = [j j-1 j+1 j ];
    for k=1:4
        if xs(k)<1 || xs(k)>Nr || ys(k)<1 || ys(k)>Nc % stay in bounds
            continue;
        end
        if map(xs(k),ys(k)) == '.'
            out(end+1,:) = [xs(k) ys(k)];
        end
    end 
    out = unique(out,'rows');
end
inside = map=='.' | map=='#';
part2 = sum(inside.*scalearea,'all')
toc
