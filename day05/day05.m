% ===== AOC2023 Day 05 [DayBlur] =====

%% Read file, line processing
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(data);
numlines = length(lines);
seeds = cell2mat(textscan(lines{1}(8:end), '%f'));
map = zeros(1000,3);
maplen = 0;
for i=3:numlines
    line = lines{i};
    if isempty(line) && maplen > 0
        seedmap.(name) = map(1:maplen,:);
        seedmap.(name)(:,4) = seedmap.(name)(:,2) + seedmap.(name)(:,3) - 1;
        map = zeros(1000,3);
        maplen = 0;
        continue;
    end
    if endsWith(line,'map:')
        name = line(1:end-5);
        name = strrep(name,'-','_');
        continue;
    end
    maplen = maplen + 1;
    map(maplen,:) = cell2mat(textscan(line, '%f'));
end

%% Part 1
% clc;
tic;
minloc = Inf;
for k=1:length(seeds)
    source = 'seed';
    val = seeds(k);    
    while true
%         source
%         val
        fns = fieldnames(seedmap);
        for i=1:length(fns)
            fn = fns{i};
            tmp = strsplit(fn,'_');
            if strcmp(tmp{1},source)
                map = seedmap.(fn);
                dest = tmp{3};
                break;
            end
        end       
        idx = find(val >= map(:,2) & val <= map(:,4));
        if ~isempty(idx)
            val = val - map(idx,2) + map(idx,1);
        end
        source = dest;
        if strcmp(dest,'location')
            minloc = min(minloc,val);
%             val
            break;
        end
    end
end
part1 = minloc
toc

%% Part 2
% clc;
tic;
seedranges = reshape(seeds,2,[])';
seedranges(:,2) = sum(seedranges,2)-1;

minloc = Inf;
source = 'seed';
valranges = seedranges;
while true
    fns = fieldnames(seedmap);
    for i=1:length(fns)
        fn = fns{i};
        tmp = strsplit(fn,'_');
        if strcmp(tmp{1},source)
            map = seedmap.(fn);
            dest = tmp{3};
            break;
        end
    end
    j = 1;
    while j <= size(valranges,1)
        tmprange = valranges(j,:);
        found = 0;
        for i=1:size(map,1)
            tmprange2 = [ map(i,2) map(i,4)];
            newranges = splitrange(tmprange, tmprange2);
            if size(newranges,1) > 1
                valranges(j,:) = newranges(1,:);
                for k=2:size(newranges,1)
                    valranges(end+1,:) = newranges(k,:);
                end
                found = 1;
            end
        end
        if ~found
            j = j + 1;
        end
    end
    valranges = unique(valranges, 'rows');
    
    for i=1:size(valranges,1)            
        val = valranges(i,1);
        idx = find(val >= map(:,2) & val < map(:,4));
        if ~isempty(idx)
            valranges(i,:) = valranges(i,:) - map(idx,2) + map(idx,1);
        end
    end

    source = dest;
    if strcmp(dest,'location')
        minloc = min(minloc,min(valranges(:,1)));
        break;
    end
end
part2 = minloc
toc

%% Functions

% Intersect an inclusive range with another, splitting the original range
% into multiple. A range is defined as a row vector of starting and ending
% values, inclusive.
function [ ranges ] = splitrange(r1, r2)
    ranges = [];
    r = r1;
    if r2(1) > r(1) && r2(1) < r(2)
        ranges(end+1,:) = [ r(1) r2(1)-1 ];
        r(1) = r2(1);
    end
    if r2(2) > r(1) && r2(2) < r(2)
        ranges(end+1,:) = [ r(1) r2(2) ];
        r(1) = r2(2)+1;
    end
    ranges(end+1,:) = r;
end
