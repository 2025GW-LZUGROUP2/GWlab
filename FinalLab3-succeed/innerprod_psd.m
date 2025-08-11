% function inn_prod = innerprod_psd(x_vec, y_vec, samp_freq, psd_vals)
% % 与 Python function.py 完全一致的 PSD 加权内积
% % inn_prod = (1/(N*Fs)) * sum( (FFT(x) ./ PSDnorm) .* conj(FFT(y)) )

% x_vec = x_vec(:).';
% y_vec = y_vec(:).';
% psd_vals = psd_vals(:).';

% n_samples = numel(x_vec);
% if numel(y_vec) ~= n_samples
%     error('Vectors must be of the same length');
% end

% kNyq = floor(n_samples/2)+1;
% if numel(psd_vals) ~= kNyq
%     error('PSD values must be specified at positive DFT frequencies');
% end

% % ---- 关键：双边 PSD 的镜像拼接必须与 Python 完全一致 ----
% % Python: psd_vals[((k_nyq-1)-neg_f_strt):0:-1]  （0基索引，步长-1，排除0）
% % MATLAB 1基等价：从 (kNyq - neg_f_strt) 到 2 递减（包含2，排除1）
% neg_f_strt = 1 - mod(n_samples,2);   % 偶数->1，奇数->0
% mirror = psd_vals( (kNyq - neg_f_strt) : -1 : 2 );
% psd_vec_4_norm = [psd_vals(:).' , mirror(:).'];   % 长度应当等于 n_samples

% % 内积
% X = fft(x_vec);
% Y = fft(y_vec);
% data_len = samp_freq * n_samples;
% inn_prod = (1/data_len) * sum( (X ./ psd_vec_4_norm) .* conj(Y) );
% inn_prod = real(inn_prod);
% end
function inn_prod = innerprod_psd(x_vec, y_vec, samp_freq, psd_vals)
x_vec = x_vec(:).';  y_vec = y_vec(:).';  psd_vals = psd_vals(:).';
n_samples = numel(x_vec);
if numel(y_vec) ~= n_samples, error('length mismatch'); end
kNyq = floor(n_samples/2)+1;
if numel(psd_vals) ~= kNyq, error('psd length mismatch'); end

neg_f_strt = 1 - mod(n_samples,2);                 % even->1, odd->0
mirror = psd_vals( (kNyq - neg_f_strt) : -1 : 2 ); % ★关键：与 Python 一致
psd_vec_4_norm = [psd_vals(:).', mirror(:).'];     % 1×N

% 避免除零（仅把恰好为 0 的点替换成 eps，不做统一地板）
zero_idx = (psd_vec_4_norm==0);
if any(zero_idx), psd_vec_4_norm(zero_idx) = eps; end

X = fft(x_vec);  Y = fft(y_vec);
inn_prod = (1/(n_samples*samp_freq)) * sum( (X ./ psd_vec_4_norm) .* conj(Y) );
inn_prod = real(inn_prod);
end
