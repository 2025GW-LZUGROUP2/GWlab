function [s_unit, c] = normsig4psd(s, Fs, psd_pos, snr)
%NORMSIG4PSD 将信号在给定 PSD 下归一到指定 SNR
%   [y, c] = NORMSIG4PSD(sig_vec, Fs, psd_pos, snr)
% 输入：
%   sig_vec : 待归一化信号
%   Fs      : 采样频率
%   psd_pos : 单边 PSD（正频率，长度 floor(N/2)+1）
%   snr     : 目标 SNR（例如归一到1）
% 输出：
%   norm_sig_vec : 归一后的信号
%   norm_fac     : 归一化因子
%
% 作者：你的小伙伴（中文详注）
%NORMSIG4PSD 使模板在 PSD 意义下的范数=snr
s = s(:).';
E = innerprod_psd(s, s, Fs, psd_pos);
c = snr / sqrt(E);
s_unit = c*s;
end
