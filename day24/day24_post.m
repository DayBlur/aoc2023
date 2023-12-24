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


%% Part 2 - symbolic solve
% clc;
tic;
syms xsx xsy xsz vsx vsy vsz t1 t2 t3 integer
S = solve(pos(1,1)+vel(1,1)*t1==xsx+vsx*t1,pos(2,1)+vel(2,1)*t2==xsx+vsx*t2,pos(3,1)+vel(3,1)*t3==xsx+vsx*t3,...
          pos(1,2)+vel(1,2)*t1==xsy+vsy*t1,pos(2,2)+vel(2,2)*t2==xsy+vsy*t2,pos(3,2)+vel(3,2)*t3==xsy+vsy*t3,...
          pos(1,3)+vel(1,3)*t1==xsz+vsz*t1,pos(2,3)+vel(2,3)*t2==xsz+vsz*t2,pos(3,3)+vel(3,3)*t3==xsz+vsz*t3);
part2 = S.xsx + S.xsy + S.xsz
toc


%% Part 2 - cross product
% p0 + ti*v0 = pi + ti*vi -> (p0 - pi) = -ti*(v0 - vi)
% parallel vectors, so: (p0 - pi) x (v0 - vi) = 0
% expand: (p0 x v0) - (p0 x vi) - (pi x v0) + (pi x vi) = 0
% equate for i=1 and i=2:
%   (p0 x v0) - (p0 x v1) - (p1 x v0) + (p1 x v1) = (p0 x v0) - (p0 x v2) - (p2 x v0) + (p2 x v2)
%   -(p0 x v1) - (p1 x v0) + (p1 x v1) = -(p0 x v2) - (p2 x v0) + (p2 x v2)
% introduce the skew-symmetric matrix operator: a x b = [ax]b
%   [v1x]p0 - [p1x]v0 - [v2x]p0 + [p2x]v0 = (p2 x v2) - (p1 x v1)
% rearrange to get linear form in the unknown vectors:
%   ([v1x] - [v2x])*p0 + ([p2x] - [p1x])*v0 = [p2x]*v2 - [p1x]*v1
% repeat for i=1 and i=3
%   ([v1x] - [v3x])*p0 + ([p3x] - [p1x])*v0 = [p3x]*v2 - [p1x]*v1
% use these last two equations to set up 6 linear equations
%   y = Hx where x is [p0;v0]

% clc;
tic;
skew = @(x) [ 0 -x(3) x(2); x(3) 0 -x(1); -x(2) x(1) 0 ];
p1x = skew(pos(1,:));
p2x = skew(pos(2,:));
p3x = skew(pos(3,:));
v1 = vel(1,:)';
v1x = skew(v1);
v2 = vel(2,:)';
v2x = skew(v2);
v3 = vel(3,:)';
v3x = skew(v3);
y = [ p2x*v2 - p1x*v1; p3x*v3 - p1x*v1 ]; 
H = [ v1x-v2x, p2x-p1x; v1x-v3x, p3x-p1x ];
x = round(H\y);
part2 = int64(sum(x(1:3)))
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
