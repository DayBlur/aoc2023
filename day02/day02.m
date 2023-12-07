% ===== AOC2023 Day 02 [DayBlur] =====

%% Read file, line processing
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(strtrim(data));
numlines = length(lines);
rgb = zeros(numlines,3);
for i=1:numlines
    line = lines{i};
    parts = strsplit(line,':');
    parts2 = strsplit(parts{2},';');
    for j=1:length(parts2)
        tmp = strsplit(parts2{j},',');
        for k=1:length(tmp)
            tmp2 = strsplit(strtrim(tmp{k}),' ');
            cnt = str2double(tmp2{1});
            if contains(tmp2{2},'red')
                rgb(i,1) = max(rgb(i,1),cnt);
            elseif contains(tmp2{2},'green')
                rgb(i,2) = max(rgb(i,2),cnt);
            elseif contains(tmp2{2},'blue')
                rgb(i,3) = max(rgb(i,3),cnt);
            end            
        end
    end    
end

%% Part 1
% clc;
part1 = sum(find(all(rgb <= [12,13,14],2)))

%% Part 2
% clc;
part2 = sum(prod(rgb,2))
