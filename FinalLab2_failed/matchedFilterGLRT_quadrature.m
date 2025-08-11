function [snr2, Ahat, info] = matchedFilterGLRT_quadrature(x, s1, s2, Ppos, Fs)
% 基于 PSD 的广义似然比（GLRT），对未知幅度与相位做极大似然（两正交模板：sin 和 cos）
% [snr2, Ahat, info] = matchedFilterGLRT_quadrature(x, s1, s2, Ppos, Fs)
% 输入：
%   x    : 数据向量（1×N 或 N×1）
%   s1   : 正交模板 1（例如 sin(2πφ(t))）
%   s2   : 正交模板 2（例如 cos(2πφ(t))）
%   Ppos : 单边 PSD（长度 floor(N/2)+1，对应 DFT 正频率）
%   Fs   : 采样频率
% 输出：
%   snr2 : 在未知幅度与相位最大化后的 SNR^2
%   Ahat : 对应于合成模板 A1*s1 + A2*s2 的最优系数（A1,A2）
%   info : 结构体，包含 Gram 矩阵与 (x|s) 等中间量

x = x(:).'; s1 = s1(:).'; s2 = s2(:).';
N = length(x);
Nyq = floor(N/2)+1;

% ！！！关键：双边 PSDnorm 的拼接必须与 innerprod_psd 一致！！！
% innerprod_psd 的做法（参见你 Python 和我给的同名 .m）：
%   neg_f_strt = 1 - mod(N,2);  % 偶数->1, 奇数->0
%   PSDnorm = [Ppos , Ppos(((Nyq-1)-neg_f_strt):-1:1)];
neg_f_strt = 1 - mod(N,2);
PSDnorm = [Ppos , Ppos(((Nyq-1)-neg_f_strt):-1:1)];

X  = fft(x);
S1 = fft(s1);
S2 = fft(s2);

% Gram 矩阵 G
g11 = (1/(N*Fs))*sum( (S1.*conj(S1))./PSDnorm );
g22 = (1/(N*Fs))*sum( (S2.*conj(S2))./PSDnorm );
g12 = (1/(N*Fs))*sum( (S1.*conj(S2))./PSDnorm );
G   = real([g11, g12; g12, g22]);

% 数据与模板的内积向量 b
b1 = (1/(N*Fs))*sum( (X.*conj(S1))./PSDnorm );
b2 = (1/(N*Fs))*sum( (X.*conj(S2))./PSDnorm );
b  = real([b1; b2]);

% 极大化后 SNR^2 = b^T * inv(G) * b
A = G \ b;                 % ML 估计系数 [A1; A2]
snr2 = max(0, b.'*(G\b));  % 数值稳定：不为负

Ahat.A1 = A(1);
Ahat.A2 = A(2);
info.G  = G;
info.b  = b;
end
