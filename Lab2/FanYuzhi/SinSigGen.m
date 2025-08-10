function sigVec = SinSigGen(time,ampl,freq0,phase0)
% Generate a sinusoidal signal

phaseVec = 2 * pi * freq0 * time + phase0;
sigVec = sin(phaseVec);
sigVec = ampl * sigVec / norm(sigVec);


