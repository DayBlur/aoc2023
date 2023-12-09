% ===== AOC2023 Day 08 [DayBlur] =====

%% Read file, line processing
clear;
clc;
% filename = 'example.txt';
% filename = 'example2.txt';
% filename = 'example3.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(strtrim(data));
numlines = length(lines);
inst = lines{1};
N = numlines - 2;
nodes = cell(N,3);
left = zeros(N,3);
right = zeros(N,3);
for i=1:N
    line = lines{i+2};
    parts = regexp(line,'[\s=,\(\)\n]+','split');
    nodes(i,:) = parts(1:3);
end
Ni = length(inst);
modone = @(x,m) mod(x-1,m)+1;

%% Part 1
% clc;
tic;
step = 1;
node = find(strcmp(nodes(:,1), 'AAA'));
while true
    s = inst(modone(step,Ni));
    if s == 'L'
        next = nodes{node,2};
    else
        next = nodes{node,3};
    end
    if strcmp(next,'ZZZ')
        break;
    else
        node = find(strcmp(nodes(:,1), next));
        step = step + 1;
    end
end
part1 = step
toc

%% Part 2
% Approach assumes each path follows a single closed loop ending in a
% terminal node which loops back to the node pointed to by the starting
% node (and therefore with a path length that is an integer multiple of the
% instructions).
% The examples and inspection of my input file uphold this assumption.
% clc;
tic;
startnodes = find(endsWith(nodes(:,1),'A'));
Ns = length(startnodes);
nodesteps = zeros(Ns,1);
for i=1:Ns
    node = startnodes(i);
    step = 1;
    while true
        s = inst(modone(step,Ni));
        if s == 'L'
            next = nodes{node,2};
        else
            next = nodes{node,3};
        end
        if endsWith(next,'Z')
            break;
        else
            node = find(strcmp(nodes(:,1), next));
            step = step + 1;
        end
    end
    nodesteps(i) = step;
end
finalstep = 1; % or Ni
for i=1:Ns
    finalstep = lcm(finalstep, nodesteps(i));
end    
part2 = finalstep
toc
