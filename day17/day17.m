% ===== AOC2023 Day 17 [DayBlur] =====

%% Load data
clear;
clc;

% filename = 'example.txt';
filename = 'input.txt';

data = fileread(filename);
lines = strsplit(strtrim(data),{'\r','\n'});
numlines = length(lines);
map = zeros(numlines,length(lines{1}));
for i=1:numlines
    map(i,:) = lines{i}-'0';
end
basemap = map;

%% Part 1
% clc;
tic;
map = basemap;
[Nr, Nc ] = size(map);
h = minheap(100000,5);
h.add([0,1,1,0,0]);
visited = [];
statesize = [Nr,Nc,4,3];
mincost = Inf;
endcnt = 0;
while h.count > 0
    m = h.pop();
    cost = m(1);
    dirlast = m(4);
    if dirlast>0
        statenum = sub2ind(statesize,m(2),m(3),m(4),m(5));
        if any(visited==statenum)
            continue;
        end
        visited(end+1,:) = statenum;
    end    
    i = m(2);
    j = m(3);    
    dircnt = m(5);
    xs = [i-1 i i i+1];
    ys = [j j-1 j+1 j ];
    revdirs = [4,3,2,1];
    if i==Nr && j==Nc
        mincost = min(mincost,cost);
    end
    for k=1:4
        if dirlast == revdirs(k) % disallow reverse
            continue;
        end
        if xs(k)<1 || xs(k)>Nr|| ys(k)<1 || ys(k)>Nc % stay in bounds
            continue;
        end
        newdir = k;
        if newdir==dirlast
            newdircnt = dircnt + 1;
        else
            newdircnt = 1;
        end
        if newdircnt <= 3
            newcost = cost + map(xs(k),ys(k));
            h.add([newcost,xs(k),ys(k),newdir,newdircnt]);
        end
    end
end
part1 = mincost
toc


%% Part 2
% clc;
tic;
map = basemap;
[Nr, Nc ] = size(map);
% heap state: cost,r,c,dirlast,dircnt
h = minheap(100000,5);
h.add([0,1,1,0,0]);
visited = containers.Map('KeyType','double','ValueType','double');
statesize = [Nr,Nc,4,10];
mincost = Inf;
endcnt = 0;
while h.count > 0
    m = h.pop();
    cost = m(1);
    dirlast = m(4);
    if dirlast>0
        statenum = sub2ind(statesize,m(2),m(3),m(4),m(5));
        if visited.isKey(statenum)
            continue;
        end
        visited(statenum) = cost;
    end    
    i = m(2);
    j = m(3);    
    dircnt = m(5);
    xs = [i-1 i i i+1];
    ys = [j j-1 j+1 j ];
    revdirs = [4,3,2,1];
    if i==Nr && j==Nc
        mincost = min(mincost,cost);
    end
    for k=1:4
        if dirlast == revdirs(k) % disallow reverse
            continue;
        end
        if xs(k)<1 || xs(k)>Nr|| ys(k)<1 || ys(k)>Nc % stay in bounds
            continue;
        end
        newdir = k;
        if newdir==dirlast
            newdircnt = dircnt + 1;
        else
            newdircnt = 1;
        end
        if dirlast==0 || (newdircnt <= 10 && (dircnt>=4 || newdir==dirlast))
            newcost = cost + map(xs(k),ys(k));
            h.add([newcost,xs(k),ys(k),newdir,newdircnt]);
        end
    end
end
part2 = mincost
toc
