% ===== AOC2023 Day 23 [DayBlur] =====

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
tic;
map = basemap;
[Nr, Nc ] = size(map);
statesize = [Nr,Nc];
S = find(map(1,:)=='.');
E = find(map(end,:)=='.');
% longestpath = [];
longestdist = 0;
paths = cell(1,1000);
dists = zeros(1,1000);
paths{1} = sub2ind(statesize,1,S);
dists(1) = 0;
idx = 1;
while idx > 0
    path = paths{idx};
    dist = dists(idx);
    idx = idx - 1;
    [i,j] = ind2sub(statesize,path(end));
    if i==Nr && j==E && dist>longestdist
%         longestpath = path;
        longestdist = dist;
        continue;
    end
    xs = [i-1 i i i+1];
    ys = [j j-1 j+1 j ];
    dirs = '^<>v';
    validdirs = find(map(i,j)==dirs,1);
    if isempty(validdirs)
        validdirs = 1:4;
    end
    for k=validdirs
        if xs(k)<1 || xs(k)>Nr || ys(k)<1 || ys(k)>Nc || map(xs(k),ys(k)) == '#'% stay in bounds
            continue;
        end
        state = sub2ind(statesize,xs(k),ys(k));
        if ismember(state,path)
            continue;
        end
        idx = idx + 1;
        paths{idx} = [path,state];
        dists(idx) = dist + 1;
    end    
end
part1 = longestdist
toc


%% Part 2
% clc;
tic;
% most of the map is tunnels, find the junction points where the path forks
testidx = find(map~='#');
junctions = [];
for k=1:length(testidx)
    [i,j] = ind2sub(statesize,testidx(k));
    xs = [i-1 i i i+1];
    ys = [j j-1 j+1 j ];
    validdirs = find(xs>0 & xs<=Nr & ys>0 & ys<=Nc);
    tmp = find(map(sub2ind(statesize,xs(validdirs),ys(validdirs)))~='#');
    validdirs = validdirs(tmp);
    if length(validdirs) > 2
        junctions(end+1) = testidx(k);
    end
end
% add in start and end nodes (not forks so not found above)
junctions = [ sub2ind(statesize,1,S), junctions, sub2ind(statesize,Nr,E)];
[x,y] = ind2sub(statesize,junctions);
Nj = length(junctions);

% map = basemap;
% find distances between all reachable node pairs, forming a directed graph
distmap = zeros(Nj,Nj);
for a=1:length(junctions)
    state = junctions(a);
    [i,j] = ind2sub(statesize,state);
    xs = [i-1 i i i+1];
    ys = [j j-1 j+1 j ];
    validdirs = find(xs>0 & xs<=Nr & ys>0 & ys<=Nc);
    tmp = find(map(sub2ind(statesize,xs(validdirs),ys(validdirs)))~='#');
    jvaliddirs = validdirs(tmp);
    jstates = sub2ind(statesize,xs(jvaliddirs),ys(jvaliddirs));
    for k=1:length(jvaliddirs)
        visited = junctions(a);
        dist = 0;
        state = jstates(k);
        dist = dist + 1;
        visited(end+1) = state;
        while ~ismember(state,junctions)
            [i,j] = ind2sub(statesize,state);
            xs = [i-1 i i i+1];
            ys = [j j-1 j+1 j ];
            validdirs = find(xs>0 & xs<=Nr & ys>0 & ys<=Nc);
            states = sub2ind(statesize,xs(validdirs),ys(validdirs));            
            tmp = find(map(sub2ind(statesize,xs(validdirs),ys(validdirs)))~='#' & ~ismember(states,visited));
            state = states(tmp);
%             validdir = validdirs(tmp);
            if isempty(state)
                break;
            end
            dist = dist + 1;
            visited(end+1) = state;
%             map(visited) = 'o';
        end
        state = visited(end);
        b = find(state==junctions);
        distmap(a,b) = dist;
    end
end
distmap(:,1) = 0; % start node only goes into map
distmap(end,:) = 0;  % end node only goes out of map
% labels = ['0'+char(0:9),'A'+char(0:25)];
% map(junctions) = labels(1:Nj);
% assert(~any(ismember(map,'.<>^v'),'all'));
% char(map)

% graph is not acylic, so cannot solve with 'negated' shortest path approach
% just use brute force, stack-based DFS between start end end nodes
paths = {[1]};
dists = [0];
% longestpath = [];
longestdist = 0;
idx = 1;
while idx > 0
    path = paths{idx};
    dist = dists(idx);
    idx = idx - 1;
    state = path(end);
    if state == Nj && dist > longestdist
        longestpath = path;
        longestdist = dist;
        continue;
    end
    next = distmap(state,:);
    next(path) = 0; % don't revisit
    for j=find(next)
        idx = idx + 1;
        paths{idx} = [path,j];
        dists(idx) = dist + distmap(state,j);
    end
end
part2 = longestdist
toc
