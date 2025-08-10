function ptFlags = crcbchkstdsrchrng(xVec)
%Checks for points that are outside the standardized search range 
% 检查是否有点在标准化搜索范围之外
%V = CRCBCHKSTDSRCHRNG(X)
% Returns an array of logical indices V corresponding to valid/invalid
% points in X. A row (point) of X is invalid if any of the coordinates
% (columns for that row) fall outside the closed interval [0,1].
% 返回一个逻辑索引数组V，对应于X中的有效/无效点。如果X的一行（点）的任何坐标（该行的列）落在闭区间[0,1]之外，则该点无效。
%
%Do Y = X(V,:) to retrieve only the valid rows or Y = X(~V,:) to retrieve
%invalid rows.

%Soumya D. Mohanty
%April 2012

[nrows,ncols]=size(xVec);
validPts = ones(1,nrows);
for lp = 1:nrows
    x = xVec(lp,:);
    if any(x<0|x>1)
        %Mark point as invalid
        validPts(lp) = 0;
    end
end
ptFlags = logical(validPts);
