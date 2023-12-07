% ===== AOC2023 Day 06 [DayBlur] =====

%% Read file, text data
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
lines = importdata(filename);
times = lines.data(1,:);
dists = lines.data(2,:);
N = length(times);

%% Part 1
% clc;
tic;
wins = zeros(N,1);
for i=1:N
    t = 0:times(i);
    a = 1;
    b = -times(i);
    c = dists(i);
    s = sqrt(b^2-4*a*c);
    d1 = (-b-s)/(2*a);
    d2 = (-b+s)/(2*a);
    d = find(t>d1 & t<d2)-1;
    wins(i) = length(d);    
end
part1 = prod(wins)
toc

%% Part 2
% clc;
tic;
time = str2double(strrep(num2str(times),' ',''));
dist = str2double(strrep(num2str(dists),' ',''));
t = 0:time;
a = 1;
b = -time;
c = dist;
s = sqrt(b^2-4*a*c);
d1 = (-b-s)/(2*a);
d2 = (-b+s)/(2*a);
d = find(t>d1 & t<d2)-1;
win = length(d);
part2 = win
toc