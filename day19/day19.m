% ===== AOC2023 Day 19 [DayBlur] =====

%% Read file, line processing
clear;
clc

% filename = 'example.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(strtrim(data));
numlines = length(lines);
workflows = containers.Map();
ratings = {};
for i=1:numlines
    line = lines{i};
    parts = strsplit(line,{'{','}'});
    if length(parts) == 1
        continue;
    end
    name = parts{1};
    if ~isempty(name)
        workflows(name) = strsplit(parts{2},',');
    else
        ratings{end+1} = strsplit(parts{2},',');        
    end    
end
N = length(ratings);

%% Part 1
% clc;
tic;
asum = 0;
for i=1:N
    rating = ratings{i};
    eval([strjoin(rating,';'),';']);
    termimate = false;
    wf = workflows('in');
    while ~termimate        
        for j=1:length(wf)
            rules = strsplit(wf{j},':');
            if length(rules) == 1 % default rule
                nextwf = rules{1};
            elseif eval(rules{1}) % inequality
                nextwf = rules{2};
            else
                continue; % no match, go to next rule
            end
            if strcmp(nextwf,'A')
                asum = asum + x + m + a + s;
                termimate = true;
            elseif strcmp(nextwf,'R')
                termimate = true;
            else
                wf = workflows(nextwf);
            end
            break;
        end
    end
end
part1 = asum
toc

%% Part 2
% clc;
tic;
keys = workflows.keys;

stack = [ find(strcmp(keys,'in')), [1,4000], [1,4000], [1,4000], [1,4000] ];
asum = 0;

while ~isempty(stack)
    tmp = stack(1,:);
    k = keys{tmp(1)};
    xr = tmp(2:3);
    mr = tmp(4:5);
    ar = tmp(6:7);
    sr = tmp(8:9);
    stack = stack(2:end,:);
    wf = workflows(k);
    for j=1:length(wf)
        c = 0;
        rules = strsplit(wf{j},':');
        if length(rules) == 1 % default
            nextwf = rules{1};
        else % split ranges on equality, add 'true' path to stack, cache remaining range
            rule = rules{1};
            nextwf = rules{2};
            c = rule(1);
            val = str2double(rule(3:end));
            if rule(2) == '<'
                eval(['new',c,'r=[val,',c,'r(2)];']);
                eval([c,'r(2)=val-1;']);
            elseif rule(2) == '>'
                eval(['new',c,'r=[',c,'r(1),val];']);
                eval([c,'r(1)=val+1;']);
            end
        end
        if strcmp(nextwf,'A')
            asum = asum + prod(diff([xr;mr;ar;sr],[],2) + 1);
        elseif ~strcmp(nextwf,'R')
            stack(end+1,:) = [ find(strcmp(keys,nextwf)), xr, mr, ar, sr ];
        end
        if(c) % restore remaining range and continue
            eval([c,'r=new',c,'r;']);
        end
    end
end
part2 = asum
toc
