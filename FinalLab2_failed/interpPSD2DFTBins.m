function Ppos = interpPSD2DFTBins(f_psd, Pxx, N, Fs)
% 将 Welch 单边 PSD 插值到分析数据的 DFT 正频率栅格上
% Ppos = interpPSD2DFTBins(f_psd, Pxx, N, Fs)
% 输入：
%   f_psd : Welch 输出的频率轴（0~Fs/2）
%   Pxx   : 与 f_psd 对应的单边 PSD
%   N     : 分析数据的长度（DFT 长度）
%   Fs    : 采样频率
% 输出：
%   Ppos  : 大小为 floor(N/2)+1 的 PSD，分别对应 DFT 正频率 0:Fs/N:Fs/2
%
% 说明：若插值范围外，使用端点外推；并对结果做下限夹紧避免除零。
Nyq = floor(N/2)+1;
df  = Fs/N;
fbin = (0:Nyq-1)*df;
Ppos = interp1(f_psd, Pxx, fbin, 'linear', 'extrap');
Ppos = max(Ppos, 1e-18);
end
