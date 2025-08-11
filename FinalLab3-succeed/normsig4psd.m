function [norm_sig_vec, norm_fac] = normsig4psd(sig_vec, samp_freq, psd_vec, snr)
% 与 Python function.py 完全对应：在给定 PSD 下把模板归一到指定 SNR
sig_vec = sig_vec(:).';
psd_vec = psd_vec(:).';
n_samples = numel(sig_vec);
k_nyq = floor(n_samples/2)+1;
if numel(psd_vec) ~= k_nyq
    error('Length of PSD is not correct');
end
norm_sig_sqrd = innerprod_psd(sig_vec, sig_vec, samp_freq, psd_vec);
norm_fac = snr / sqrt(norm_sig_sqrd);
norm_sig_vec = norm_fac * sig_vec;
end
