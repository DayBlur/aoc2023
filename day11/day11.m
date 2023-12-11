% ===== AOC2023 Day 11 [DayBlur] =====

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
expcol = find(all(map=='.',1));
exprow = find(all(map=='.',2));

for i=length(expcol):-1:1
    map = [ map(:,1:expcol(i)),map(:,expcol(i):end) ];
end
for i=length(exprow):-1:1
    map = [ map(1:exprow(i),:);map(exprow(i):end,:) ];
end

galaxies = find(map=='#');
Ng = length(galaxies);
Np = sum(1:Ng-1);
pairs = zeros(Np,2);
pidx = 1;
for i=1:Ng
    for j=i+1:Ng
        pairs(pidx,:) = [i,j];
        pidx = pidx + 1;
    end
end

tmpsum = 0;
for i=1:Np
    [x1,y1] = ind2sub(size(map), galaxies(pairs(i,1)));
    [x2,y2] = ind2sub(size(map), galaxies(pairs(i,2)));
    dist = abs(x2-x1) + abs(y2-y1);
    tmpsum = tmpsum + dist;
end
part1 = tmpsum
toc
    

%% Part 2
% clc;
tic;
map = basemap;
expcol = find(all(map=='.',1));
exprow = find(all(map=='.',2));

% char(map)
% for i=length(expcol):-1:1
%     map(:,expcol(i)) = '*';
% end
% for i=length(exprow):-1:1
%     map(exprow(i),:) = '*';
% end
% char(map)

galaxies = find(map=='#');
Ng = length(galaxies);
Np = sum(1:Ng-1);
pairs = zeros(Np,2);
pidx = 1;
for i=1:Ng
    for j=i+1:Ng
        pairs(pidx,:) = [i,j];
        pidx = pidx + 1;
    end
end
tmpsum = 0;
Nexp = 1e6;
for i=1:Np
    [x1,y1] = ind2sub(size(map), galaxies(pairs(i,1)));
    [x2,y2] = ind2sub(size(map), galaxies(pairs(i,2)));
    dist = abs(x2-x1) + abs(y2-y1);
    rowcnt = length(find(exprow > min(x1,x2) & exprow < max(x1,x2)));
    colcnt = length(find(expcol > min(y1,y2) & expcol < max(y1,y2)));
    dist = dist + (Nexp - 1)*(rowcnt + colcnt);
    tmpsum = tmpsum + dist;
end
part2 = tmpsum
toc
