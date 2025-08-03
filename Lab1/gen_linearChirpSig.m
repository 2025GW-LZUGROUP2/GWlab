function output=gen_linearChirpSig(timeVec,A,f0,f1,phi0)

phiVec=2*pi*(f0*timeVec+f1*timeVec.^2)+phi0;
output=A*sin(phiVec);
end