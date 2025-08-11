function sig_vec = gen_qc_template(time_vec, qcCoefs)
%GEN_QC_TEMPLATE 生成二次Chirp信号模板（无SNR归一化）
%   time_vec: 时间向量
%   qcCoefs: [a1, a2, a3] 参数

phaseVec = qcCoefs(1)*time_vec + qcCoefs(2)*time_vec.^2 + qcCoefs(3)*time_vec.^3;
sig_vec = sin(2*pi*phaseVec);
sig_vec = sig_vec(:);
end
