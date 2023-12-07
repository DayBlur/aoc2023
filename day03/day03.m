% ===== AOC2023 Day 03 [DayBlur] =====

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
map = ones(height+2,width+2).*'.';
map(2:end-1,2:end-1) = basemap;
[height,width] = size(map);

isnum = map>='0' & map <='9';
issym = ~isnum & map~='.';


%% Part 1
% clc;
tmpsum = 0;
for i=2:height-1
    j = 2;
    while j <= width-1
        if isnum(i,j)
            start = j;
            while isnum(i,j)
                j = j + 1;
            end
            last = j - 1;
            val = str2double(char(map(i,start:last)));
            if any([issym(i,start-1), issym(i,last+1), any(issym(i-1,start-1:last+1)), any(issym(i+1,start-1:last+1)) ])
                tmpsum = tmpsum + val;
            end
        end
        j = j + 1;
    end
end
part1 = tmpsum

%% Part 2
% clc;
tmpsum = 0;
gear = 0*map;
ratio = ones(size(map));
for i=2:height-1
    j = 2;
    while j <= width-1
        if isnum(i,j)
            start = j;
            while isnum(i,j)
                j = j + 1;
            end
            last = j - 1;
            val = str2double(char(map(i,start:last)));
            if any([issym(i,start-1), issym(i,last+1), any(issym(i-1,start-1:last+1)), any(issym(i+1,start-1:last+1)) ])
                tmpsum = tmpsum + val;
                if issym(i,start-1)
                    gear(i,start-1) = gear(i,start-1) + 1;
                    ratio(i,start-1) = ratio(i,start-1)*val;
                end
                if issym(i,last+1)
                    gear(i,last+1) = gear(i,last+1) + 1;
                    ratio(i,last+1) = ratio(i,last+1)*val;
                end
                if any(issym(i-1,start-1:last+1))
                    i2 = find(issym(i-1,start-1:last+1));
                    gear(i-1,start-2+i2) = gear(i-1,start-2+i2) + 1;
                    ratio(i-1,start-2+i2) = ratio(i-1,start-2+i2)*val;
                end
                if any(issym(i+1,start-1:last+1))
                    i2 = find(issym(i+1,start-1:last+1));
                    gear(i+1,start-2+i2) = gear(i+1,start-2+i2) + 1;
                    ratio(i+1,start-2+i2) = ratio(i+1,start-2+i2)*val;
                end
            end
        end
        j = j + 1;
    end
end
part2 = sum(ratio(gear==2))
