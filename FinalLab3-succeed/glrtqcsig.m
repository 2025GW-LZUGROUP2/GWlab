function glrt_val = glrtqcsig(time_vec, data_vec, fs, psd_vec, qcCoefs)
% 与 Python 完全一致的 “sin 单模板 + 未知幅度” GLRT：GLRT = LLR^2
time_vec = time_vec(:).';
data_vec = data_vec(:).';
sig_vec = crcbgenqcsig(time_vec, 1, qcCoefs);
templateVec = normsig4psd(sig_vec, fs, psd_vec, 1);
templateVec = templateVec(:).';
llr = innerprod_psd(data_vec, templateVec, fs, psd_vec);
glrt_val = llr^2;
end
