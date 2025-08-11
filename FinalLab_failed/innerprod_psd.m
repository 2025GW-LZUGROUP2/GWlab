function prod = innerprod_psd(x_vec, y_vec, samp_freq, psd_vec)
%INNERPROD_PSD 计算在指定PSD下两个向量的内积
%   x_vec, y_vec: 输入信号
%   samp_freq: 采样频率
%   psd_vec: 正频率上的PSD（长度为N/2+1）

x_vec = x_vec(:);
y_vec = y_vec(:);
N = length(x_vec);
k_nyq = floor(N/2)+1;

if length(psd_vec) ~= k_nyq
    error('PSD长度与正频率点数不符');
end

fft_x = fft(x_vec);
fft_y = fft(y_vec);

data_len = N / samp_freq;
% 构造完整的PSD向量，使其长度与N一致
if mod(N,2) == 0 % N为偶数
    psd_vec_4norm = [psd_vec; psd_vec((k_nyq-1):-1:2)];
else % N为奇数
    psd_vec_4norm = [psd_vec; psd_vec((k_nyq):-1:2)];
end
psd_vec_4norm = psd_vec_4norm(1:N); % 截断或补齐到N

data_len = N / samp_freq;
prod = (1/data_len) * sum((fft_x ./ psd_vec_4norm) .* conj(fft_y));
prod = real(prod);
end
