function rVec = s2rv(xVec,params)
%Convert standardized coordinates to real using non-uniform range limits
% 使用非统一的范围限制将标准化坐标转换为真实坐标
%R = S2RV(X,P)
% Takes standardized coordinates in X (coordinates of one point per row) and
% returns real coordinates in R using the range limits defined in P.rmin and
% P.rmax. The range limits can be different for different dimensions. (If
% they are same for all dimensions, use S2RS instead.)
% 接收X中的标准化坐标（每行表示一个点的坐标），并使用P.rmin和P.rmax中定义的范围限制返回真实坐标R。范围限制可以在不同维度上不同。（如果所有维度相同，请使用S2RS。）

%Soumya D. Mohanty
%April 2012

[nrows,ncols] = size(xVec);
rVec = zeros(nrows,ncols);
rmin = params.rmin;
rmax = params.rmax;
rngVec = rmax-rmin;
for lp = 1:nrows
    rVec(lp,:) = xVec(lp,:).*rngVec+rmin;
end