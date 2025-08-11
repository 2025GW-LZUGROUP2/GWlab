function results = run_final_lab_fast(varargin)
%RUN_FINAL_LAB_FAST 优化的引力波信号检测算法
%   RESULTS = RUN_FINAL_LAB_FAST() 使用默认参数设置运行快速引力波参数估计。
%   
%   RESULTS = RUN_FINAL_LAB_FAST(Name,Value,...) 允许通过名值对参数自定义设置。
%   
%   此函数实现了一个优化的引力波参数估计算法，使用PSD预计算、批量FFT矢量化和并行PSO
%   优化，以显著提高速度。
%   
%   输入参数（名值对）：
%      'Bounds'       - [rmin; rmax] 参数搜索边界[下界; 上界] 
%             %% 

%      'Iters'        - 每次PSO运行的迭代次数
%                       默认: 100
%      'PopSize'      - PSO粒子群中的粒子数量
%                       默认: 100
%      'NRuns'        - 独立PSO运行的次数
%                       默认: 200（建议：200-500；更大数量建议启用并行）
%      'UseParallel'  - 是否启用并行处理（如有可能）
%                       默认: true（如存在并行计算工具箱则使用parfor）
%      'WelchNperseg' - Welch PSD估计的段长度
%                       默认: 256（与Python实现一致）
%      'PSDHalf'      - 是否将单边PSD除以2
%                       默认: true（与Python实现一致）
%   
%   输出：
%      results - 包含优化结果的结构体，字段包括：
%                a1, a2, a3    - 最佳信号参数拟合值
%                SNR           - 检测到的信号信噪比
%                bestFitness   - 找到的最佳适应度值
%                rmin, rmax    - 使用的参数边界
%                WelchNperseg  - 使用的PSD段长度
%                PSDHalf       - 使用的PSD归一化设置
%                Iters         - 每次运行的迭代次数
%                PopSize       - 使用的种群大小
%                NRuns         - 执行的独立运行次数
%                UseParallel   - 是否使用了并行处理
%
%   RUN_FINAL_LAB_FAST Optimized gravitational wave signal detection algorithm
%   RESULTS = RUN_FINAL_LAB_FAST() runs the fast gravitational wave parameter
%   estimation using default parameter settings.
%
%   RESULTS = RUN_FINAL_LAB_FAST(Name,Value,...) allows customization through
%   name-value pair arguments.
%
%   This function implements an optimized gravitational wave parameter estimation
%   algorithm using PSD pre-computation, batch FFT vectorization, and parallel
%   PSO optimization for substantial speed improvement.

%% 参数解析 (Parameter Parsing)
p = inputParser;
addParameter(p,'Bounds',[0 0 0; 100 100 100]);
addParameter(p,'Iters',100);
addParameter(p,'PopSize',100);
addParameter(p,'NRuns',200);
addParameter(p,'UseParallel',true);
addParameter(p,'WelchNperseg',256);
addParameter(p,'PSDHalf',true);
parse(p,varargin{:});
par = p.Results;

clc; fprintf('== 加速版 run_final_lab_fast ==\n');

%% 数据加载 (Data Loading)
% 加载训练数据和分析数据文件
TD = load('TrainingData.mat'); AD = load('analysisData.mat');
fs = double(AD.sampFreq);            % 采样频率
x  = AD.dataVec(:).';                % 分析数据向量（行向量）
train = TD.trainData(:).';           % 训练数据向量（行向量）
N  = numel(x);                       % 样本数量
t  = (0:N-1)/fs;                     % 时间向量（秒）
% Load training and analysis data files

fprintf('N=%d, Fs=%g Hz, std(data)=%.3e\n', N, fs, std(x));

%% 功率谱密度估计 (PSD Estimation)
% 使用Welch方法计算训练数据的单边PSD
[f_psd, Pxx_one] = local_welch(train, fs, par.WelchNperseg);
% 将PSD插值到DFT频率网格
Ppos = local_interp_to_dft(f_psd, Pxx_one, N, fs);
% 可选：将单边PSD除以2（与Python兼容）
if par.PSDHalf, Ppos = Ppos/2; end
% Calculate one-sided PSD using Welch's method on training data

