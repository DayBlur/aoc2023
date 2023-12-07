% ===== AOC2023 Day 04 [DayBlur] =====

%% Read file, line processing
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(strtrim(data));
numlines = length(lines);
for i=1:numlines
    line = lines{i};
    parts = strsplit(line, {':','|'});
    win{i} = sscanf(parts{2},'%d');
    card{i} = sscanf(parts{3},'%d');
    match{i} = intersect(card{i},win{i});
end


%% Part 1
% clc;
ptsum = 0;
for i=1:numlines    
    if isempty(match{i})
        points = 0;
    else
        points = 2.^(length(match{i})-1);
    end
    ptsum = ptsum + points;
end
part1 = ptsum

%% Part 2
% clc;
% expand wins for each card
counts = zeros(numlines);
for i=1:numlines
    if isempty(match{i})
        points = 0;
    else
        idxs = i+(1:length(match{i}));
        counts(i,idxs) = 1;
    end    
end
% sum each card type and roll over to later cards
counts = counts + eye(numlines);
numcards = zeros(1,numlines);
for i=1:numlines
    numcards(i) = sum(counts(:,i));
    counts(i,:) = counts(i,:)*numcards(i);
end
part2 = sum(numcards)
