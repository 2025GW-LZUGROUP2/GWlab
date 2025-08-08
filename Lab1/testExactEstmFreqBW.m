% testExactEstmFreqBW.m
%% 该文件测试了ExactEstmFreqBW.m及其附属函数estmFreqBW.m getEnergy.m
clear;clc;
% 定义符号变量
syms t;
timeInterval = [0, 1]; % 时间区间[0,1]
fsInit = 300; % 先给一个较高的采样率，保证后续分析准确
timeLength = timeInterval(2) - timeInterval(1);
timeVec = (timeInterval(1):1 / fsInit:timeInterval(2));

run(fullfile(fileparts(mfilename('fullpath')), 'Lab1SigDef.m'))
%%
SigNow = Sig_AMFM; % 当前信号
% phiNow = phi_FM; %是正弦类信号就保留（即能否通过表达式直接算出瞬时最大频率），如果不是请注释掉这行
phiNow = [];%如果不是正弦类信号就保留本行，取消本行的注释
%后缀可选：
% 后缀      英文含义                               中文含义
% ----------------------------------------------------------
% qc        Quadratic Chirp                        二次调频信号
% lc        Linear Chirp                           线性调频信号
% ss        Sinusoidal Signal                      正弦信号
% FM        Frequency Modulated (FM) Sinusoid      频率调制正弦信号
% 以下是非标准正弦类，phiNow =?；一行需要注释掉
% Sg        Sine-Gaussian Signal                   正弦-高斯信号
% AM        Amplitude Modulated (AM) Sinusoid      幅度调制正弦信号
% AMFM      AM-FM Sinusoid                         幅度-频率调制正弦信号
% ----------------------------------------------------------
maxFreq = ExactEstmFreqBW(SigNow);
NyqFreq = 2 * maxFreq;
a = timeInterval(1); b = timeInterval(2);
fs = 5 * NyqFreq; % 自动估计采样率
delta = 1 / fs;
timeVec = a:delta:b;
SigNow.timeVec = timeVec;
SigVec = SigNow.SigVec;
SigVec = SigVec / norm(SigVec);
N = length(timeVec);

fftVec = fft(SigVec);
fftShiftVec = fftshift(fftVec);

AllFreqVec = ((0:N - 1) - floor(N / 2)) * (fs / N); %包含正负频率的频率向量
ESD = delta ^ 2 * abs(fftShiftVec) .^ 2;
allEnergy = trapz(timeVec, SigVec .^ 2);

figure;
plot(timeVec, SigVec, 'Marker', '.', 'MarkerSize', 20);
xlabel('Time/s');
ylabel('Signal');

%% 验证理论最大瞬时频率和估计的频率带宽是否接近
% 如果信号是标准的正弦类信号
if ~isempty(phiNow)
    InstFreq = diff(phiNow, t) / (2 * pi);
    fprintf(['如果信号是标准的正弦类信号，' ...
             '则需要通过比较最终FreqBandWidth和理论最大瞬时频率估计值的接近程度\n']);
    sym_val = [];

    for i = 1:length(SigNow.coeffName)
        sym_val = [sym_val, sym(SigNow.coeffName{i})];
    end

    InstFreq_with_coeff = subs(InstFreq, sym_val, SigNow.coeffValue);
    InstFreqVec = subs(InstFreq_with_coeff, t, timeVec);
    [MaxInstFreq, t_InstFreqMax] = max(InstFreqVec);
    %SigNow.SigVec=double(subs(SigNow.SigExpr_with_coeff,SigNow.indpVar,SigNow.timeVec));
    fprintf("理论最大瞬时频率估计值为%.2f Hz(若两值接近，则说明正确)", MaxInstFreq);

end

%% 如果信号不是标准的正弦类信号
fprintf('如果信号不是标准的正弦类信号，则需要通过|fft|-f图像来判断\n');
fprintf('判断标准：如果0-NyqFreq区间内，覆盖了|fft|的绝大部分面积，即可认为maxFreq估计正确');
NyqLimIdx = floor(N / 2) + 1; %Nyquist Limit频率所对应的指数 Nyquist Limit Index(the the index when f=fs/2)
posFreq = (0:(NyqLimIdx - 1) / timeLength);
fftVec_posFreq = fftVec(1:NyqLimIdx);
figure('Name', '判断maxFreq是否估计正确', 'Position', [100 100 800 600]);
fftline = plot(posFreq, abs(fftVec_posFreq));
hold on;
xlabel("频率Frequency(Hz)");
ylabel("|fft|");
% plot(maxFreq,abs(fftVec(floor(maxFreq))),'Marker','.','MarkerSize',20);
% 填充曲线下方的颜色
fillX = [posFreq(posFreq <= NyqFreq), NyqFreq]; % 添加 NyqFreq 作为最后一个点
fillY = [abs(fftVec_posFreq(1:sum(posFreq <= NyqFreq))), 0]; % 对应 NyqFreq 的 y 值为 0
fill([fillX, flip(fillX)], [fillY, zeros(size(fillY))], 'cyan', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
h1 = xline(maxFreq, 'r--', 'LineWidth', 1);
h2 = xline(NyqFreq, 'b--', 'LineWidth', 1);
grid on;
legend([fftline, h1, h2], {'|fft|', 'max Frequency(band width)', 'Nyquist Frequency'});

%% 查看ExactEstmFreqBW中目标函数的变化
% % 定义本地objFun（与ExactEstmFreqBW.m中一致）
% objFun = @(mf) (getEnergy(mf, AllFreqVec, ESD) - 0.999*allEnergy).^2;
% % ============================

% % 计算目标函数曲线
% mfRange = 0:0.1:40;
% objVals = arrayfun(@(mf) objFun(mf), mfRange);

% % 绘图
% figure('Position', [100 100 800 600]);
% plot(mfRange, objVals, 'LineWidth', 1.2);
% hold on;
% plot(maxFreq, objFun(maxFreq), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
% xlabel('maxFreq (Hz)');
% ylabel('目标函数值（能量差平方）');
% title('目标函数曲线与最优解');
% legend('目标函数', ['最优解: ', num2str(maxFreq, '%.2f'), ' Hz'], 'Location', 'southeast');
% grid on;
