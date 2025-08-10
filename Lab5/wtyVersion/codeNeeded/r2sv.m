function xVec = r2sv(rVec,params)
%Convert real coordinates to standardized ones.
% 将真实坐标转换为标准化坐标。
%X = R2SV(R,P)
% Takes real coordinates in R (coordinates of one point per row) and returns
% standardized coordinates in X using the range limits defined in P.rmin and
% P.rmax. The range limits can be different for different dimensions. (If
% they are same for all dimensions, use R2SS instead.)
% 接收R中的真实坐标（每行表示一个点的坐标），并使用P.rmin和P.rmax中定义的范围限制返回标准化坐标X。范围限制可以在不同维度上不同。（如果所有维度相同，请使用R2SS。）

%Soumya D. Mohanty
%May 2016
[nrows,ncols] = size(rVec);
xVec = zeros(nrows,ncols);
rmin = params.rmin;
rmax = params.rmax;
rngVec = rmax-rmin;
%If rmin = rmax for any coordinate, its standardized value should be 0.
%For such a case, only compute the difference between the
%coordinate and the minimum value and don't divide by the range
rngVec(rngVec==0)=1;
for lp = 1:nrows
    xVec(lp,:) = (rVec(lp,:)-rmin)./rngVec;
end