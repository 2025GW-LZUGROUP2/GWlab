% function [f, Pxx_one] = estimatePSD_welch(trainData, fs)
% % Welch 单边PSD估计：nperseg=256（与Python一致），Hann窗，50%重叠，'psd' 标度
% trainData = trainData(:);
% nperseg = 256;
% win = hann(nperseg,'periodic');
% noverlap = floor(nperseg/2);
% nfft = nperseg;
% [Pxx_one, f] = pwelch(trainData, win, noverlap, nfft, fs, 'onesided', 'psd');
% Pxx_one = max(Pxx_one, 1e-18);
% end
function [f, Pxx_one] = estimatePSD_welch(trainData, fs)
% Welch 单边PSD估计：nperseg=256（与Python一致），Hann窗，50%重叠，'psd' 标度
trainData = trainData(:);
nperseg = 256;
win = hann(nperseg,'periodic');
noverlap = floor(nperseg/2);
nfft = nperseg;
[Pxx_one, f] = pwelch(trainData, win, noverlap, nfft, fs, 'onesided', 'psd');
% ★ 不要做 max(Pxx_one,1e-18) ！！与 Python 对齐
end
