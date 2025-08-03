function output=gen_SineGausSig(timeVec,A,t0,sigma,f0,phi0)
% S=A*exp(-(t-t0)^2/(2*sigma^2))*sin(2*pi*f0*t+phi0)

indexVec=-(timeVec-t0).^2/(2*sigma^2);
phiVec=2*pi*f0*timeVec+phi0;
output=A*exp(indexVec)*sin(phiVec);

end