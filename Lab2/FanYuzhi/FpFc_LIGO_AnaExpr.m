clear all; close all; clc;

% 定义球坐标系中的角度范围
thetaVec = linspace(0, pi, 200);   % 极角(与z轴夹角)，0到π
phiVec = linspace(0, 2 * pi, 400);   % 方位角(绕z轴旋转)，0到2π


% 解析表达式绘制 Antenna Patterns
F_plus = @(x,y) 0.5*(1+cos(x)^2)*cos(2*y);
F_cross = @(x,y) cos(x)*sin(2*y);

figure;
SkyPlot(thetaVec, phiVec, F_plus);
title('F_+(\theta,\phi)');

figure;
SkyPlot(thetaVec, phiVec, F_cross);
title('F_\times(\theta,\phi)');



