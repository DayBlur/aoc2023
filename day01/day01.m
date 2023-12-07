% ===== AOC2023 Day 01 [DayBlur] =====

%% Load data
clear;
clc;
% filename = 'example.txt';
% filename = 'example2.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(strtrim(data));
numlines = length(lines);

%% Part 1
% clc;
tsum = 0;
for i=1:numlines
    line = lines{i};
    val = str2double([line(find(line>='0'&line<='9',1)),line(find(line>='0'&line<='9',1,'last'))]);
    tsum = tsum + val;
end
part1 = tsum

%% Part 2
% clc;
strs = {'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine' };
chars = {'1', '2', '3', '4', '5', '6', '7', '8', '9' };

tsum = 0;
for i=1:numlines
    line = lines{i};
    firstidx = Inf;
    lastidx = -Inf;
    lastval = 0;
    firstval = 0;
    for j=1:9
        idxs = [ strfind(line, strs{j}), find(line==('0'+j)) ];
        if max(idxs) > lastidx, lastidx = max(idxs); maxval = j; end
        if min(idxs) < firstidx, firstidx = min(idxs); minval = j; end
    end
    val = minval*10 + maxval;
    tsum = tsum + val;
end
part2 = tsum
