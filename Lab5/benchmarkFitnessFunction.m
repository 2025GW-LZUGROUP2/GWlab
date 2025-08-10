function [fitVal, varargout] = benchmarkFitnessFunction(xVec, params)
% 基准测试函数，用于PSO优化
% 这个函数实现了多个常用的基准测试函数，用于验证PSO算法的性能
%
% 用法:
%   fitVal = benchmarkFitnessFunction(xVec, params)
%   [fitVal, realCoords] = benchmarkFitnessFunction(xVec, params)
%
% 输入参数:
%   xVec    - 标准化坐标矩阵，每行代表一个点
%   params  - 结构体参数，包含以下字段:
%             .funcType - 函数类型 ('sphere', 'rastrigin', 'rosenbrock', 'griewank')
%             .rmin     - 实际坐标最小值向量
%             .rmax     - 实际坐标最大值向量
%
% 输出参数:
%   fitVal      - 适应度值向量
%   realCoords  - (可选)实际坐标矩阵

% 检查输入参数
if nargin < 2
    error('需要提供xVec和params两个参数');
end

if ~isfield(params, 'funcType')
    params.funcType = 'sphere';  % 默认使用sphere函数
end

if ~isfield(params, 'rmin') || ~isfield(params, 'rmax')
    error('params必须包含rmin和rmax字段');
end

% 获取输入矩阵的尺寸
[nrows, ~] = size(xVec);

% 初始化适应度值
fitVal = zeros(nrows, 1);
validPts = ones(nrows, 1);

% 检查标准化坐标是否在有效范围内 [0,1]
validPts = crcbchkstdsrchrng(xVec);

% 将无效点的适应度设为无穷大
fitVal(~validPts) = inf;

% 将标准化坐标转换为实际坐标
xVec(validPts, :) = s2rv(xVec(validPts, :), params);

% 计算每个有效点的适应度值
for i = 1:nrows
    if validPts(i)
        x = xVec(i, :);
        
        % 根据指定的函数类型计算适应度值
        switch lower(params.funcType)
            case 'sphere'
                % Sphere函数: f(x) = sum(x_i^2)
                fitVal(i) = sum(x.^2);
                
            case 'rastrigin'
                % Rastrigin函数: f(x) = A*n + sum(x_i^2 - A*cos(2*pi*x_i))
                A = 10;
                n = length(x);
                fitVal(i) = A*n + sum(x.^2 - A*cos(2*pi*x));
                
            case 'rosenbrock'
                % Rosenbrock函数: f(x) = sum(100*(x_{i+1}-x_i^2)^2 + (1-x_i)^2)
                n = length(x);
                fitVal(i) = 0;
                for j = 1:n-1
                    fitVal(i) = fitVal(i) + 100*(x(j+1) - x(j)^2)^2 + (1 - x(j))^2;
                end
                
            case 'griewank'
                % Griewank函数: f(x) = 1 + sum(x_i^2)/4000 - prod(cos(x_i/sqrt(i)))
                n = length(x);
                sum_part = sum(x.^2) / 4000;
                prod_part = 1;
                for j = 1:n
                    prod_part = prod_part * cos(x(j) / sqrt(j));
                end
                fitVal(i) = 1 + sum_part - prod_part;
                
            otherwise
                error(['未知的函数类型: ' params.funcType]);
        end
    end
end

% 如果需要返回实际坐标
if nargout > 1
    varargout{1} = xVec;
    if nargout > 2
        varargout{2} = r2sv(xVec, params);
    end
end
end