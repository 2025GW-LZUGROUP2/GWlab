clear all; close all; clc;

% 定义球坐标系中的角度范围
THETA = linspace(0, pi, 200);   % 极角(与z轴夹角)，0到π
PHI = linspace(0, 2 * pi, 200);   % 方位角(绕z轴旋转)，0到2π

[Theta, Phi] = meshgrid(THETA, PHI);

X = sin(Theta) .* cos(Phi);
Y = sin(Theta) .* sin(Phi);
Z = cos(Theta);

D = ([1,0,0]' * [1,0,0] - [0,1,0]' * [0,1,0]) / 2;

f_plus = zeros(length(THETA), length(PHI));
f_cross = zeros(length(THETA), length(PHI));

for j = 1:length(THETA)
    for k = 1:length(PHI)

        phi = PHI(j); theta = THETA(k);
        n = [sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta)];
        z = [0, 0, 1];
        x = cross(z, n);
        y = cross(x, n);

        x = x / norm(x);
        y = y / norm(y);

        e_plus = x' * x - y' * y;
        e_cross = x' * y + y' * x;

        f_plus(j, k) = sum(e_plus(:) .* D(:));
        f_cross(j, k) = sum(e_cross(:) .* D(:));
    end
end

figure;
surf(X, Y, Z, abs(f_cross));
shading interp;
axis equal;
colorbar;
figure;
surf(X, Y, Z, abs(f_plus));
shading interp;
axis equal;
colorbar;