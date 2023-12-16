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


%% Part 1
% clc;
tic
map = basemap;
[Nr,Nc] = size(map);

dir = 'R';
pos = [1,1];

mem = containers.Map('KeyType','double','ValueType','double');
visited = containers.Map('KeyType','double','ValueType','double');
visited = beam(pos, dir, map, visited, mem);
part1 = length(visited)
toc

% % Print visited map for debuggung
% visitedmap = '.'*ones(size(map));
% for i=1:Nr
%     for j=1:Nc
%         key = sub2ind([Nr,Nc],i,j);
%         if visited.isKey(key)
%             visitedmap(i,j) = '#';
%         end
%     end
% end
% char(visitedmap)


%% Part 2
% clc;
tic;
map = basemap;

startpos = zeros(2*Nr+2*Nc,2);
startdir = zeros(2*Nr+2*Nc,1);
startpos(:,1) = [ones(1,Nc),Nr*ones(1,Nc),1:Nr,1:Nr];
startpos(:,2) = [1:Nc,1:Nc,ones(1,Nr),Nc*ones(1,Nr)];
startdir = [4*ones(Nc,1);3*ones(Nc,1);2*ones(Nc,1);1*ones(Nc,1)];
dirchars = 'LRUD';

energized = zeros(size(startdir));
mem = containers.Map('KeyType','double','ValueType','any');
for i=1:length(startdir)
    visited = zeros(Nr,Nc);
    mem = containers.Map('KeyType','double','ValueType','double');
    pos = startpos(i,:);
    dir = dirchars(startdir(i,:));
    [ visited, mem ] = beam(pos, dir, map, visited, mem);
    energized(i) = sum(visited>0,'all');
end
part2 = max(energized)
toc


%% Functions

function [ visited, mem ] = beam(pos, dir, map, visited, mem)
    [Nr,Nc] = size(map);
    Nd = 4;
    
    refdirs = {'L','R','U','D'};
    dirchars = 'LRUD';
    dirnums = containers.Map(refdirs,{1,2,3,4});    
    dirmap = containers.Map(...
        {'.','\','/','-','|'},...
        { containers.Map(refdirs, refdirs),...
          containers.Map(refdirs, {'U','D','L','R'}),...
          containers.Map(refdirs, {'D','U','R','L'}),...
          containers.Map(refdirs, {'L','R','LR','LR'}),...
          containers.Map(refdirs, {'UD','UD','U','D'})});
    dirmove = containers.Map({'L','R','U','D'}, {[0,-1],[0,1],[-1,0],[1,0]});
    
    if all(pos>0) && pos(1)<=Nr && pos(2)<=Nc
        posstate = sub2ind([Nr,Nc],pos(1),pos(2));
        state = sub2ind([Nr,Nc,Nd],pos(1),pos(2),dirnums(dir));
        visited(posstate) = 1;
        if mem.isKey(state)
            return;
        end
        mem(state) = 1;
        tmp = dirmap(char(map(pos(1),pos(2))));
        nextdirs = tmp(dir);
        for diri=nextdirs
            posi = pos + dirmove(diri);
            [visited, mem] = beam(posi,diri,map,visited,mem);
        end
    end
end

