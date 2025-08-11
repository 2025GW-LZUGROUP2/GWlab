function [fitVal, varargout] = crcbqcfitfunc(xVec, params)
%CRCBQCFITFUNC 二次Chirp信号回归的适应度函数（基于Lab5代码）
%
%   输入参数：
%   xVec: 标准化坐标矩阵 (每行一个点)
%   params: 参数结构体，包含数据和范围信息
%
%   输出参数：
%   fitVal: 适应度值
%   varargout{1}: 真实坐标（如果请求）

[nVecs, ~] = size(xVec);

% 存储适应度值
fitVal = zeros(nVecs, 1);

% 检查越界坐标并标记
validPts = crcbchkstdsrchrng(xVec);

% 将无效点的适应度设为无穷大
fitVal(~validPts) = inf;

% 将有效点的标准化坐标转换为真实坐标
xVec(validPts, :) = s2rv(xVec(validPts, :), params);

for lpc = 1:nVecs
    if validPts(lpc)
        % 计算当前点的适应度
        x = xVec(lpc, :);
        fitVal(lpc) = ssrqc(x, params);
    end
end

% 如果请求，返回真实坐标
if nargout > 1
    varargout{1} = xVec;
end

end

% 残差平方和函数（在幅度参数上最大化后）
function ssrVal = ssrqc(x, params)
    % 生成归一化的二次chirp信号
    phaseVec = x(1)*params.dataX + x(2)*params.dataXSq + x(3)*params.dataXCb;
    qc = sin(2*pi*phaseVec);
    qc = qc/norm(qc);
    
    % 计算适应度
    ssrVal = -(params.dataY * qc')^2;
end