%% 预计算 (Precomputation)
% 预计算频域量以加速计算
pre = local_precompute_pack(x, fs, Ppos);
pre.t   = t;                   % 时间向量（线性项）
pre.t2  = t.^2;                % 平方时间向量（二次项）
pre.t3  = t.^3;                % 立方时间向量（三次项）
pre.c   = 1/(N*fs);            % 频域内积归一化因子
pre.rmin= par.Bounds(1,:);     % 参数的下界
pre.rmax= par.Bounds(2,:);     % 参数的上界
% Precompute frequency domain quantities to accelerate computations

%% 适应度函数定义 (Fitness Function Definition)
% 为PSO定义适应度函数句柄：向量化的负GLRT加频域缓存
fitHandle = @(Xstd) local_fit_fast_batch(Xstd, pre);
% Define fitness function handle for PSO: vectorized negative GLRT with frequency domain caching

%% 多次独立PSO优化 (Multiple Independent PSO Runs)
% 配置PSO参数
nRuns   = par.NRuns;     % 独立PSO运行的次数
popSize = par.PopSize;   % 每个群的粒子数量
iters   = par.Iters;     % 每次运行的迭代次数

% 初始化最佳适应度跟踪变量
bestFit = inf; bestLoc = []; bestAllBest = [];

% 根据可用性配置并行处理
usePar = par.UseParallel && license('test','Distrib_Computing_Toolbox');
if usePar
    % 如果并行池尚未运行则启动
    ppool = gcp('nocreate');
    if isempty(ppool), parpool; end
    % 并行执行PSO运行
    parfor r = 1:nRuns
        out = local_one_pso_run(fitHandle, popSize, iters);
        outs(r) = out; %#ok<AGROW>
    end
else
    % 顺序执行PSO运行
    outs(1:nRuns) = struct('bestFitness',[],'bestLocation',[],'allBestFit',[]);
    for r = 1:nRuns
        outs(r) = local_one_pso_run(fitHandle, popSize, iters);
    end
end

% 在所有运行中找到最佳结果
for r = 1:nRuns
    if outs(r).bestFitness < bestFit
        bestFit    = outs(r).bestFitness;
        bestLoc    = outs(r).bestLocation;
        bestAllBest= outs(r).allBestFit;
    end
end
% Configure PSO parameters and run multiple independent optimizations

%% 参数恢复和信噪比计算 (Parameter Recovery and SNR Calculation)
% 将标准化的PSO坐标转换回物理参数值
a = bestLoc.*(pre.rmax-pre.rmin)+pre.rmin;
a1=a(1); a2=a(2); a3=a(3);  % 提取单个参数

% 使用最佳拟合参数生成信号相位
phi = a1*pre.t + a2*pre.t2 + a3*pre.t3;  % 三次相位函数
s   = sin(2*pi*phi);                      % 具有三次相位的正弦信号

% 使用PSD归一化内积计算SNR
E   = local_energy_fft(s, pre);           % 信号能量: (s|s)
su  = s / sqrt(E);                        % 单位SNR模板
llr = local_llr_fft(su, pre);             % 对数似然比: (x|su)
SNR = abs(llr);                           % 信噪比
% Convert normalized PSO coordinates back to physical parameter values

%% 结果显示与输出 (Results Display and Output)
% 打印最佳拟合参数和SNR
fprintf('最优参数：a1=%.6f, a2=%.6f, a3=%.6f,  SNR=%.6f\n', a1,a2,a3,SNR);

% 绘制数据和最佳拟合信号
figure; plot(t, x); hold on;
recon = llr*su;  % 重建信号（缩放后的模板）
plot(t, recon, 'LineWidth', 1.4);
grid on; xlabel('s'); ylabel('amp'); legend('data','fit');
title('时域拟合');

% 绘制PSO收敛历史
figure; plot(bestAllBest); grid on;
xlabel('iter'); ylabel('global best'); title('PSO 收敛（-GLRT）');

