% function Ppos = interpPSD2DFTBins(f, Pxx, nsamples, fs)
% % 与Python一模一样：正频 DFT 栅格 pos_freq = (0:kNyq-1) / data_len
% % 其中 data_len = nsamples/fs；注意这等价于 (0:kNyq-1)*fs/nsamples
% k_nyq = floor(nsamples/2)+1;
% data_len = nsamples/fs;
% pos_freq = (0:(k_nyq-1)) / data_len;   % 频率(Hz)
% Ppos = interp1(f, Pxx, pos_freq, 'linear', 'extrap');
% Ppos = max(Ppos, 1e-18);
% end
function Ppos = interpPSD2DFTBins(f, Pxx, nsamples, fs)
% 与Python一致：pos_freq = (0:kNyq-1) / (nsamples/fs)  （Hz）
kNyq = floor(nsamples/2)+1;
data_len = nsamples/fs;
pos_freq = (0:(kNyq-1)) / data_len;
Ppos = interp1(f, Pxx, pos_freq, 'linear', 'extrap');
% ★ 也不要在这里做统一地板；仅在真正要除以 PSD 的地方，把“恰好为0”的点置为 eps。
end
