function [f_psd, Pxx_one_sided] = estimatePSD_welch(trainData, Fs)
% 使用 Welch 法估计单边功率谱密度（PSD）
% [f_psd, Pxx] = estimatePSD_welch(trainData, Fs, nperseg)
% 输入：
%   trainData : 训练数据（1×N 或 N×1 向量）
%   Fs        : 采样频率 (Hz)
%   nperseg   : Welch 分段长度（可选；缺省自动选取）
% 输出：
%   f_psd     : 单边 PSD 对应的频率轴（0 ~ Fs/2）
%   Pxx       : 单边 PSD (单位^2/Hz)，做了下限夹紧以避免除零
%
% 说明：
%   - Hann 窗，50% 重叠，'onesided'，'psd' 标度。
%   - 对 f=0 或 Nyquist 点的数值稳定处理：Pxx = max(Pxx, 1e-18)。
%
% 作者：你的小伙伴（中文详注）


% Welch 单边 PSD：Hann，50%重叠，nperseg=256，'psd' 标度
trainData = trainData(:);
nperseg = 256;
win = hann(nperseg,'periodic');
noverlap = floor(nperseg/2);
nfft = nperseg;
[Pxx_one_sided, f_psd] = pwelch(trainData, win, noverlap, nfft, Fs, 'onesided', 'psd');
Pxx_one_sided = max(Pxx_one_sided, 1e-18);
end