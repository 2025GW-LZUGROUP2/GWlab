clearvars; close all; clc;

% 定义球坐标系中的角度范围（可根据需要调整分辨率）
thetaVec = linspace(0, pi, 50);   % 极角
phiVec = linspace(0, 2 * pi, 100); % 方位角
psi = pi/6; % 极化角

% Detector frame中单位球面上一点(phi,theta)在直角坐标系下的分量(X,Y,Z)
[phiGrid, thetaGrid] = meshgrid(phiVec, thetaVec); % 注意meshgrid参数顺序
X = sin(thetaGrid) .* cos(phiGrid);
Y = sin(thetaGrid) .* sin(phiGrid);
Z = cos(thetaGrid);

% 扁平化坐标以便一次性向量化计算（与FpFcinDetFrame输入格式对应）
thetaFlat = thetaGrid(:);
phiFlat = phiGrid(:);

% Detector tensors of LISA
[Phi, E, Sp1path, Sp2path, Sp3path, ~, ~, ~, R] = simu_LISA_orbits();
Sp1path = Sp1path(:,1:length(Sp1path)-1);


% 计算臂向量 n1,n2,n3（每列对应一个时间步）
n1 = Sp2path - Sp3path; % 3 x N
n2 = Sp3path - Sp1path;
n3 = Sp1path - Sp2path;

% 准备绘图：创建四个 surf 对象并保留句柄用于更新
figure('Color','w','Name','LISA antenna patterns','WindowState', 'maximized');
subplot(2,2,1); h1 = surf(X, Y, Z, zeros(size(X))); axis equal; shading interp; title('F_+ (Detector tensor I)');
subplot(2,2,2); h2 = surf(X, Y, Z, zeros(size(X))); axis equal; shading interp; title('F_\times (Detector tensor I)');
subplot(2,2,3); h3 = surf(X, Y, Z, zeros(size(X))); axis equal; shading interp; title('F_+ (Detector tensor II)');
subplot(2,2,4); h4 = surf(X, Y, Z, zeros(size(X))); axis equal; shading interp; title('F_\times (Detector tensor II)');

% 使球面上的颜色独立于顶点法线（可选视觉调整）
set([h1 h2 h3 h4],'EdgeColor','none','FaceColor','interp');

numSteps = length(Phi) - 1; % 与原代码保持一致

% 在图的右边添加说明文字（初始为空）
txtHandle = annotation('textbox', [0.82, 0.4, 0.15, 0.1], ...
    'String', '', 'FontSize', 12, 'EdgeColor', 'none', ...
    'BackgroundColor', 'w');

gifFile = 'LISA_AntennaPatterns.gif'; % 输出文件名
isFirstFrame = true;

% 主循环：每个时间步一次性计算整张球面的响应并更新 surf 的 CData
for i = 1:1:numSteps
    % 构造两个探测器的张量（3x3 each）
    ni1 = n1(:,i);
    ni2 = n2(:,i);
    ni3 = n3(:,i);
    
    DetTensor1 = (ni1*ni1' - ni2*ni2') ./ 2;
    DetTensor2 = (ni1*ni1' + ni2*ni2' - 2*ni3*ni3') ./ (2*sqrt(3));
    
    % 向量化一次性计算整张球面的 F_+, F_x
    [Fp1_flat, Fc1_flat] = FpFcinDetFrame(thetaFlat, phiFlat, psi, DetTensor1);
    [Fp2_flat, Fc2_flat] = FpFcinDetFrame(thetaFlat, phiFlat, psi, DetTensor2);
    
    % reshape 回网格形式
    Fp1 = reshape(Fp1_flat, size(thetaGrid));
    Fc1 = reshape(Fc1_flat, size(thetaGrid));
    Fp2 = reshape(Fp2_flat, size(thetaGrid));
    Fc2 = reshape(Fc2_flat, size(thetaGrid));
    
    % 更新四个 surf 的颜色数据（绝对值或按需显示原始值）
    set(h1, 'CData', abs(Fp1));
    set(h2, 'CData', abs(Fc1));
    set(h3, 'CData', abs(Fp2));
    set(h4, 'CData', abs(Fc2));
        
    % 更新右侧说明栏
    timeStr = sprintf('Day: %d / %d \n Phi: %.3f^\\circ', i, numSteps, Phi(i)/pi*180);
    set(txtHandle, 'String', timeStr);
        
    drawnow; % 刷新图像
    
    % ======= 保存当前帧到 GIF =======
    frame = getframe(gcf); % 抓取当前 figure
    im = frame2im(frame);  % 转换成图像数据
    [A,map] = rgb2ind(im,256); % 转换为索引色图，256色
    if isFirstFrame
        imwrite(A,map,gifFile,'gif','LoopCount',Inf,'DelayTime',0.1);
        isFirstFrame = false;
    else
        imwrite(A,map,gifFile,'gif','WriteMode','append','DelayTime',0.1);
    end
end
