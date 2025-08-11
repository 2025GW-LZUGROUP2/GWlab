function inn_prod = innerprod_psd(x_vec, y_vec, Fs, psd_pos)
%INNERPROD_PSD 在指定 PSD 下计算两个序列的频域加权内积
%   inn_prod = INNERPROD_PSD(x, y, Fs, psd_pos)
% 输入：
%   x_vec, y_vec : 两个长度相同的向量（行/列均可）
%   Fs           : 采样频率
%   psd_pos      : 单边 PSD（长度为 floor(N/2)+1，对应 [0,Fs/2] 的DFT正频率）
% 输出：
%   inn_prod     : 频域 PSD 加权内积（实数）
%
% 说明：
%   对齐参考仓库的思路：先做 FFT，再用单边 PSD 镜像成“双边” PSDnorm，
%   然后按 (1/(N*Fs))*sum( X./PSD * conj(Y) ) 计算；最后取实部。
%
% 作者：你的小伙伴（中文详注）
% 在给定 PSD 下的频域加权内积（对齐 function.py）
% 双边 PSDnorm = [psd_pos , mirror]，其中 mirror 的起点按奇偶数处理

%INNERPROD_PSD  频域 PSD 加权内积： (1/(N*Fs))*sum( X * conj(Y) ./ PSDnorm )
x_vec = x_vec(:).'; y_vec = y_vec(:).';
N = length(x_vec);
kNyq = floor(N/2)+1;
if length(y_vec)~=N, error('length mismatch'); end
if length(psd_pos)~=kNyq, error('psd_pos length mismatch'); end
PSDnorm = build_psdnorm(psd_pos, N);
X = fft(x_vec); Y = fft(y_vec);
inn_prod = (1/(N*Fs))*sum( (X.*conj(Y)) ./ PSDnorm );
inn_prod = real(inn_prod);
end
