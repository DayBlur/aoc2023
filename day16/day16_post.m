% ===== AOC2023 Day 16 [DayBlur] =====

%% Read file, ASCII map
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
file = fopen(filename);

height = 0;
width = 0;
basemap = zeros(1000,100);

line = fgetl(file);
while line ~= -1
    linechars = sscanf(line, '%c');
    width = length(linechars);    
    height = height + 1;
    basemap(height,1:width) = linechars;
    line = fgetl(file);
end
fclose(file);
basemap = basemap(1:height, 1:width);


%% Part 1+2
clc;
tic;
map = basemap;

[Nr,Nc] = size(map);
Nd = 4;

dirchars = 'LRUD';
refdirs = {'L','R','U','D'};
dirmap = containers.Map({'.','\','/','-','|'}, { ...
containers.Map(refdirs, refdirs),...
containers.Map(refdirs, {'U','D','L','R'}),...
containers.Map(refdirs, {'D','U','R','L'}),...
containers.Map(refdirs, {'L','R','LR','LR'}),...
containers.Map(refdirs, {'UD','UD','U','D'})});
dirmove = containers.Map(refdirs, {[0,-1],[0,1],[-1,0],[1,0]});
dirnums = containers.Map(refdirs,{1,2,3,4});

startpos = zeros(2*Nr+2*Nc,2);
startdir = zeros(2*Nr+2*Nc,1);
startpos(:,1) = [ones(1,Nc),Nr*ones(1,Nc),1:Nr,1:Nr];
startpos(:,2) = [1:Nc,1:Nc,ones(1,Nr),Nc*ones(1,Nr)];
startdir = ['D'*ones(1,Nc),'U'*ones(1,Nc),'R'*ones(1,Nr),'L'*ones(1,Nr)];
part1idx = 2*Nc+1;

energized = zeros(size(startdir));
for i=[part1idx,setdiff(1:length(startdir),part1idx)]
    visited = containers.Map('KeyType','double','ValueType','double');
    mem = containers.Map('KeyType','double','ValueType','double');    
    next = [startpos(i,:), dirnums(char(startdir(i)))];
    usenext = true;
    while ~usenext || ~isempty(next)
        if usenext
            pos = next(1,1:2);
            dir = dirchars(next(1,3));
            next = next(2:end,:);
        end
        usenext = true;
        if all(pos>0) && pos(1)<=Nr && pos(2)<=Nc
            posstate = sub2ind([Nr,Nc],pos(1),pos(2));
            state = sub2ind([Nr,Nc,Nd],pos(1),pos(2),dirnums(dir));
            if mem.isKey(state)
                continue;
            end
            visited(posstate) = 1;
            mem(state) = 1;
            tmp = dirmap(char(map(pos(1),pos(2))));
            nextdirs = tmp(dir);
            if length(nextdirs) == 1 % opitmization to avoid manipulating next array
                diri = nextdirs;
                pos = pos + dirmove(diri);
                dir = diri;
                usenext = false;
                continue;
            end
            for diri=nextdirs
                next(end+1,:) = [ pos + dirmove(diri), dirnums(diri) ];
            end
        end
    end   
    energized(i) = length(visited);
    if i==part1idx
        part1 = energized(i)
        toc
    end
end
part2 = max(energized)
toc
