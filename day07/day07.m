% ===== AOC2023 Day 07 [DayBlur] =====

%% Read file, text data
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';

data = fileread(filename);
lines = splitlines(strtrim(data));

N = length(lines);
bids = zeros(N,1);
hands = zeros(N,5);
for i=1:N
    line = lines{i};
    parts = strsplit(line,' ');
    bids(i) = str2double(parts{2});
    hands(i,:) = parts{1};
end

hands = int32(hands);
charmap = '23456789TJQKA';
intmap = 2:14;
for i=1:length(charmap)
    hands(hands==charmap(i)) = intmap(i);
end

N = size(hands,1);

%% Part 1
% clc;
tic;
scored = zeros(N,6);
scored(:,2:end) = hands;
for i=1:N
    scored(i,1) = score(hands(i,:));
end
[a,b] = sortrows(scored);
part1 = sum((1:N)'.*bids(b))
toc

%% Part 2
% clc;
tic;
scored = zeros(N,6);
scored(:,2:end) = hands;
tmp = 0;
for i=1:N
    tmp = 0;
    if any(hands(i,:) == 11)
        for j=[2:10,12:14]
            hand = hands(i,:);
            hand(hand==11) = j;
            tmp = max(tmp, score(hand));
        end
    else
        tmp = score(hands(i,:));
    end
    scored(i,1) = tmp;
end
scored(scored==11) = 1;
[a,b] = sortrows(scored);
part2 = sum((1:N)'.*bids(b))
toc

%%

function [ ret ] = score(hand)
    a = unique(hand);
    counts = 0*hand;
    for j=1:length(a)
        idx = find(hand == a(j));
        counts(j) = length(idx);
    end
    if any(counts==5)
        ret = 6;
    elseif any(counts==4)
        ret = 5;
    elseif any(counts==3) && any(counts==2)
        ret = 4;
    elseif any(counts==3)
        ret = 3;
    elseif length(find(counts==2)) == 2
        ret = 2;
    elseif any(counts==2)
        ret = 1;
    else
        ret = 0;
    end
end