% 创建包含所有相关结果和参数的输出结构
results = struct('a1',a1,'a2',a2,'a3',a3,'SNR',SNR,...
    'bestFitness',bestFit,'rmin',pre.rmin,'rmax',pre.rmax,...
    'WelchNperseg',par.WelchNperseg,'PSDHalf',par.PSDHalf,...
    'Iters',iters,'PopSize',popSize,'NRuns',nRuns,'UseParallel',usePar);
% Print best fit parameters and SNR and create output structure
end

%% 子函数：Welch
function [f, Pxx_one] = local_welch(trainData, fs, nperseg)
%LOCAL_WELCH 使用Welch方法计算单边功率谱密度
%   [F, PXX_ONE] = LOCAL_WELCH(TRAINDATA, FS, NPERSEG) 使用指定参数的Welch方法
%   计算单边PSD。
%
%   输入参数:
%      trainData - 用于PSD估计的时间序列数据
%      fs        - 采样频率（Hz）
%      nperseg   - Welch方法中每个段的长度
%
%   输出参数:
%      f         - 频率向量（Hz）
%      Pxx_one   - 单边功率谱密度
%
%   LOCAL_WELCH Compute one-sided Power Spectral Density using Welch's method
%   [F, PXX_ONE] = LOCAL_WELCH(TRAINDATA, FS, NPERSEG) computes the one-sided 
%   PSD using Welch's method with specified parameters.

trainData = trainData(:);              % 确保为列向量
win = hann(nperseg,'periodic');        % 汉宁窗
nover = floor(nperseg/2);              % 50%重叠
nfft = nperseg;                        % FFT长度等于段长度
[Pxx_one, f] = pwelch(trainData, win, nover, nfft, fs, 'onesided', 'psd');
% 注意：不设PSD下限，以保持与Python实现的一致性
% Note: No PSD floor is applied to maintain consistency with Python implementation
end

%% 子函数：插值到正频 DFT 栅格
function Ppos = local_interp_to_dft(f, Pxx, N, fs)
%LOCAL_INTERP_TO_DFT 将PSD插值到DFT频率网格
%   PPOS = LOCAL_INTERP_TO_DFT(F, PXX, N, FS) 将功率谱密度从任意频率点
%   插值到正频率DFT网格。
%
%   输入参数:
%      f      - PSD估计中的原始频率向量（Hz）
%      Pxx    - f中频率处的功率谱密度值
%      N      - 时域信号的长度（决定DFT网格分辨率）
%      fs     - 采样频率（Hz）
%
%   输出参数:
%      Ppos   - 在正频率DFT网格点上的插值PSD值
%
%   LOCAL_INTERP_TO_DFT Interpolate PSD to DFT frequency grid
%   PPOS = LOCAL_INTERP_TO_DFT(F, PXX, N, FS) interpolates the power spectral 
%   density from arbitrary frequency points to the positive-frequency DFT grid.

kNyq = floor(N/2)+1;                   % 奈奎斯特频率索引+1
data_len = N/fs;                       % 信号持续时间（秒）
pos_freq = (0:(kNyq-1))/data_len;      % 正频率DFT网格（Hz）
Ppos = interp1(f, Pxx, pos_freq, 'linear', 'extrap'); % 将PSD插值到DFT网格
% Index of Nyquist frequency + 1
end

%% 子函数：预计算频域缓存
function pre = local_precompute_pack(x, fs, Ppos)
%LOCAL_PRECOMPUTE_PACK 预计算频域量以提高计算效率
%   PRE = LOCAL_PRECOMPUTE_PACK(X, FS, PPOS) 创建一个包含预计算频域量的结构体，
%   以加速后续计算。
%
%   输入参数:
%      x      - 时域数据向量
%      fs     - 采样频率（Hz）
%      Ppos   - 正DFT频率网格点上的PSD值
%
%   输出参数:
%      pre    - 包含预计算量的结构体:
%               N         - 信号长度
%               fs        - 采样频率
%               PSDnorm   - 用于归一化的双边PSD
%               invPSD    - PSDnorm的倒数 (1./PSDnorm)
%               c         - 内积的归一化常数
%               XfftNorm  - PSD归一化后的数据FFT
%
%   LOCAL_PRECOMPUTE_PACK Precompute frequency domain quantities for efficient computation
%   PRE = LOCAL_PRECOMPUTE_PACK(X, FS, PPOS) creates a structure with precomputed
%   frequency domain quantities to accelerate subsequent computations.

