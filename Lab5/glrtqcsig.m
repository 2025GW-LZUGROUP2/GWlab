function glrt = glrtqcsig(time_vec, data_vec, fs, psd_vec, qcCoefs)
% Compute the GLRT for a quadratic chirp signal
% Inputs:
%   time_vec: time vector
%   data_vec: data vector
%   fs: sampling frequency
%   psd_vec: power spectral density
%   qcCoefs: quadratic chirp coefficients [a1, a2, a3]

% Generate the quadratic chirp signal template
sigTemp = qcchirp(time_vec, qcCoefs);

% Normalize the signal template with respect to the PSD
sigTemp = normsig4psd(sigTemp, fs, psd_vec);

% Compute the inner product of the signal template and data
rho = innerProdPSD(sigTemp, data_vec, fs, psd_vec);

% Compute the GLRT
glrt = 2 * real(rho) - real(innerProdPSD(sigTemp, sigTemp, fs, psd_vec));

end