% ===== AOC2023 Day 24 [DayBlur] =====

%% Read file, line processing
clear;
clc;
% filename = 'example.txt';
filename = 'input.txt';
data = fileread(filename);
lines = splitlines(strtrim(data));
N = length(lines);
pos = zeros(N,3);
vel = zeros(N,3);
for i=1:N
    line = lines{i};
    parts = strsplit(line,'@');
    pos(i,:) = str2num(strtrim(parts{1}));
    vel(i,:) = str2num(strtrim(parts{2}));
end

%% Part 1
% clc;
tic;
% bounds = [7,27;7,27]; % for example
bounds = [200000000000000,400000000000000;200000000000000,400000000000000];

numisct = 0;
for i=1:N
    for j=i+1:N
        t = ([vel(i,1:2)' -vel(j,1:2)'])\(pos(j,1:2)' - pos(i,1:2)');
        if any(~isfinite(t) | t<0) continue; end
        p = pos(i,1:2) + vel(i,1:2).*t(1);
%         p2 = pos(j,1:2) + vel(j,1:2).*t(2);
%         assert(norm(p-p2)/norm(p) < 1e-9);
        if p(1)>=bounds(1,1) && p(1)<=bounds(1,2) && p(2)>=bounds(2,1) && p(2)<=bounds(2,2)
            numisct = numisct + 1;
        end
    end
end
part1 = numisct
toc


%% Part 2 - GLSDC (nonlinear iterated least squares)
% clc;
tic;
Np = 3; % only need 3 points to find solution
% Np = N; % but works just fine with all 300 pts too
Nx = 6 + Np; % states are initial position, initial velocity, and Np collision times
Ny = 3*Np; % measurements are hailstone positions at collision times

% normalize inputs to avoid inverting singular matrix (scale back at end)
posscale = 10^-ceil(log10(max(abs(pos),[],'all')));
velscale = 10^-ceil(log10(max(abs(vel),[],'all')));
p = pos(1:Np,:)*posscale;
v = vel(1:Np,:)*velscale;

H = zeros(Ny,Nx); % Jacobian / linear observation matrix
y = zeros(Ny,1); % actual measurements
yhat = zeros(Ny,1); % predicted/estimated measurements
xhat = 0.1*(1:Nx)'; % ensure initial observation matrix is full rank
% xhat = randn(Nx,1);

Ni = 50; % should generally need less than 20
numiters = 0;
dx = Inf;
while norm(dx) > 1e-9 && numiters < Ni
    pidx = 1:3;
    vidx = 4:6;
    xs = xhat(pidx);
    vs = xhat(vidx);
    for i=1:Np
        tidx = 6+i;
        yidx = (3*(i-1))+(1:3);
        ti = xhat(tidx);
        xi = p(i,:)';
        vi = v(i,:)';
        y(yidx) = xi;
        yhat(yidx) = xs + vs*ti -vi*ti;
        H(yidx,pidx) = eye(3);
        H(yidx,vidx) = ti*eye(3);
        H(yidx,tidx) = vs - vi;
    end
    dy = y - yhat; % innovation
    dx = (H'*H)\H'*dy; % compute correction
    xhat = xhat + dx; % apply correction
    numiters = numiters + 1;
end
phat = round(xhat(1:3)/posscale);
vhat = round(xhat(4:6)/velscale);
that = round(xhat(7:end)*velscale/posscale);
if numiters < Ni
    part2 = int64(sum(phat))
else
    error('Could not converge on solution')
end
toc
