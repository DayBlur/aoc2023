% ===== AOC2023 Day 20 [DayBlur] =====

%% Read file, line processing
clear;
clc;
% filename = 'example.txt';
% filename = 'example2.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(strtrim(data));
N = length(lines);
in = {};
type = {};
out = {};
for i=1:N
    line = lines{i};
    parts = strsplit(line,' -> ');
    part = parts{1};
    if strcmp(part,'broadcaster')
        type{i} = part;
        in{i} = part;
    else
        type{i} = part(1);
        in{i} = part(2:end);        
    end
    out{i} = strsplit(parts{2}, ', ');
end

revin = {};
state = [];
for i=1:N
    switch type{i}
        case '&'
            temprev = [];
            for j=1:N            
                if any(strcmp(out{j},in{i}))
                    temprev(end+1) = j;
                end
            end
            revin{i} = temprev;
            state{i} = 0*temprev;
        case '%'
            state{i} = 0;
        case 'broadcaster'
            state{i} = 0;
    end
end
basestate = state;

%% Part 1+2
clc;
tic;
pulseseq = [];
pushes = 0;
state = basestate;

% Part 1
Np = 1000;

% Part 2 based on input file inspection (with assetions)
%  approach: find inputs to 'rx' output to minitor their periodicity
tmpidx = [];
for i=1:N
    if any(strcmp(out{i},'rx'))
        tmpidx(end+1) = i;
    end
end
assert(length(tmpidx)==1 && strcmp(type{tmpidx},'&'));
testseqs = {};
testmods = {};
for i=1:N
    if any(strcmp(out{i},in{tmpidx}))
        testseqs{end+1} = [];
        testmods{end+1} = in{i};
    end
end

part1 = 0;
part2 = 0;
while ~part1 || ~part2
    module = {'broadcaster'};
    pulse = 0;
    from = {'button'};
    pushes = pushes + 1;
    while ~isempty(module)
        nextmodule = {};
        nextpulse = [];
        nextfrom = {};
        for i=1:length(module)
            ni = module{i};
            pi = pulse(i);
            fi = from{i};
            pulseseq(end+1) = pi;
%             fprintf('%s (%d) -> (%s)\n', fi, pi, ni);
            if ~pi && strcmp(ni,'rx') % will never reach here in practice
                part2 = pushes
                return;
            end
            for k=1:length(testmods)
                if ~pi && strcmp(ni,testmods{k})
                    testseq = testseqs{k};
                    testseq(end+1) = pushes;
                    testseqs{k} = testseq;
                end
            end
            nidx = find(strcmp(in,ni));
            if isempty(nidx)
                continue;
            end
            fidx = find(strcmp(in,fi));
            outs = out{nidx};
            switch type{nidx}
                case '%'
                    if ~pi
                        state{nidx} = ~state{nidx};
                        for k=1:length(outs)
                            nextmodule{end+1} = outs{k};
                            nextpulse(end+1) = state{nidx};
                            nextfrom{end+1} = ni;
                        end
                    else
                        % nothing
                    end
                case '&'
                    s = state{nidx};
                    sidx = find(revin{nidx}==fidx);
                    s(sidx) = pi;
                    state{nidx} = s;
                    for k=1:length(outs)
                        nextmodule{end+1} = outs{k};
                        nextfrom{end+1} = ni;
                        if all(state{nidx})
                            nextpulse(end+1) = 0;
                        else
                            nextpulse(end+1) = 1;
                        end
                    end
                case 'broadcaster'
                    for k=1:length(outs)
                        nextmodule{end+1} = outs{k};
                        nextpulse(end+1) = pi;
                        nextfrom{end+1} = ni;
                    end
            end
        end
        module = nextmodule;
        pulse = nextpulse;
        from = nextfrom;
    end
    if pushes == Np
        lows = length(find(~pulseseq));
        highs = length(find(pulseseq));
        part1 = lows*highs
        toc
    end
    grouplcm = 1;
    for i=1:length(testmods)
        if length(testseqs{i}) < 2 % < 3 to check for offset pattern
            grouplcm = 0;
            break;
        end
        period = diff(testseqs{i});
%         assert(period(1)==period(2));  % check for offset pattern
        grouplcm = lcm(grouplcm,period(1)); % periods seem coprime, okay to just multiply
    end
    if grouplcm > 0
        part2 = grouplcm
        toc;
    end
end
