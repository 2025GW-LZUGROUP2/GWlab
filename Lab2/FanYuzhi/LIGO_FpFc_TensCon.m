clear all; close all; clc;

% 定义球坐标系中的角度范围
thetaVec = linspace(0, pi, 200);   % 极角(与z轴夹角)，0到π
phiVec = linspace(0, 2 * pi, 400);   % 方位角(绕z轴旋转)，0到2π
psi = pi/6; % 极化角

% Detector frame中单位球面上一点(phi,theta)在直角坐标系下的分量(X,Y,Z)
[phi, theta] = meshgrid(phiVec, thetaVec); % 注意meshgird参数顺序！
X = sin(theta) .* cos(phi);
Y = sin(theta) .* sin(phi);
Z = cos(theta);

% Detector tensor of LIGO
DetTensor = ([1,0,0]'*[1,0,0]-[0,1,0]'*[0,1,0]) ./ 2;

%Generate function values for F_plus and F_cross
F_plus = zeros(length(thetaVec),length(phiVec));
F_cross = zeros(length(thetaVec),length(phiVec));

for j = 1:length(thetaVec)
    for k = 1:length(phiVec)
        [F_plus(j,k),F_cross(j,k)] = FpFcinDetFrame(thetaVec(j),phiVec(k),psi,DetTensor);
    end
end

%Plot

figure;

SurfacePlot(X,Y,Z,abs(F_plus));
title(sprintf('F_+(\\theta,\\phi) with \\psi = %.2f^\\circ', psi/pi*180));


figure;
SurfacePlot(X,Y,Z,abs(F_cross));
title(sprintf('F_\\times(\\theta,\\phi) with \\psi = %.2f^\\circ', psi/pi*180));





