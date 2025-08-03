function output=gen_sig(timeVec,ExprCoef)
% S=A*exp(-(t-t0)^2/(2*sigma^2))*sin(2*pi*f0*t+phi0)
% coefficient

indexVec=-(timeVec-t0).^2/(2*sigma^2);
phiVec=2*pi*f0*timeVec+phi0;
output=A*exp(indexVec)*sin(phiVec);

end