function cost = objective_func(qcCoefs)
% Objective function for PSO
% Inputs:
%   qcCoefs: quadratic chirp coefficients [a1, a2, a3]
% Output:
%   cost: negative GLRT value (to be minimized)

global g_time_vec g_analysisData g_fs g_psd_vec

% qcCoefs: shape (3,) - parameters [a1, a2, a3]
cost = -glrtqcsig(g_time_vec, g_analysisData, g_fs, g_psd_vec, qcCoefs);

end
