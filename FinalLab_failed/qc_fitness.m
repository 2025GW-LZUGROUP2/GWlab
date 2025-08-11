function fitness = qc_fitness(params, analysisData, dataX, dataXSq, dataXCb)
%QC_FITNESS 二次Chirp信号的适应度函数（基于Lab5的crcbqcfitfunc）
%
%   输入参数：
%   params: 信号参数数组 [a1, a2, a3]
%   analysisData: 分析数据
%   dataX: 时间向量
%   dataXSq: 时间向量的平方
%   dataXCb: 时间向量的立方
%
%   输出参数：
%   fitness: 适应度值（负的归一化内积的平方）

% 生成归一化的二次chirp信号模板
phaseVec = params(1)*dataX + params(2)*dataXSq + params(3)*dataXCb;
qc = sin(2*pi*phaseVec);
qc = qc/norm(qc);

% 确保analysisData是行向量，qc是列向量
analysisData = analysisData(:)';
qc = qc(:);

% 计算适应度（负的归一化内积的平方）
% 这与Lab5中的ssrqc函数一致
fitness = -(analysisData * qc)^2;

end
