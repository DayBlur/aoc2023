% ===== AOC2023 Day 22 [DayBlur] =====

%% Read file, line processing
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(strtrim(data));
N = length(lines);
initblocks = zeros(N,6);
for i=1:N
    line = lines{i};
    parts = strsplit(line,'~');
    initblocks(i,:) = str2num([parts{1},',',parts{2}]);
end
initblocks = initblocks + 1;
for i=1:3
    minax(i) = min(initblocks(:,[i,3+i]),[],'all');
    maxax(i) = max(initblocks(:,[i,3+i]),[],'all');
end
assert(all(initblocks(:,1:3) <= initblocks(:,4:6),'all'));
assert(all(initblocks>=0,'all'));
sz = maxax + 1;

%% Settle blocks to initial state
% clc;
tic;
blocks = initblocks;
map = zeros(sz);

% place blocks
for i=1:N
    a = blocks(i,:);
    map(a(1):a(4),a(2):a(5),a(3):a(6)) = i;
end

% settle blocks
done = false;
while ~done
    done = true;
    for i=1:N
        a = blocks(i,:);
        if a(3) > 1 && all(map(a(1):a(4),a(2):a(5),a(3)-1)==0)
            map(a(1):a(4),a(2):a(5),a(3):a(6)) = 0;
            map(a(1):a(4),a(2):a(5),(a(3):a(6))-1) = i;
            blocks(i,:) = [a(1),a(2),a(3)-1,a(4),a(5),a(6)-1];
            done = false;
        end
    end
end
% 'initial blocks settled'
% toc

%% Part 1
% clc;
tic;
candis = 1:N;
for i=1:N
    tmpmap = map;
    a = blocks(i,:);
    tmpmap(a(1):a(4),a(2):a(5),a(3):a(6)) = 0; % remove block
    for k=1:N
        a = blocks(k,:);
        if a(3) > 1 && all(tmpmap(a(1):a(4),a(2):a(5),a(3)-1)==0)
            candis = setdiff(candis,i); % block would drop
            break;
        end
    end
end
part1 = length(candis)
toc

%% Part 2
% clc;
tic;
disnum = zeros(1,N);
for i=1:N
    tmpmap = map;
    tmpblocks = blocks;
    a = tmpblocks(i,:);
    tmpmap(a(1):a(4),a(2):a(5),a(3):a(6)) = 0; % remove block
    disnumi = zeros(1,N);
    % settle blocks
    done = false;
    while ~done
        done = true;
        for k=1:N
            if i==k
                continue;
            end
            a = tmpblocks(k,:);
            if a(3) > 1 && all(tmpmap(a(1):a(4),a(2):a(5),a(3)-1)==0)
                tmpmap(a(1):a(4),a(2):a(5),a(3):a(6)) = 0;
                tmpmap(a(1):a(4),a(2):a(5),(a(3):a(6))-1) = k;
                tmpblocks(k,:) = [a(1),a(2),a(3)-1,a(4),a(5),a(6)-1];
                done = false;
                disnumi(k) = 1; % this block dropped
            end
        end
    end
    disnum(i) = sum(disnumi); % count number of blocks that dropped
end
part2 = sum(disnum)
toc
