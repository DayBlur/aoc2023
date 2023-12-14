% ===== AOC2023 Day 14 [DayBlur] =====

%% Read file, ASCII map
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
file = fopen(filename);

height = 0;
width = 0;
basemap = zeros(100,100);

line = fgetl(file);
while line ~= -1
    linechars = sscanf(line, '%c');
    width = length(linechars);    
    height = height + 1;
    basemap(height,1:width) = linechars;
    line = fgetl(file);
end
fclose(file);

assert(width==height);
basemap = basemap(1:width, 1:height);
extmap = [ ones(1,width+2)*'#'; ones(height,1)*'#', basemap, ones(height,1)*'#'; ones(1,width+2)*'#'];
% char(extmap)

%% Part 1
% clc;
tic;
map = basemap;
N = size(basemap,1);
for i=1:N-1
    while i>0
        idx = map(i,:)=='.' & map(i+1,:)=='O';
        if ~any(idx), break; end
        map(i,idx) = 'O';
        map(i+1,idx) = '.';
        i = i - 1;
    end
end
[rocksi, ~] = find(map=='O');
load = sum(N+1-rocksi);
part1 = load
toc

%% Part 2 - simple row-by-row rock rolling as used above
% clc;
tic;
map = basemap;
N = size(basemap,1);
Ncycles = 1000000000;
mem = containers.Map('KeyType','char','ValueType','double');
k = 1;
while k <= Ncycles
    % perform cycle
    for dir=1:4
        for i=1:N-1
            while i>0
                idx = map(i,:)=='.' & map(i+1,:)=='O';
                if ~any(idx), break; end
                map(i,idx) = 'O';
                map(i+1,idx) = '.';
                i = i - 1;
            end
        end
        map = rot90(map,-1);
    end
    % check for repeat state
    key = char(map(:)');
    if mem.isKey(key)
        cyclestogo = Ncycles - k;
        patternlen = k - mem(key);
        k = k + floor(cyclestogo/patternlen)*patternlen;
    else    
        mem(key) = k;
    end
    k = k + 1;
end
% compute load
[rocksi, ~] = find(map=='O');
load = sum(N+1-rocksi);
part2 = load
toc

%% Part 2 - original rock rolling using #-extended map and finding # breaks
% clc;
tic;
map = extmap;
N = size(extmap,1);
Ncycles = 1000000000;
mem = containers.Map('KeyType','char','ValueType','double');
k = 1;
while k <= Ncycles
    % perform cycle
    for dir=1:4
        r = 1:N;
        for c=2:N-1
            line = map(r,c);
            breaks = find(line=='#');
            for i=1:length(breaks)-1
                b = breaks(i:i+1);
                n = sum((line(b(1):b(2))=='O'));
                % shift blocks within region
                line(b(1)+(1:n)) = 'O';
                line((b(1)+n+1):(b(2)-1)) = '.';
                map(r,c) = line;
            end
        end
        map = rot90(map,-1);
    end
    % check for repeat state
    key = char(map(:)');
    if mem.isKey(key)
        cyclestogo = Ncycles - k;
        patternlen = k - mem(key);
        k = k + floor(cyclestogo/patternlen)*patternlen;
    else
        mem(key) = k;
    end
    k = k + 1;
end
% compute load
[rocksi, ~] = find(map=='O');
load = sum(N-rocksi);
part2 = load
toc
