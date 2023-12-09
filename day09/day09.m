% ===== AOC2023 Day 09 [DayBlur] =====

%% Read file, numbers
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
data = load(filename);
N = size(data,1);

%% Part 1
% clc;
tic;
tmpsum = 0;
for i=1:N
    h = data(i,:);
    mem = [];
    while any(h~=0)
        mem(end+1) = h(end);
        h = diff(h);
    end
    tmpsum = tmpsum + sum(mem);
end
part1 = tmpsum
toc

%% Part 2
% clc;
tic;
tmpsum = 0;
for i=1:N
    h = data(i,:);
    mem = [];
    while any(h~=0)
        mem(end+1) = h(1);
        h = diff(h);
    end
    tmpsum = tmpsum + sum(mem(1:2:end)) - sum(mem(2:2:end));
end
part2 = tmpsum
toc