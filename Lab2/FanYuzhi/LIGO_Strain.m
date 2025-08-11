clear all; close all; clc;

% 定义球坐标系中的角度范围
thetaVec = linspace(0, pi, 200);   % 极角(与z轴夹角)，0到π
phiVec = linspace(0, 2 * pi, 400); % 方位角(绕z轴旋转)，0到2π
psi = pi/6; % 极化角

% Detector frame中单位球面上一点(phi,theta)在直角坐标系下的分量(X,Y,Z)
[phi, theta] = meshgrid(phiVec, thetaVec); % 注意meshgird参数顺序！
X = sin(theta) .* cos(phi);
Y = sin(theta) .* sin(phi);
Z = cos(theta);

% Detector tensor of LIGO
DetTensor = ([1,0,0]'*[1,0,0]-[0,1,0]'*[0,1,0]) ./ 2;

% Generate function values for F_plus and F_cross
F_plus = zeros(length(thetaVec), length(phiVec));
F_cross = zeros(length(thetaVec), length(phiVec));

for j = 1:length(thetaVec)
    for k = 1:length(phiVec)
        [F_plus(j,k), F_cross(j,k)] = FpFcinDetFrame(thetaVec(j), phiVec(k), psi, DetTensor);
    end
end

% 定义时间范围和 h_+(t), h_×(t) 函数
A = 1;
B = 1;
f0 = 40;
phi0 = pi/6;

time = linspace(0, 10, 100); % 时间范围，0到10秒，100帧
h_plus = SinSigGen(time,A,f0,0);
h_cross = SinSigGen(time,B,f0,phi0);

%strain = zeros(length(time),length(thetaVec), length(phiVec));

% 预计算整个动画的最大应变值
max_strain = 0;
for i = 1:length(time)
    strain_abs = abs(h_plus(i) .* F_plus + h_cross(i) .* F_cross);
    max_strain = max(max_strain, max(strain_abs(:)));
end

% 创建动画并准备保存为 GIF
figure;

% GIF 文件名
filename = 'LIGO Strain.gif';

% 动画循环
for i = 1:length(time)
    SurfacePlot(X, Y, Z, abs(h_plus(i) .* F_plus + h_cross(i) .* F_cross));
    title(sprintf('s(t) with \\psi = %.2f^\\circ, t = %.2f s', psi/pi*180, time(i)));
    caxis([0, max_strain]); % 固定颜色范围

    drawnow; % 刷新图像
    %pause(0.01); % 控制动画速度，每帧暂停0.05秒
    frame = getframe(gcf); % 获取当前图形窗口的帧
    im = frame2im(frame); % 将帧转换为图像
    [imind, cm] = rgb2ind(im, 256); % 转换为索引图像，256 种颜色

    % 保存为 GIF
    if i == 1
        % 写入第一帧，创建 GIF 文件
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
    else
        % 追加后续帧
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
    end
end