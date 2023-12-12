% ===== AOC2023 Day 12 [DayBlur] =====

%% Read file, line processing
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(strtrim(data));
N = length(lines);
records = cell(1,N);
groups = cell(1,N);
for i=1:N
    line = lines{i};
    parts = strsplit(line, ' ');
    records{i} = parts{1};
    groups{i} = str2double(strsplit(parts{2},','));
end

%% Part 1
% clc;
tic;
tmpsum = 0;
for i=1:N
    arr = 0;
    rec = strcat('.',records{i},'.');
    grp = groups{i};
    idx = find(rec == '?');
    Ni = length(idx);
    numcombos = 2^Ni;
    testchars = '.#';
    for j=1:numcombos
        opts = bitget(j,1:Ni);
        tmp = rec;
        tmp(idx) = testchars(opts+1);
        idx1 = find(diff(tmp=='#')<0);
        idx2 = find(diff(tmp=='#')>0);
        cnts = idx1 - idx2;    
        if (length(cnts) == length(grp)) && (all(cnts==grp))
            arr = arr + 1;
        end
    end
    tmpsum = tmpsum + arr;
end
part1 = tmpsum
toc

%% Part 2
% clc;
tic;
tmpsum = 0;
for i=1:N
%     rec = records{i};
%     grp = groups{i};
    rec = strjoin(records(repmat(i,1,5)),'?');
    grp = repmat(groups{i},1,5);
    
%     % string key for caching, slower and uses more memory
%     mem = containers.Map('KeyType','char','ValueType','double');
%     makekey = @(r,g,p) strcat(r,sprintf('%d,',g),sprintf('%d',p));
    % numeric key for caching
    mem = containers.Map('KeyType','double','ValueType','double');
    keyspace = [length(rec),length(grp),length(rec)]+1;
    makekey = @(r,g,p) sub2ind(keyspace,length(r)+1,length(g)+1,p+1);
    
    [numarr, mem] = countrec(rec, grp, 0, mem, makekey);
    tmpsum = tmpsum + numarr;
end
part2 = tmpsum 
toc

%% Functions

% recursive search, input remaing record chars and groups, pos is position within current group
function [ numarr, mem ] = countrec(rec, grp, pos, mem, makekey)
    numarr = 0;
    key = makekey(rec,grp,pos);
    if mem.isKey(key)
        numarr = mem(key);
        return;
    end
    if isempty(rec) % recursion terminates when no chars left
        if isempty(grp) && pos == 0 % finished record with all groups found 
            numarr = 1;
        elseif length(grp)==1 && pos == grp(1) % finished record with last group finished
            numarr = 1;
        else
            numarr = 0;
        end
    else
        c = rec(1);    
        rec = rec(2:end);
        % decrease chars so recursion always terminates
        if c == '.' || c == '?'
            if pos == 0  % no group in progress, nothing to do
                [num, mem] = countrec(rec, grp, pos, mem, makekey);
                numarr = numarr + num;
            elseif ~isempty(grp) && pos == grp(1) % finish current group
                [num, mem] = countrec(rec, grp(2:end), 0, mem, makekey);
                numarr = numarr + num;
            end
        end
        if c == '#' || c == '?' % increment char count within current group
            if isempty(grp) || pos < grp(1) % '#' expected/allowed
                [num, mem] = countrec(rec, grp, pos+1, mem, makekey);
                numarr = numarr + num;
            end
        end
        mem(key) = numarr;
    end
end
