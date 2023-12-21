% ===== AOC2023 Day 21 [DayBlur] =====

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

Nrb = height;
Ncb = width;
basemap = basemap(1:Nrb, 1:Ncb);

%% Part 1
% clc;
tic;
map = basemap;
[Nr, Nc ] = size(map);
[i,j] = find(map=='S');
nodes = [i,j];
% Ns = 6;
Ns = 64;

newnodes = zeros(4*Ns^2,2);
for s=1:Ns
    Nn = 0;
    for m=1:size(nodes,1)
        i = nodes(m,1);
        j = nodes(m,2);
        xs = [i-1 i i i+1];
        ys = [j j-1 j+1 j ];
        for k=1:4
            if xs(k)<1 || xs(k)>Nr|| ys(k)<1 || ys(k)>Nc % stay in bounds
                continue;
            end
            if map(xs(k),ys(k)) == '#'
                continue;
            end
            Nn = Nn + 1;
            newnodes(Nn,:) = [ xs(k),ys(k) ];
        end
    end
    nodes = unique(newnodes(1:Nn,:),'rows');
    if Nr < 20 && Ns < 10
        printmap = basemap;
        printmap(sub2ind(size(map),nodes(:,1),nodes(:,2))) = 'O';
        char(printmap)
        pause
    end
end

part1 = size(nodes,1)
toc

%% Part 2
% clc;
tic;
modone = @(x,m) mod(x-1,m)+1;
Nrep = 1;
map = repmat(basemap,Nrep,Nrep);
[Nr, Nc] = size(map);
i = find(map=='S');
map(i) = '.';
map(i((Nrep*Nrep+1)/2)) = 'S';
[i,j] = find(map=='S');
nodes = [i,j];
Nsrep = 3*Nr; % rought estimate of number of steps to fill 3x3 map
Nh = sum(map=='#','all');
numnodes = zeros(1,Nsrep);
Nnn = 4*(Nsrep^2-Nh);
newnodes = zeros(Nnn,2);
% expand out until we get a repeating pattern in the number of reached plots vs number of steps
s = 0;
while true
    s = s + 1;
    Nn = 0;
    for m=1:size(nodes,1)
        i = nodes(m,1);
        j = nodes(m,2);
        xs = [i-1 i i i+1];
        ys = [j j-1 j+1 j ];
        for k=1:4
            if map(modone(xs(k),Nr),modone(ys(k),Nc)) == '#'
                continue;
            end
            Nn = Nn + 1;
            newnodes(Nn,:) = [ xs(k),ys(k) ];
        end
    end
    nodes = unique(newnodes(1:Nn,:),'rows');
    numnodes(s) = size(nodes,1);
    
    % look for generally quadratic repeating pattern with period of map size
    if s > 3*Nrb && mod(s,Nrb)==2
        dnum = diff(numnodes(1:s));
        ddnum = diff(dnum);
        tmp = reshape(ddnum',Nrb,[])';
        dtmp = diff(tmp);
        ddtmp = diff(dtmp);
        if all(ddtmp(end,:)==0,'all')
            break;
        end
    end
end
Ns = 26501365;

dtmp = [dtmp;repmat(dtmp(end,:),floor(Ns/Nrb),1)];
tmp = cumsum([tmp(1,:); dtmp]);
ddnum = reshape(tmp',1,[]);
dnum = cumsum([dnum(1),ddnum]);
num = cumsum([numnodes(1),dnum]);

% num([6,10,50,100,500,1000,5000]) % example numbers
part2 = num(Ns)
toc