N = numel(x);                          % 信号长度
kNyq = floor(N/2)+1;                   % 奈奎斯特频率索引+1
if numel(Ppos)~=kNyq, error('Ppos length mismatch'); end

% 通过镜像创建双边PSD（确保与Python兼容）
neg_f_strt = 1 - mod(N,2);             % 起始索引：偶数->1，奇数->0
mirror     = Ppos( (kNyq - neg_f_strt) : -1 : 2 );  % 负频率的镜像
PSDnorm    = [Ppos(:).' , mirror(:).']; % 连接正负部分

% 将零值替换为小的epsilon以避免除以零
PSDnorm(PSDnorm==0) = eps;

% 在输出结构中存储预计算值
pre.N        = N;                      % 信号长度
pre.fs       = fs;                     % 采样频率
pre.PSDnorm  = PSDnorm;                % 双边PSD
pre.invPSD   = 1./PSDnorm;             % PSD的倒数，用于高效计算
pre.c        = 1/(N*fs);               % 归一化常数

% 预计算数据的归一化FFT用于高效模板匹配
X            = fft(x);                 % 数据的FFT
pre.XfftNorm = X ./ PSDnorm;           % PSD归一化的FFT（用于内积）
% Signal length
end

%% 子函数：模板能量 (s|s)（频域一次性计算）
function E = local_energy_fft(s, pre)
%LOCAL_ENERGY_FFT 使用PSD加权范数计算信号能量
%   E = LOCAL_ENERGY_FFT(S, PRE) 使用PRE中的预计算量计算信号S的PSD加权能量。
%
%   此函数在频域中计算带PSD加权的内积(s|s)，它表示白化空间中信号的平方范数。
%
%   输入参数:
%      s      - 时域信号
%      pre    - 包含来自local_precompute_pack的预计算量的结构体
%
%   输出参数:
%      E      - 信号S的PSD加权能量
%
%   LOCAL_ENERGY_FFT Compute signal energy using PSD-weighted norm
%   E = LOCAL_ENERGY_FFT(S, PRE) computes the PSD-weighted energy of signal S
%   using precomputed quantities in PRE.

S = fft(s);                                    % 信号的FFT
E = pre.c * sum( (abs(S).^2) .* pre.invPSD );  % PSD加权能量: (s|s)
E = real(E);                                   % 确保输出为实数（按构造应为实数）
% FFT of signal
end

%% 子函数：LLR = (x|s)（频域一次性计算）
function llr = local_llr_fft(s, pre)
%LOCAL_LLR_FFT 使用PSD加权内积计算对数似然比
%   LLR = LOCAL_LLR_FFT(S, PRE) 将对数似然比计算为数据和信号模板之间的PSD加权内积。
%
%   此函数在频域中计算带PSD加权的内积(x|s)，这是信号检测的对数似然比。
%
%   输入参数:
%      s      - 时域信号模板
%      pre    - 包含来自local_precompute_pack的预计算量的结构体
%
%   输出参数:
%      llr    - 对数似然比（数据和模板的内积）
%
%   LOCAL_LLR_FFT Compute log-likelihood ratio using PSD-weighted inner product
%   LLR = LOCAL_LLR_FFT(S, PRE) computes the log-likelihood ratio as the
%   PSD-weighted inner product between the data and signal template.

S = fft(s);                                    % 模板信号的FFT
llr = pre.c * sum( pre.XfftNorm .* conj(S) );  % PSD加权内积: (x|s)
llr = real(llr);                               % 确保输出为实数（对于匹配信号应为实数）
% FFT of template signal
end

