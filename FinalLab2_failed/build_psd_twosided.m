function PSD2 = build_psd_twosided(Ppos, N)
%BUILD_PSD_TWOSIDED 由单边 PSD (长度 floor(N/2)+1) 构造双边 PSD 向量 (长度 N)
% 顺序与我们所有频域代码一致：[正频(含0..Nyq), 负频镜像(不含0、不含Nyq)]
% 这个顺序必须在所有地方保持一致，避免权重与频点错位。
kNyq = floor(N/2)+1;
if length(Ppos) ~= kNyq
    error('Ppos 长度应为 floor(N/2)+1');
end
neg_f_strt = 1 - mod(N,2);   % 偶数N -> 1, 奇数N -> 0
PSD2 = [Ppos , Ppos(((kNyq-1)-neg_f_strt):-1:1)];
PSD2 = max(PSD2, 1e-18);     % 数值稳定
end
