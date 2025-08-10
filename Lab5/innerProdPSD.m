function z = innerProdPSD(x, y, fs, psd_vec)
% Compute the inner product of two signals with respect to the PSD
% Inputs:
%   x: first signal
%   y: second signal
%   fs: sampling frequency
%   psd_vec: power spectral density
% Output:
%   z: inner product

% Compute the FFT of the signals
X = fft(x);
Y = fft(y);

% Compute the frequency spacing
df = fs / length(x);

% Compute the inner product in the frequency domain
% Using the property that <x,y> = sum(X.*conj(Y)) * df
% But we need to divide by the PSD
z = sum((X .* conj(Y)) / psd_vec) * df;

end