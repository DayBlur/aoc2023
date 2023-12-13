% ===== AOC2023 Day 13 [DayBlur] =====

%% Read file, line processing
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(strtrim(data));
N = length(lines);
patterns = cell(0);
strmat = [];
for i=1:N
    line = lines{i};
    if isempty(line)
        patterns{end+1} = strmat;
        strmat = [];
        continue;
    end
    strmat(end+1,:) = line;
end
if ~isempty(strmat)
    patterns{end+1} = strmat;
end
Np = length(patterns);
    
%% Part 1
% clc;
tic;
tmpsum = 0;
for i=1:Np
    p = patterns{i};
    [r,c] = size(p);
    for i=1:r-1
        minsize = min(i-1+1,r-i);
        p1 = p((i-minsize+1):i,:);
        p2 = p(i+1:i+minsize,:);
        if all(flipud(p1)==p2,'all')
            tmpsum = tmpsum + i*100;
            break;
        end      
    end
    for i=1:c-1
        minsize = min(i-1+1,c-i);
        p1 = p(:,(i-minsize+1):i);
        p2 = p(:,i+1:i+minsize);
        if all(fliplr(p1)==p2,'all')
            tmpsum = tmpsum + i;
            break;
        end      
    end
end
part1 = tmpsum
toc

%% Part 2
% clc;
tic
tmpsum = 0;
for i=1:Np
    p = patterns{i};
    [r,c] = size(p);
    for i=1:r-1
        minsize = min(i-1+1,r-i);
        p1 = p((i-minsize+1):i,:);
        p2 = p(i+1:i+minsize,:);
        if sum(flipud(p1)==p2,'all') == minsize*c - 1 
            tmpsum = tmpsum + i*100;
            break;
        end      
    end
    for i=1:c-1
        minsize = min(i-1+1,c-i);
        p1 = p(:,(i-minsize+1):i);
        p2 = p(:,i+1:i+minsize);
        if sum(fliplr(p1)==p2,'all') == minsize*r - 1
            tmpsum = tmpsum + i;
            break;
        end      
    end
end
part2 = tmpsum
toc
