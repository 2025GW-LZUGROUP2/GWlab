function glrt_val = glrtqcsig(time_vec, data_vec, fs, psd_vec, qcCoefs)
%GLRTQCSIG 计算二次Chirp信号的GLRT统计量（幅度未知）
%   time_vec: 时间向量
%   data_vec: 数据
%   fs: 采样频率
%   psd_vec: 正频率上的PSD（长度为N/2+1）
%   qcCoefs: [a1, a2, a3] 参数

% 生成单位范数模板
sig_vec = gen_qc_template(time_vec, qcCoefs);
templateVec = normsig4psd(sig_vec, fs, psd_vec, 1);

% 计算数据与模板的内积
llr = innerprod_psd(data_vec, templateVec, fs, psd_vec);

% 返回GLRT统计量
glrt_val = llr^2;
end
