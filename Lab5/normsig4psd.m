function sig = normsig4psd(sig, fs, psd_vec)
% Normalize a signal with respect to the PSD
% Inputs:
%   sig: signal to normalize
%   fs: sampling frequency
%   psd_vec: power spectral density
% Output:
%   sig: normalized signal

% Compute the inner product of the signal with itself
inner_prod = innerProdPSD(sig, sig, fs, psd_vec);

% Normalize the signal
sig = sig / sqrt(real(inner_prod));

end