function validPts = crcbchkstdsrchrng(xVec)
%CRCBCHKSTDSRCHRNG 检查标准化坐标是否在有效范围内
%
%   输入参数：
%   xVec: 标准化坐标矩阵
%
%   输出参数：
%   validPts: 逻辑向量，表示哪些点是有效的

% 检查坐标是否在[0,1]范围内
validPts = all(xVec >= 0 & xVec <= 1, 2);

end
