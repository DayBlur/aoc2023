% ===== AOC2023 Day 14 [DayBlur] =====

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
extmap = [ ones(1,width+2)*'#'; ones(height,1)*'#', basemap, ones(height,1)*'#'; ones(1,width+2)*'#'];
% char(extmap)

%% Part 1
% clc;
tic;
map = extmap;
load = 0;
for j=1:width
    line = map(:,1+j);
     breaks = find(line=='#');
     for i=1:length(breaks)-1
         b = breaks(i:i+1);
         n = sum((line(b(1):b(2))=='O'));
         w = height-b(1)+1;
         load = load + sum(w-(1:n)+1);
     end
end
part1 = load
toc

%% Part 2
% clc;
tic;
modone = @(x,m) mod(x-1,m)+1;
map = extmap;
Nlast = 100; % cycle length history to check for repeating pattern (must be at least two times the cycle length)
lastn = zeros(1,Nlast);
Ncyc = 1000000000;
span = 1:width+2;
spanr = fliplr(span);
for k = 1:Ncyc
    % perform cycle
    for dir=1:4
        for j=1:width % square input
            if dir==1
                r = span;
                c = j+1;
            elseif dir==2
                r = j+1;
                c = span;
            elseif dir==3
                r = spanr;
                c = j+1;
            elseif dir==4
                r = j+1;
                c = spanr;
            end
            line = map(r,c);    
            breaks = find(line=='#');
            for i=1:length(breaks)-1
                b = breaks(i:i+1);
                n = sum((line(b(1):b(2))=='O'));
                % shift blocks within region
                line(b(1)+(1:n)) = 'O';
                line((b(1)+n+1):(b(2)-1)) = '.';
                map(r,c) = line;
            end
        end
    end
    
    % compute load
    load = 0;
    for j=1:width
        line = map(:,1+j);
        rocks = find(line=='O');
        t = sum(height+2-rocks);
        load = load + t;
    end
    idx = modone(k,Nlast);
    lastn(idx) = load;
    if k < Nlast, continue; end % wait for history to fill
    
    % look for repeating pattern    
    found = false;
    lastm = lastn(modone(idx:-1:(idx-Nlast+1),Nlast));
    for j=1:Nlast/2
        seg = lastm(1:j);
        Nrep = floor(Nlast/length(seg));
        repseg = repmat(seg,1,Nrep);
        Ns = length(repseg);
        if all(lastm(1:Ns) == repseg)
            loadidx = modone(k-Ncyc+1,length(seg));
            load = seg(loadidx);
            found = true;
            break;
        end
    end
    if found, break; end
end
part2 = load
toc
