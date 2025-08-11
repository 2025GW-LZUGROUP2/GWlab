function xw = whiten_with_psd(x, Ppos, Fs)
%WHITEN_WITH_PSD 用 H(f)=1/sqrt(Sn(f)) 白化时序 x
% Ppos 为单边 PSD（与 DFT 正频点对齐，长度 floor(N/2)+1）
x = x(:).'; N = numel(x);
PSDnorm = build_psdnorm(Ppos, N);     % 双边 PSD
X = fft(x);
Xw = X ./ sqrt(PSDnorm);              % 频域白化
xw = real(ifft(Xw));
end
