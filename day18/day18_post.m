% ===== AOC2023 Day 18 [DayBlur] =====

%% Read file, line processing
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(strtrim(data));
N = length(lines);
cmds = ones(N,1);
dists = ones(N,1);
colors = ones(N,6);
for i=1:N
    line = lines{i};
    vals = sscanf(line, '%c %d (#%1x%1x%1x%1x%1x%1x)');
    cmds(i) = vals(1);
    dists(i) = vals(2);
    colors(i,:) = vals(3:8);
end

vdists = dists;
vdists(cmds=='U') = -vdists(cmds=='U');
vdists(cmds=='L'|cmds=='R') = 0;
hdists = dists;
hdists(cmds=='L') = -hdists(cmds=='L');
hdists(cmds=='U'|cmds=='D') = 0;

xlocs = cumsum([0;vdists]);
ylocs = cumsum([0;hdists]);

%% Mathematical solution, credit to: jonathanpaulsen
%  https://github.com/jonathanpaulson/AdventOfCode
%  Treat trench as integer coordinates where each coordinate is the center
%  of one of the character blocks on the map.
%  Pick's theorem (https://en.wikipedia.org/wiki/Pick%27s_theorem) gives
%    the area of a polygon with integer coordinates as A = I + B/2 - 1
%      A is area (through the perimeter integer coordinates and inside)
%      B is number of boundary points
%      I is number of integer points strictly inside
%  For this problem, we want B+I (number of perimeter plus inerior points):
%      B + I = A + B/2 + 1
%  We can calculate A with Green's theorem, which is simplified to polygons
%    in the Gauss (shoelace) formula:
%     (https://en.wikipedia.org/wiki/Green%27s_theorem)
%     (https://en.wikipedia.org/wiki/Shoelace_formula)
%      A = sum(x*dy) = sum(y*dx) = sum(x(i)*y(i+1) - x(i+1)*y(i))

%% Part 1
% clc;
tic
% x is rows, y is cols, so negate xlocs for sign consistency
perimeter = sum(dists);
area1 = sum(-xlocs(1:end-1).*hdists); % Green's theorem, x*dy 
area2 = sum(ylocs(1:end-1).*vdists); % Green's theorem, y*dx
area3 = sum(-xlocs(1:end-1).*ylocs(2:end) - -xlocs(2:end).*ylocs(1:end-1))/2; % Gauss (shoelace) formula 
part1 = [ area1 + perimeter/2 + 1, area2 + perimeter/2 + 1, area3 + perimeter/2 + 1 ] % Pick's theorem 
toc

%% Part 2
% clc;
tic;
% remapping of commands/dists from colors
cmdchars = 'RDLU';
cmds = cmdchars(colors(:,6)+1);
dists = sum(repmat(16.^(4:-1:0),N,1).*colors(:,1:5),2);

vdists = dists;
vdists(cmds=='U') = -vdists(cmds=='U');
vdists(cmds=='L' | cmds=='R') = 0;
hdists = dists;
hdists(cmds=='L') = -hdists(cmds=='L');
hdists(cmds=='U' | cmds=='D') = 0;

xlocs = cumsum([0;vdists]);
ylocs = cumsum([0;hdists]);

perimeter = sum(dists);
area1 = sum(-xlocs(1:end-1).*hdists); % Green's theorem, x*dy 
area2 = sum(ylocs(1:end-1).*vdists); % Green's theorem, y*dx
area3 = sum(-xlocs(1:end-1).*ylocs(2:end) - -xlocs(2:end).*ylocs(1:end-1))/2; % Gauss (shoelace) formula 
part2 = [ area1 + perimeter/2 + 1, area2 + perimeter/2 + 1, area3 + perimeter/2 + 1 ]
toc
