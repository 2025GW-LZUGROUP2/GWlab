function rVec = s2rv(xVec, params)
%S2RV 将标准化坐标转换为真实坐标
%
%   输入参数：
%   xVec: 标准化坐标 (0 <= xVec <= 1)
%   params: 包含rmin和rmax字段的参数结构体
%
%   输出参数：
%   rVec: 真实坐标

[nrows, ncols] = size(xVec);
rVec = zeros(nrows, ncols);
rmin = params.rmin;
rmax = params.rmax;
rngVec = rmax - rmin;

for lp = 1:nrows
    rVec(lp, :) = xVec(lp, :) .* rngVec + rmin;
end

end
