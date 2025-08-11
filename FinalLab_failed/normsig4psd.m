function [norm_sig_vec, norm_fac] = normsig4psd(sig_vec, samp_freq, psd_vec, snr)
%NORMSIG4PSD 将信号归一化到指定SNR（在指定PSD下）
%   sig_vec: 原始信号
%   samp_freq: 采样频率
%   psd_vec: 正频率上的PSD（长度为N/2+1）
%   snr: 目标信噪比

sig_vec = sig_vec(:);
N = length(sig_vec);
k_nyq = floor(N/2)+1;
if length(psd_vec) ~= k_nyq
    error('PSD长度与正频率点数不符');
end

norm_sig_sqrd = innerprod_psd(sig_vec, sig_vec, samp_freq, psd_vec);
norm_fac = snr / sqrt(norm_sig_sqrd);
norm_sig_vec = norm_fac * sig_vec;
end
