function [F_plus,F_cross] = FpFcinDetFrame(thetaVec,phiVec,PolarAngle,DetTensor)
%Antenna pattern functions in detector local frame (arms at 90 degrees)
%[Fp,Fc]=DETFRAMEFPFC(T,P)
%Returns the antenna pattern function values Fp, Fc (corresponding to F_+
%and F_x respectively) for a given sky location in the local frame of a 
%90 degree equal arm length interferometer. The X and Y axes of the frame
%point along the arms. T is the polar angle (0 radians on the Z axis) and P
%is the azimuthal angle (0 radians on the X axis). T and P can be vectors
%(equal lengths), in which case Fp and Fc are also vectors with Fp(i) and
%Fc(i) corresponding to T(i) and P(i).

%Soumya D. Mohanty, Feb 2019

%Number of sky locations requested
nLocs = length(thetaVec);
if length(phiVec) ~= nLocs
    error('Number of theta and phi values must be the same');
end

%Obtain the components of the unit vector pointing to the source location,
%namely n, -k, or -zWav
vec2Src = [sin(thetaVec(:)).*cos(phiVec(:)),...   % ...表示当前行未结束，下一行继续属于同一语句
           sin(thetaVec(:)).*sin(phiVec(:)),...   % (:)作用是将数组展平为列向量
           cos(thetaVec(:))];
       
%Get the wave frame X and Y vector components (for multiple sky locations if needed)
xWav0Polar = vcrossprod(repmat([0,0,1],nLocs,1),vec2Src);
yWav0Polar = vcrossprod(xWav0Polar,vec2Src);

xWav =  cos(PolarAngle) * xWav0Polar + sin(PolarAngle) * yWav0Polar;
yWav = -sin(PolarAngle) * xWav0Polar + cos(PolarAngle) * yWav0Polar;


%Normalize wave frame vectors
for j = 1:nLocs
    xWav(j,:) = xWav(j,:)/norm(xWav(j,:));
    yWav(j,:) = yWav(j,:)/norm(yWav(j,:));
end

%Detector tensor of a perpendicular arm interferometer 
F_plus = zeros(1,nLocs);
F_cross = zeros(1,nLocs);
%For each location ...
for j = 1:nLocs
    %ePlus contraction with detector tensor
    PolarTensor = xWav(j,:)'*xWav(j,:) - yWav(j,:)'*yWav(j,:);
    F_plus(j) = sum(PolarTensor(:).*DetTensor(:));
    %eCross contraction with detector tensor
    PolarTensor = xWav(j,:)'*yWav(j,:) + yWav(j,:)'*xWav(j,:);
    F_cross(j) = sum(PolarTensor(:).*DetTensor(:));
end


