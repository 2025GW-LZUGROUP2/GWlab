clear all; close all; clc;

% 定义球坐标系中的角度范围
theta = linspace(0, 2 * pi, 200);   % 极角(与z轴夹角)，0到π
phi = linspace(0, pi, 200);   % 方位角(绕z轴旋转)，0到2π

% 创建网格数据
[Theta, Phi] = meshgrid(theta, phi);

X = sin(Theta) .* cos(Phi);
Y = sin(Theta) .* sin(Phi);
Z = cos(Theta);

% 计算函数值 f_cross
f_cross = cos(Theta) .* sin(2 * Phi);

% 计算函数值 f_plus
f_plus = 0.5 * (1 + cos(Theta) .^ 2) .* cos(2 * Phi);

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