% ===== AOC2023 Day 15 [DayBlur] =====

%% Read file, line processing
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
data = fileread(filename);
parts = split(strtrim(data),',');
Np = length(parts);

%% Part 1
% clc;
tic;
hashes = zeros(1,Np);
for j=1:Np
    str = parts{j};
    for c=str
        hashes(j) = mod((hashes(j) + double(c))*17, 256);
    end
end
sum(hashes)
toc

%% Part 2
% clc;
tic;
mem = containers.Map();
labels = cell(256,1);
lenses = cell(256,1);
for j=1:Np
    str = parts{j};
    if str(end) == '-'
        cmd = '-';
        label = str(1:end-1);
    else
        cmd = '=';
        label = str(1:end-2);
        focal = str(end)-'0';
    end
    hash = 0;
    for c=label
        hash = mod((hash + double(c))*17, 256);
    end
    boxid = hash + 1;
    box = labels{boxid};
    focals = lenses{boxid};
    ismatch = strcmp(box,label);
    matchidx = find(strcmp(box,label),1);
    switch(cmd)
        case '-'
            if ~isempty(matchidx)
                box = box(~ismatch);
                focals = focals(~ismatch);
            end
        case '='
            if isempty(matchidx)
                box{end+1} = label;
                focals(end+1) = focal;
            else
                focals(matchidx) = focal;
            end
    end
    labels{boxid} = box;
    lenses{boxid} = focals;
end
fp = 0;
for i=1:256
    f = lenses{i};
    Nf = length(f);
    fp = fp + i*sum((1:Nf).*f);
end
part2 = fp
toc
