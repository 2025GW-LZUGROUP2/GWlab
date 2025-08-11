clearvars; close all; clc;

% 定义时间范围和 h_+(t), h_×(t) 函数
A = 1; % 幅度
B = 1;
f0 = 0.001; % 频率：1 mHz (周期 1000 秒)
phi0 = pi/6; % 相位

time = linspace(0, 2700, 4000); % 一天（86400秒），1000帧
h_plus = SinSigGen(time, A, f0, 0);
h_cross = SinSigGen(time, B, f0, phi0);

% 定义球坐标系中的角度范围（降低分辨率以提高性能）
thetaVec = linspace(0, pi, 30);   % 极角，30
phiVec = linspace(0, 2 * pi, 60); % 方位角，60
psi = pi/6; % 极化角

% Detector frame中单位球面上一点(phi,theta)在直角坐标系下的分量(X,Y,Z)
[phiGrid, thetaGrid] = meshgrid(phiVec, thetaVec);
X = sin(thetaGrid) .* cos(phiGrid);
Y = sin(thetaGrid) .* sin(phiGrid);
Z = cos(thetaGrid);

% 扁平化坐标以便一次性向量化计算
thetaFlat = thetaGrid(:);
phiFlat = phiGrid(:);

% Detector tensors of LISA
[Phi, E, Sp1path, Sp2path, Sp3path, ~, ~, ~, R] = simu_LISA_orbits();
Sp1path = Sp1path(:, 1:length(Sp1path)-1);

% 计算臂向量 n1,n2,n3（仅取第一天的数据）
n1 = Sp2path(:,1) - Sp3path(:,1); % 使用第一天的数据
n2 = Sp3path(:,1) - Sp1path(:,1);
n3 = Sp1path(:,1) - Sp2path(:,1);

% 构造两个探测器的张量（3x3 each，固定为第一天）
DetTensor1 = (n1*n1' - n2*n2') ./ 2;
DetTensor2 = (n1*n1' + n2*n2' - 2*n3*n3') ./ (2*sqrt(3));

% 向量化计算整张球面的 F_+, F_x（仅计算一次）
[Fp1_flat, Fc1_flat] = FpFcinDetFrame(thetaFlat, phiFlat, psi, DetTensor1);
[Fp2_flat, Fc2_flat] = FpFcinDetFrame(thetaFlat, phiFlat, psi, DetTensor2);

% reshape 回网格形式
Fp1 = reshape(Fp1_flat, size(thetaGrid));
Fc1 = reshape(Fc1_flat, size(thetaGrid));
Fp2 = reshape(Fp2_flat, size(thetaGrid));
Fc2 = reshape(Fc2_flat, size(thetaGrid));

% 准备绘图：创建两个 surf 对象
figure('Color', 'w', 'Name', 'LISA strain', 'WindowState', 'maximized');
subplot(1, 2, 1); h1 = surf(X, Y, Z, zeros(size(X))); axis equal; shading interp; title('Strain s(t) (Detector tensor I)');
subplot(1, 2, 2); h2 = surf(X, Y, Z, zeros(size(X))); axis equal; shading interp; title('Strain s(t) (Detector tensor II)');

% 使球面上的颜色独立于顶点法线
set([h1 h2], 'EdgeColor', 'none', 'FaceColor', 'interp');

% 添加颜色条
%colorbar('peer', subplot(1,2,1));
%colorbar('peer', subplot(1,2,2));

% 为每个子图设置颜色映射
ax1 = get(h1, 'Parent');
ax2 = get(h2, 'Parent');
colormap(ax1, 'jet');
colormap(ax2, 'jet');

% 在图的右边添加说明文字
txtHandle = annotation('textbox', [0.85, 0.85, 0.15, 0.1], ...
    'String', '', 'FontSize', 12, 'EdgeColor', 'none', ...
    'BackgroundColor', 'w');


% 主循环：每个时间步更新应变
numSteps = length(time); % 1000帧
for i = 1:1:numSteps
    % 获取当前时间步的 h_+(t), h_×(t)
    h_plus_t = h_plus(i);
    h_cross_t = h_cross(i);
    
    % 计算应变 s(t) = F_+ * h_+ + F_× * h_×
    s1 = Fp1 * h_plus_t + Fc1 * h_cross_t; % Detector tensor I
    s2 = Fp2 * h_plus_t + Fc2 * h_cross_t; % Detector tensor II
    
    % 更新两个 surf 的颜色数据（使用绝对值）
    set(h1, 'CData', abs(s1));
    set(h2, 'CData', abs(s2));
    
    % 设置统一的颜色范围
    c_range = [min([abs(s1(:)); abs(s2(:))]), max([abs(s1(:)); abs(s2(:))])];
    caxis(ax1, c_range);
    caxis(ax2, c_range);
    
    % 更新右侧说明栏
    timeStr = sprintf('Time: %.2f s', time(i));
    set(txtHandle, 'String', timeStr);
    
    drawnow limitrate; % 优化刷新性能
    
end