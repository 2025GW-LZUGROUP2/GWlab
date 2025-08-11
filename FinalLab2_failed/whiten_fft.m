function xw = whiten_fft(x, Ppos, Fs)
%WHITEN_FFT  用 H(f)=1/sqrt(Sn(f)) 白化时域数据（FFT法）
% 输入:
%   x    : 1xN 或 Nx1 向量
%   Ppos : 单边 PSD（长度 floor(N/2)+1，单位^2/Hz）
%   Fs   : 采样率
% 输出:
%   xw   : 白化后的时域向量（实数）
x  = x(:).'; 
N  = length(x);
PSD2 = build_psd_twosided(Ppos, N);      % 双边 PSD
H   = 1./sqrt(PSD2);                      % 白化器频响（双边）
X   = fft(x);
Xw  = X .* H;
xw  = real(ifft(Xw));
end
