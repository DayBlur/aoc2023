% ===== AOC2023 Day 10 [DayBlur] =====

%% Read file, ASCII map
clear;
clc;
% filename = 'example.txt';
% filename = 'example2.txt';
% filename = 'example3.txt';
% filename = 'example4.txt';
% filename = 'example5.txt';
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
extmap = [ NaN(1,width+2); NaN(height, 1), basemap, NaN(height, 1); NaN(1,width+2) ];
extmap(extmap==double('.')) = NaN;

% char(extmap(2:end-1,2:end-1))

%% Part 1
% clc;
tic
map = extmap;
four_adjacencies = @(i,j) [[i-1, j]; [i, j-1]; [i, j+1]; [i+1, j]];
four_dirs = 'DRLU';
% pipe types and their inputs and outputs (store as next pipe input dir)
pipes = '|-L7FJ';
in = ['UD';'LR';'UR';'DL';'DR';'UL'];
nextin = ['UD';'LR';'LD';'RU';'LU';'RD']; % swap U<->D, L<->R and fliplr

startdirs = 'XX';
[startx,starty] = find(map=='S');
pt = [startx,starty]; % start here
path = pt;
dirs = four_dirs; % search all dirs at first
found = false;
while ~found
    testpts = four_adjacencies(pt(1),pt(2));
    testdirs = dirs;
    testpts = testpts(four_dirs==dirs,:);
    for j=1:size(testpts,1)
        ch = map(testpts(j,1),testpts(j,2));
        if ch=='S' % terminate pt1 and record finishing dir for S pipe
            startdirs(2) = testdirs(j);
            found = true;            
            break;
        end
        p = find(pipes==ch,1);
        if isempty(p), continue; end
        k = find(in(p,:)==testdirs(j),1); % figure which way we're entering
        if isempty(k), continue; end
        if map(pt(1),pt(2)) == 'S'
            % record starting dir to figure out S pipe type
            startdirs(1) = nextin(p,3-k);
            path = pt;
        end
        % continue to the next point, entering in the correct direction
        pt = testpts(j,:);
        dirs = nextin(p,k);
        path(end+1,:) = pt;
        break;
    end
end
% display the loop path, for debugging
startpipe = pipes(all(in==startdirs,2) | all(fliplr(in)==startdirs,2));
pathmap = map;
pathmask = zeros(size(map));
for i=1:size(path,1)
    pathmap(path(i,1),path(i,2)) = '0'+mod(i,10);
    pathmask(path(i,1),path(i,2)) = 1;
end
pathmap(path(i,1),path(i,2)) = '*'; % 'S'; % highlight start
pathmap(~pathmask) = NaN;
% char(pathmap(2:end-1,2:end-1))
part1 = ceil(length(path)/2)
toc

%% Part 2
% clc;
tic;
% these values determine the H/V contribution of each pipe type
% (note that a U-turn cancels out while a Z adds)
%            |   -  L    7     F     J
pipevalh = [ 0 , 1, 0.5, 0.5, -0.5, -0.5 ]; 
pipevalv = [ 1 , 0, 0.5, 0.5, -0.5, -0.5 ];

% constuct mapio with only main loop (replace S with corresponding pipe)
mapio = map;
mapio(~pathmask) = NaN;
mapio(path(1,1),path(1,2)) = startpipe;

% build 'wall' values of the pipes in the vertical and horizontal directions
vmap = zeros(size(mapio));
hmap = zeros(size(mapio));
for i=1:length(pipes)
    vmap(mapio==pipes(i)) = pipevalv(i);
    hmap(mapio==pipes(i)) = pipevalh(i);
end

% now shoot a ray to the left to determine if inside the loop or not
% (can do this left/right/up/down and get same answer)
[testx, testy] = find(isnan(mapio));
for i=1:length(testx)
    if mod(sum(vmap(testx(i),1:testy(i)-1)),2)
        mapio(testx(i),testy(i)) = 'I';
    else
        mapio(testx(i),testy(i)) = 'O';
    end
end

% char(mapio(2:end-1,2:end-1))
part2 = sum(sum(mapio=='I'))
toc
