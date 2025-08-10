function sig = qcchirp(time_vec, qcCoefs)
% Generate a quadratic chirp signal
% Inputs:
%   time_vec: time vector
%   qcCoefs: quadratic chirp coefficients [a1, a2, a3]
% Output:
%   sig: quadratic chirp signal

a1 = qcCoefs(1);
a2 = qcCoefs(2);
a3 = qcCoefs(3);

% Quadratic chirp signal model
sig = exp(1j * (a1 * time_vec + a2 * time_vec.^2 + a3 * time_vec.^3));

end