%% 子函数：批量 -GLRT（矢量化）
function fval = local_fit_fast_batch(Xstd, pre)
%LOCAL_FIT_FAST_BATCH 对PSO粒子批量进行向量化适应度计算
%   FVAL = LOCAL_FIT_FAST_BATCH(XSTD, PRE) 以向量化方式计算一批粒子的负GLRT适应度值。
%
%   此函数使用向量化操作和批量FFT同时高效处理多组参数，显著提高速度。
%
%   输入参数:
%      Xstd   - M×3标准化粒子坐标矩阵
%               每行是一个粒子，列是a1, a2, a3参数
%      pre    - 包含来自local_precompute_pack的预计算量的结构体
%
%   输出参数:
%      fval   - M×1负GLRT适应度值向量（-GLRT）
%               PSO最小化这些值（等价于最大化GLRT）
%
%   LOCAL_FIT_FAST_BATCH Vectorized fitness calculation for batch of PSO particles
%   FVAL = LOCAL_FIT_FAST_BATCH(XSTD, PRE) computes the negative GLRT fitness
%   values for a batch of particles in a vectorized manner.

% 处理空输入情况
if isempty(Xstd), fval = []; return; end
M = size(Xstd,1);  % 粒子数量

% 将参数从[0,1]范围反标准化到物理范围[rmin,rmax]
a = Xstd.*(pre.rmax-pre.rmin) + pre.rmin;    % M×3物理参数矩阵

% 使用隐式扩展同时为所有粒子生成相位
phi = a(:,1).*pre.t + a(:,2).*pre.t2 + a(:,3).*pre.t3;   % M×N相位矩阵

% 为所有粒子生成正弦波形
s  = sin(2*pi*phi);                           % M×N信号矩阵

% 批量FFT计算（每行独立变换）
S  = fft(s, [], 2);                           % M×N的FFT矩阵

% 同时计算所有信号的PSD加权能量
E  = pre.c * sum( (abs(S).^2) .* pre.invPSD, 2 );    % M×1能量向量

% 同时计算所有信号的PSD加权内积
LLR= pre.c * sum( (pre.XfftNorm).*conj(S), 2 );      % M×1 LLR向量

% 计算GLRT值：(LLR^2)/E（等价于单位SNR模板内积的平方）
GLRT = (real(LLR).^2) ./ real(E + eps);              % M×1 GLRT值向量
fval  = -GLRT;                                       % 返回负GLRT用于最小化
end

%% 子函数：单次 PSO 运行
function out = local_one_pso_run(fitHandle, popSize, iters)
%LOCAL_ONE_PSO_RUN 执行单次PSO优化
%   OUT = LOCAL_ONE_PSO_RUN(FITHANDLE, POPSIZE, ITERS) 使用指定参数执行单次PSO
%   优化运行。
%
%   此函数配置并执行CRCBPSO优化器，使用全局邻域拓扑（近似pyswarms.GlobalBestPSO的行为）。
%
%   输入参数:
%      fitHandle - 适应度函数的函数句柄
%      popSize   - 群体中的粒子数量
%      iters     - 要运行的迭代次数
%
%   输出参数:
%      out       - 包含优化结果的结构体:
%                  bestLocation - 找到的最佳参数集
%                  bestFitness  - 找到的最佳适应度值
%                  allBestFit   - 最佳适应度值的历史记录
%
%   LOCAL_ONE_PSO_RUN Run a single PSO optimization
%   OUT = LOCAL_ONE_PSO_RUN(FITHANDLE, POPSIZE, ITERS) performs a single PSO
%   optimization run with specified parameters.

% 配置带全局邻域拓扑的PSO参数
psoParams = struct();
psoParams.popSize      = popSize;       % 粒子数量
psoParams.maxSteps     = iters;         % 迭代次数
psoParams.c1           = 0.2;           % 认知参数（个人最佳吸引）
psoParams.c2           = 0.1;           % 社会参数（全局最佳吸引）
psoParams.maxVelocity  = 0.5;           % 最大粒子速度
psoParams.startInertia = 0.99;          % 初始惯性权重
psoParams.endInertia   = 0.99;          % 最终惯性权重（本例中保持不变）
psoParams.nbrhdSz      = popSize;       % 全局邻域（所有粒子相连）

outLvl = 2;                             % 输出详细程度
rng('shuffle');                         % 随机化种子以使不同运行有差异
out = crcbpso(fitHandle, 3, psoParams, outLvl);  % 运行PSO优化
end

