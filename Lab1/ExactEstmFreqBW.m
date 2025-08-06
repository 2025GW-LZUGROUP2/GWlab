function FreqBandWidth = ExactEstmFreqBW(s_t,sym_var, timeInterval, varargin)
% ExactEstmFreqBW 通过PSO算法更精确地估算频率带宽(Frequency Band Width)
%
% 输入：
%   s_t: 符号函数，如sin(2*pi*(3*t^3+3*t^2+10*t))
%   sym_var：符号变量，如sym('t') （即s_t中的变量）
%   timeInterval: 时间区间，如[0,1]（a=0, b=1）
%   varargin: 采样率fs，默认自动估计可选参数（使用estmFreqBW函数粗估）
% 输出：
%   FreqBandWidth: 覆盖99%能量的最小频率

%% 参数预处理
a = timeInterval(1); b = timeInterval(2);
if isempty(varargin)
    fs = 5*2*estmFreqBW(s_t,sym_var, a, b); % 自动估计采样率
else
    fs = varargin{1};
end
delta = 1/fs;                % 采样间隔
timeVec = a:delta:b;         % 离散时间向量
sVec = double(subs(s_t, sym_var, timeVec)); % 离散信号
N = length(timeVec);         % 采样点数

%% 频域计算（FFT+ESD+总能量）
foufun = fftshift(fft(sVec));               % 双边FFT
freqVec = ((0:N-1)-floor(N/2))*(fs/N);      % 双边频率轴（1D）
ESD = delta^2 * abs(foufun).^2;             % 能量谱密度（ESD）
allEnergy = trapz(timeVec, sVec.^2);        % 时域总能量（帕塞瓦尔定理验证）

%% 定义目标函数（避免trapz报错）
objFun = @(mf) (getEnergy(mf, freqVec, ESD) - 0.99*allEnergy).^2;

%% 动态扩展的PSO全局探索
initialUB = 100;       % 初始上界（Hz）
popSize = 50;          % 种群大小（平衡探索与效率）
maxGen = 200;          % 每轮PSO最大迭代次数
expandThreshold = 0.9; % 最优解超过上界×0.9则扩展

currentUB = initialUB;
psoOpts = optimoptions(...
    'particleswarm', ...
    'Display', 'off', ...       % 关闭迭代显示（需调试时设为'iter'）
    'SwarmSize', popSize, ...
    'MaxIterations', maxGen, ...
    'InertiaRange', [0.3, 0.7], ... % 惯性权重（平衡探索与收敛）
    'SocialAdjustmentWeight', 1.5, ... % 群体学习因子
    'SelfAdjustmentWeight', 1.5); % 自身学习因子

% 动态扩展循环
while true
    [psoSol, ~] = particleswarm(objFun, 1, 0, currentUB, psoOpts);
    
    % 检查是否需要扩展上界（最优解接近当前上界）
    if psoSol > currentUB * expandThreshold
        currentUB = currentUB * 2; % 上界翻倍
        fprintf('信号带宽超过当前上界，扩展到：%d Hz\n', currentUB);
    else
        break; % 找到有效带宽范围，停止扩展
    end
end

%% 局部梯度优化（快速收敛）
localOpts = optimoptions('fminunc', ...
    'Display', 'off', ...       % 关闭迭代显示
    'GradObj', 'off', ...       % 用数值梯度（无需解析表达式）
    'MaxFunctionEvaluations', 1e4);

[localSol, ~] = fminunc(objFun, psoSol, localOpts);

%% 有效性验证（确保能量覆盖≥99%）
energyCovered = getEnergy(localSol, freqVec, ESD);
while energyCovered < 0.99*allEnergy
    localSol = localSol * 1.02; % 小幅增大FreqBandWidth（2%步长）
    energyCovered = getEnergy(localSol, freqVec, ESD);
end

FreqBandWidth = localSol;
fprintf('最终FreqBandWidth：%.2f Hz（覆盖能量：%.4f%%）\n', ...
    FreqBandWidth, energyCovered/allEnergy*100);
end
